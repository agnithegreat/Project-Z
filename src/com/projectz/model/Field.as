/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
import com.projectz.event.GameEvent;
import com.projectz.model.objects.FieldObject;
import com.projectz.model.objects.Zombie;
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.pathFinding.Grid;
import com.projectz.utils.pathFinding.Path;
import com.projectz.utils.pathFinding.PathFinder;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    public static var TREES: int = 30;
    public static var ZOMBIES: int = 0;

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

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    private var _grid: Grid;

    private var _zombies: Vector.<Zombie>;

    public function Field($width: int, $height: int) {
        _width = $width;
        _height = $height;

        _grid = new Grid(_width, _height);

        createField();
    }

    public function init($objectsStorage: ObjectsStorage):void {
        _objectsStorage = $objectsStorage;

        createObjects();
        createPersonages();
    }

    public function step($delta: Number):void {
        updateDepths();

        var len: int = _zombies.length;
        var zombie:Zombie;

        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            zombie = _zombies[i];
            if (zombie.alive && !zombie.target) {
                while (!cell || cell.locked) {
                    cell = getRandomCell();
                }
                zombie.walk(getWay(zombie.cell, cell));
                cell = null;
            }
            zombie.step($delta);
        }
        dispatchEventWith(GameEvent.UPDATE);
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

        // TODO: optimize that
        var index: int = 0;
        var mark: Array;
        var ind: int;
        var tries: int = 20;
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

    private function getWay($start: Cell, $end: Cell):Vector.<Cell> {
        var way: Vector.<Cell> = new <Cell>[];
        _grid.setStartNode($start.x, $start.y);
        _grid.setEndNode($end.x, $end.y);
        var path: Path = PathFinder.findPath(_grid);
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

    private function getRandomCell():Cell {
        var rand: int = Math.random()*_field.length;
        return _field[rand];
    }

    private function getRandomObject():String {
        var rand: int = Math.random()*3;
        switch (rand) {
            case 0:
                return "so-tree-01";
            case 1:
                return "so-tree-02";
            case 2:
                return "so-barrel-01";
        }
        return "";
    }

    private function createObjects():void {
        _objects = new <FieldObject>[];

        createObject(_width/3, _height/3, _objectsStorage.getObjectData("so-testcar"));
        createObject(_width/2, _height/2, _objectsStorage.getObjectData("so-test-ambar"));

        var cell: Cell;
        for (var i: int = 0; i < TREES; i++) {
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            createObject(cell.x, cell.y, _objectsStorage.getObjectData(getRandomObject()));
        }
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

    public function createZombie($x: int, $y: int):void {
        var cell: Cell = getCell($x, $y);
        if (cell && !cell.object) {
            createPersonage($x, $y, _objectsStorage.getObjectData("zombie").parts[""]);
        }
    }

    private function createPersonages():void {
        _zombies = new <Zombie>[];

        createPersonage(_width/2+1, _height/2+1, _objectsStorage.getObjectData("zombie").parts[""]);

        var cell: Cell;
        for (var i:int = 0; i < ZOMBIES; i++) {
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            createPersonage(cell.x, cell.y, _objectsStorage.getObjectData("zombie").parts[""]);
            cell = null;
        }
    }

    private function createPersonage($x: int, $y: int, $data: PartData):void {
        var zombie: Zombie = new Zombie($data);
        _objects.push(zombie);

        var cell: Cell = getCell($x, $y);
        cell.lock();
        cell.addObject(zombie);
        zombie.place(cell);
        _zombies.push(zombie);

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

        while (_zombies.length>0) {
            _zombies.pop().destroy();
        }
        _zombies = null;
    }
}
}
