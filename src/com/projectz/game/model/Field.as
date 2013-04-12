/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.objects.Building;
import com.projectz.game.model.objects.Defender;
import com.projectz.game.model.objects.FieldObject;
import com.projectz.game.model.objects.Enemy;
import com.projectz.game.model.objects.Generator;
import com.projectz.game.model.objects.Personage;
import com.projectz.utils.levelEditor.data.DataUtils;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.objectEditor.data.DefenderData;
import com.projectz.utils.objectEditor.data.EnemyData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.objectEditor.data.TargetData;
import com.projectz.utils.pathFinding.Grid;
import com.projectz.utils.pathFinding.Path;
import com.projectz.utils.pathFinding.PathFinder;

import flash.geom.Point;

import starling.events.EventDispatcher;
import starling.events.Event;

public class Field extends EventDispatcher {

    private var _width: int;
    public function get width():int {
        return _width;
    }

    private var _height: int;
    public function get height():int {
        return _height;
    }

    private var _objectsStorage: ObjectsStorage;

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _grid: Grid;

    private var _level: LevelData;
    public function get level():LevelData {
        return _level;
    }

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    private var _targets: Vector.<Building>;
    private var _targetCells: Vector.<Cell>;

    private var _generators: Vector.<Generator>;

    private var _enemies: Vector.<Enemy>;
    private var _defenders: Vector.<Defender>;

    private var _waveTime: Number;
    private var _wave: int;

    public function Field($width: int, $height: int, $objectsStorage: ObjectsStorage, $level: LevelData) {
        _width = $width;
        _height = $height;

        _grid = new Grid(_width, _height);

        _objectsStorage = $objectsStorage;
        _objects = new <FieldObject>[];
        _targets = new <Building>[];
        _targetCells = new <Cell>[];
        _generators = new <Generator>[];
        _enemies = new <Enemy>[];
        _defenders = new <Defender>[];

        _level = $level;
        createField();
    }

    public function init():void {
        createPaths(_level.paths);
        createGenerators(_level.generators);
        createPositions(_level.defenderPositions);
        createObjects(_level.objects);
        updateDepths();

        _wave = 0;
        _waveTime = 0;
        nextWave();
    }

    public function nextWave():void {
        _wave++;

        if (_level.waves.length>=_wave) {
            _waveTime = _level.waves[_wave-1].time;

            var len: int = _generators.length;
            for (var i:int = 0; i < len; i++) {
                _generators[i].initWave(_wave);
            }
        } else {
            // TODO: endGame
        }
    }

    private function checkWaveEnded():Boolean {
        if (_waveTime<=0) {
            return true;
        }
        var len: int = _generators.length;
        for (var i:int = 0; i < len; i++) {
            if (_generators[i].enabled) {
                return false;
            }
        }
        return !_enemies.length;
    }

    private function updateDepths():void {
        var toCheck: Vector.<Cell> = new <Cell>[];

        var object: FieldObject;
        var cell: Cell;
        var len: int = _field.length;
        for (var i:int = 0; i < len; i++) {
            _field[i].depth = 0;
            toCheck.push(_field[i]);
        }

        var index: int = 0;
        var tries: int = 100;
        var checkedObjects: Array = [];
        while (len && tries-->0) {
            for (i = 0; i < len; i++) {
                cell = toCheck[i];
                if (!cell.depth && checkUpperCells(cell)) {
                    object = cell.object;
                    if (object && object.data.width>1 && object.data.height>1) {
                        object.markSize(cell.x, cell.y);
                        checkedObjects.push(object);
                        if (object.sizeChecked) {
                            setObjectDepth(object, ++index);
                        }
                    } else {
                        cell.depth = ++index;
                    }
                }
            }
            while (checkedObjects.length>0) {
                checkedObjects.pop().clearSize();
            }
            for (var k: int = 0; k < len; k++) {
                if (toCheck[k].depth) {
                    toCheck.splice(k--, 1);
                    len--;
                }
            }
        }
    }

    private function setObjectDepth($object: FieldObject, $depth: int):void {
        for (var i:int = 0; i < $object.data.width; i++) {
            for (var j:int = 0; j < $object.data.height; j++) {
                if ($object.data.mask[i][j]) {
                    var cell: Cell = getCell($object.cell.x+i-$object.data.top.x, $object.cell.y+j-$object.data.top.y);
                    cell.depth = $depth;
                }
            }
        }
    }

    private function checkUpperCells($cell: Cell):Boolean {
        return checkUpperCell( getCell($cell.x, $cell.y-1), $cell.object ) &&
                checkUpperCell( getCell($cell.x-1, $cell.y), $cell.object );
    }

