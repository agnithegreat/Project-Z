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

    public static var TREES: int = 0;
    public static var ZOMBIES: int = 50;

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
    }

    public function init($objectsStorage: ObjectsStorage):void {
        _objectsStorage = $objectsStorage;

        createField();
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
        var len: int = _field.length;
        var cell: Cell;
        for (var k:int = 0; k < _objects.length; k++) {
            object = _objects[k];
            object.clearSize();
            object.depth = 0;
        }

        var index: int = 0;
        var object: FieldObject;
        for (var i: int = 0; i < _width+_height; i++) {
            for (var j:int = 0; j <= i; j++) {
                cell = getCell(i-j, j);
                if (cell) {
                    len = cell.objects.length;
                    for (k = 0; k < len; k++) {
                        object = cell.objects[k];
                        if (!object.depth) {
                            object.markSize(cell.x, cell.y);
                            if (object.sizeChecked) {
                                object.depth = ++index;
                            }
                        }
                    }
                }
            }
        }
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
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    private function getRandomCell():Cell {
        var rand: int = Math.random()*_field.length;
        return _field[rand];
    }

    private function createObjects():void {
        _objects = new <FieldObject>[];

        createObject(_width/2, _height/2, _objectsStorage.getObjectData("so-test-ambar"));

        var cell: Cell;
        for (var i: int = 0; i < TREES; i++) {
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            createObject(cell.x, cell.y, _objectsStorage.getObjectData("so-tree-0"+int(Math.random()*2+1)));
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
                    if (object.data.mask[i][j]==1) {
                        cell.lock();
                        _grid.setWalkable(cell.x, cell.y, false);
                        cell.addObject(object);
                    }
                }
            }
        }
        object.place(getCell($x+object.data.top.x, $y+object.data.top.y));
        _objects.push(object);
    }

    private function createShadow($x: int, $y: int, $data: PartData):void {
        var shadow: FieldObject = new FieldObject($data);
        var cell: Cell = getCell($x, $y);
        cell.shadow = shadow;
        shadow.place(cell);
    }

    private function createPersonages():void {
        _zombies = new <Zombie>[];

        createZombie(_width/2+1, _height/2+1, _objectsStorage.getObjectData("zombie").parts[""]);

        var cell: Cell;
        for (var i:int = 0; i < ZOMBIES; i++) {
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            createZombie(cell.x, cell.y, _objectsStorage.getObjectData("zombie").parts[""]);
            cell = null;
        }
    }

    private function createZombie($x: int, $y: int, $data: PartData):void {
        var zombie: Zombie = new Zombie($data);
        _objects.push(zombie);

        var cell: Cell = getCell($x, $y);
        cell.lock();
        cell.addObject(zombie);
        zombie.place(cell);
        _zombies.push(zombie);
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
