/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.objects.Defender;
import com.projectz.game.model.objects.FieldObject;
import com.projectz.game.model.objects.Enemy;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.pathFinding.Grid;
import com.projectz.utils.pathFinding.Path;
import com.projectz.utils.pathFinding.PathFinder;

import flash.geom.Point;

import starling.events.EventDispatcher;

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

    private var _generators: Vector.<Generator>;

    private var _enemies: Vector.<Enemy>;
    private var _defenders: Vector.<Defender>;

    public function Field($width: int, $height: int, $objectsStorage: ObjectsStorage, $level: LevelData) {
        _width = $width;
        _height = $height;

        _grid = new Grid(_width, _height);

        _objectsStorage = $objectsStorage;
        _objects = new <FieldObject>[];
        _generators = new <Generator>[];
        _enemies = new <Enemy>[];
        _defenders = new <Defender>[];

        _level = $level;
        createField();
    }

    public function init():void {
        createPaths(_level.paths);
        createObjects(_level.objects);
        updateDepths();
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
        var mark: Array;
        var ind: int;
        var tries: int = 100;
        while (len && tries-->0) {
            for (i = 0; i < len; i++) {
                cell = toCheck[i];
                if (cell && checkUpperCells(cell)) {
                    mark = [];
                    object = cell.object;
                    if (object && object.data.width>1 && object.data.height>1) {
                        object.markSize(cell.x, cell.y);
                        if (object.sizeChecked) {
                            mark = mark.concat(getObjectCells(object));
                            object.clearSize();
                        }
                    } else {
                        mark.push(cell);
                    }
                    var markLen: int = mark.length;
                    for (var k: int = 0; k < markLen; k++) {
                        mark[k].depth = ++index;
                    }
                }
            }
            for (k = 0; k < len; k++) {
                if (toCheck[k].depth) {
                    toCheck.splice(k--, 1);
                    len--;
                }
            }
        }
    }

    private function getObjectCells($object: FieldObject):Array {
        var cells: Array = [];
        for (var i:int = 0; i < $object.data.width; i++) {
            for (var j:int = 0; j < $object.data.height; j++) {
                if ($object.data.mask[i][j]) {
                    cells.push(getCell($object.cell.x+i-$object.data.top.x, $object.cell.y+j-$object.data.top.y));
                }
            }
        }
        return cells;
    }

    private function checkUpperCells($cell: Cell):Boolean {
        var object: FieldObject = $cell.object;
        var cell: Cell = getCell($cell.x, $cell.y-1);
        if (cell && !cell.depth && (!object || cell.object!=object)) {
            return false;
        }
        cell = getCell($cell.x-1, $cell.y);
        if (cell && !cell.depth && (!object || cell.object!=object)) {
            return false;
        }
        return true;
    }

    public function step($delta: Number):void {
        var len: int = _enemies.length;
        var zombie:Enemy;

        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            zombie = _enemies[i];
//            if (zombie.alive && !zombie.target) {
//                while (!cell || cell.locked) {
//                    cell = getRandomCell();
//                }
//                zombie.walk(getWay(zombie.cell, cell));
//                cell = null;
//            }
            zombie.step($delta);
        }

        len = _generators.length;
        for (i = 0; i < len; i++) {
            var enemy: PlaceData = _generators[i].createEnemy();
            if (enemy) {
                createPersonage(enemy.x, enemy.y, _objectsStorage.getObjectData(enemy.object).parts[""]);
            }
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

    private function createPaths($paths: Vector.<PathData>):void {
        var len: int = $paths.length;
        for (var i: int = 0; i < len; i++) {
            var path: PathData = $paths[i];
            for (var j:int = 0; j < path.points.length; j++) {
                var point: Point = path.points[j];
                _grid.setPath(point.x, point.y, path.id);
            }
        }
    }

    private function createObjects($objects: Vector.<PlaceData>):void {
        _objects = new <FieldObject>[];

        var len: int = $objects.length;
        for (var i: int = 0; i < len; i++) {
            var obj: PlaceData = $objects[i];
            var objData: ObjectData = _objectsStorage.getObjectData(obj.object);
            if (objData.type == ObjectData.ENEMY) {
                addGenerator(obj);
            } else {
                createObject(obj.x, obj.y, objData);
            }
        }
    }

    private function addGenerator($data: PlaceData):void {
        // TODO: Вынести параметры частоты и количества в редактор
        _generators.push(new Generator($data.x, $data.y, $data.object, 60, 10));
    }

    private function createObject($x: int, $y: int, $data: ObjectData):void {
        for each (var part: PartData in $data.parts) {
            if (part.name!="shadow") {
                createPart($x, $y, part);
            } else {
                createShadow($x, $y, part);
            }
        }
    }

    private function createPart($x: int, $y: int, $data: PartData):void {
        var object: FieldObject = new FieldObject($data);

        var cell: Cell;
        for (var i:int = 0; i < object.data.mask.length; i++) {
            for (var j:int = 0; j < object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    cell.lock();
                    if (object.data.mask[i][j]==1) {
                        _grid.setWalkable(cell.x, cell.y, false);
                        cell.addObject(object);
                    }
                }
            }
        }
        object.place(getCell($x+object.data.top.x, $y+object.data.top.y));
        _objects.push(object);

        dispatchEventWith(GameEvent.OBJECT_ADDED, false, object);
    }

    private function createShadow($x: int, $y: int, $data: PartData):void {
        var shadow: FieldObject = new FieldObject($data);
        var cell: Cell = getCell($x, $y);
        cell.shadow = shadow;
        shadow.place(cell);

        dispatchEventWith(GameEvent.SHADOW_ADDED, false, shadow);
    }

    private function createPersonage($x: int, $y: int, $data: PartData):void {
        var zombie: Enemy = new Enemy($data);
        _objects.push(zombie);

        var cell: Cell = getCell($x, $y);
        cell.lock();
        cell.addObject(zombie);
        zombie.place(cell);
        _enemies.push(zombie);

        dispatchEventWith(GameEvent.OBJECT_ADDED, false, zombie);
    }

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
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