    private function checkUpperCell($cell: Cell, $object: FieldObject):Boolean {
        return !$cell || $cell.depth || ($cell.object && $cell.object==$object);
    }

    public function step($delta: Number):void {
        _waveTime -= $delta;

        var len: int = _enemies.length;
        var cell: Cell;

        var zombie:Enemy;
        for (var i:int = 0; i < len; i++) {
            zombie = _enemies[i];
            if (zombie.alive) {
                if (!zombie.target) {
                    cell = getTargetCell(zombie.cell);
                    zombie.go(getWay(zombie.cell, cell, zombie.path)[0]);
                }
                zombie.step($delta);
            }
        }

        len = _defenders.length;
        var defender: Defender;
        for (i = 0; i < len; i++) {
            defender = _defenders[i];
            defender.step();
        }

        len = _generators.length;
        for (i = 0; i < len; i++) {
            var enemy: PlaceData = _generators[i].createEnemy();
            if (enemy) {
                createPersonage(enemy.x, enemy.y, _objectsStorage.getObjectData(enemy.object), _generators[i].path);
            }
        }

        if (checkWaveEnded()) {
            nextWave();
        }

        dispatchEventWith(GameEvent.UPDATE);
    }

    private function getWay($start: Cell, $end: Cell, $path: int = 0):Vector.<Cell> {
        var way: Vector.<Cell> = new <Cell>[];
        _grid.setStartNode($start.x, $start.y);
        _grid.setEndNode($end.x, $end.y);
        var path: Path = PathFinder.findPath(_grid, $path);
        var len: int = path.path.length;
        for (var i:int = 1; i < len; i++) {
            way.push(getCell(path.path[i].x, path.path[i].y));
        }
        return way;
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                if (i+j>0.4*_width && i+j<1.6*_width && Math.abs(i-j)<0.4*_height) {
                    cell = new Cell(i, j);
                    cell.addEventListener(GameEvent.CELL_WALK, handleUpdateCell);
                    _field.push(cell);
                    _fieldObj[i+"."+j] = cell;
                }
            }
        }
        _field.sort(sortField);
    }

    private function sortField($cell1: Cell, $cell2: Cell):int {
        if ($cell1.sorter>$cell2.sorter) {
            return 1;
        } else if ($cell1.sorter<$cell2.sorter) {
            return -1;
        }
        return 0;
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    private var _tempCell: Cell;
    private function getTargetCell($cell: Cell):Cell {
        _tempCell = $cell;
        _targetCells.sort(sortTargets);
        return _targetCells[0];
    }

    private function sortTargets($cell1: Cell, $cell2: Cell):int {
        if (!checkCellAvailable($cell1)) {
            return 1;
        }
        if (!checkCellAvailable($cell2)) {
            return -1;
        }
        var d1: int = Cell.getDistance(_tempCell, $cell1);
        var d2: int = Cell.getDistance(_tempCell, $cell2);
        if (d1 > d2) {
            return 1;
        } else if (d1 < d2) {
            return -1;
        }
        return 0;
    }

    private function checkCellAvailable($cell:Cell):Boolean {
        for (var i:int = -1; i <= 1; i++) {
            for (var j:int = -1; j <= 1; j++) {
                if (i || j) {
                    var cell: Cell = getCell($cell.x+i, $cell.y+j);
                    if (cell && cell.walkable) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private function getArea($cells: Vector.<Point>, $x: int, $y: int, $radius: int):Vector.<Cell> {
        var area: Vector.<Cell> = new <Cell>[];
        var len: int = $cells.length;
        for (var i:int = 0; i < len; i++) {
            var point: Point = $cells[i];
            var dx: int = $x-point.x;
            var dy: int = $y-point.y;
            var d: int = dx*dx+dy*dy;

            var cell: Cell = getCell(point.x, point.y);
            if (cell && d <= $radius*$radius) {
                area.push(cell);
            }
        }
        return area;
    }

    private function createPaths($paths: Vector.<PathData>):void {
        var len: int = $paths.length;
        for (var i: int = 0; i < len; i++) {
            var path: PathData = $paths[i];
            for (var j:int = 0; j < path.points.length; j++) {
                var point: Point = DataUtils.stringDataToPoint(path.points[j]);
                _grid.setPath(point.x, point.y, path.id);
            }
        }
    }

    private function createGenerators($generators: Vector.<GeneratorData>):void {
        var len: int = $generators.length;
        for (var i: int = 0; i < len; i++) {
            _generators.push(new Generator($generators[i]));
        }
    }

    private function createPositions($positions: Vector.<DefenderPositionData>):void {
        var len: int = $positions.length;
        for (var i:int = 0; i < len; i++) {
            var pos: DefenderPositionData = $positions[i];
            var cell: Cell = getCell(pos.x, pos.y);
            cell.positionData = pos;
        }
    }

    private function createObjects($objects: Vector.<PlaceData>):void {
        _objects = new <FieldObject>[];

        var len: int = $objects.length;
        for (var i: int = 0; i < len; i++) {
            var obj: PlaceData = $objects[i];
            var object: ObjectData = _objectsStorage.getObjectData(obj.object);
            if (object is TargetData) {
                createTarget(obj.x, obj.y, object as TargetData);
            } else {
                createObject(obj.x, obj.y, object);
            }
        }
    }

    public function blockCell($x: int, $y: int):void {
        var cell: Cell = getCell($x, $y);
        if (cell.positionData && !cell.object) {
            createPersonage($x, $y, _objectsStorage.getObjectData("de-sheriff"));
        }
    }

    private function createTarget($x: int, $y: int, $data: TargetData):void {
        var target: Building = new Building($data.getPart(), $data.shadow, $data);
        createPart($x, $y, target);
        _targets.push(target);

        createAttackArea(target);
    }

    private function createAttackArea($object: FieldObject):void {
        var x: int = $object.positionX-1;
        var y: int = $object.positionY-1;
        var width: int = $object.data.width+2;
        var height: int = $object.data.height+2;
        for (var i:int = x; i < x+width; i++) {
            for (var j:int = y; j < y+height; j++) {
                var cell: Cell = getCell(i, j);
                if (cell) {
                    if ($object.checkCell(i, j)) {
                        _targetCells.push(cell);
                    } else {
                        cell.attackObject = $object;
                    }
                }
            }
        }
    }

    private function createObject($x: int, $y: int, $data: ObjectData):void {
        for each (var part: PartData in $data.parts) {
            var object: FieldObject = new FieldObject(part, !part.top.x && !part.top.y ? $data.shadow : null);
            createPart($x, $y, object);
        }
    }

    private function createPart($x: int, $y: int, $object: FieldObject):void {
        var cell: Cell;
        for (var i:int = 0; i < $object.data.mask.length; i++) {
            for (var j:int = 0; j < $object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    if ($object.data.mask[i][j]==1) {
                        _grid.setWalkable(cell.x, cell.y, false);
                        cell.addObject($object);
                        cell.walkable = false;
                    }
                }
            }
        }
        $object.place(getCell($x+$object.data.top.x, $y+$object.data.top.y));
        _objects.push($object);

        dispatchEventWith(GameEvent.OBJECT_ADDED, false, $object);
    }

    private function createPersonage($x: int, $y: int, $data: ObjectData, $path: int = 0):void {
        var personage: Personage;
        if ($data is EnemyData) {
            var enemy: Enemy = new Enemy($data as EnemyData, $path);
            enemy.addEventListener(GameEvent.ENEMY_DIE, handleEnemyDie);
            personage = enemy;
            _enemies.push(enemy);
        } else if ($data is DefenderData) {
            var defender: Defender = new Defender($data as DefenderData);
            _defenders.push(defender);
            personage = defender;
        }

        if (personage) {
            var cell: Cell = getCell($x, $y);
            personage.place(cell);

            if (personage is Defender) {
                defender.watch(getArea(cell.positionData.area, $x, $y, defender.radius));
//                createAttackArea(personage);
            }

            dispatchEventWith(GameEvent.OBJECT_ADDED, false, personage);
        }
    }

    private function handleEnemyDie($event: Event):void {
        var enemy: Enemy = $event.currentTarget as Enemy;
        var index: int = _enemies.indexOf(enemy);
        if (index>=0) {
            _enemies.splice(index, 1);
        }
    }

    private function handleUpdateCell($e: Event):void {
        var cell: Cell = $e.currentTarget as Cell;
        _grid.setWalkable(cell.x, cell.y, cell.walkable);

        var enemy: Enemy;
        var len: int = _enemies.length;
        for (var i:int = 0; i < len; i++) {
            enemy = _enemies[i];
            if (cell.object!=enemy && enemy.target==cell) {
                var target: Cell = getTargetCell(enemy.target);
                enemy.go(getWay(enemy.target, getCell(target.x, target.y), enemy.path)[0]);
            }
        }
    }

    public function destroy():void {
        while (_field.length>0) {
            _field[0].removeEventListeners();
            _field.shift().destroy();
        }
        _field = null;

        for (var id: String in _fieldObj) {
            delete _fieldObj[id];
        }
        _fieldObj = null;

        _grid.destroy();
        _grid = null;

        while (_enemies.length>0) {
            _enemies.pop().destroy();
        }
        _enemies = null;

        while (_defenders.length>0) {
            _defenders.pop().destroy();
        }
        _defenders = null;
    }
}
}
