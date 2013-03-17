/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {

import com.projectz.event.GameEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;

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

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    public function Field($width: int, $height: int) {
        _width = $width;
        _height = $height;
    }

    public function init($objectsStorage: ObjectsStorage):void {
        _objectsStorage = $objectsStorage;

        createField();
        createObjects();
    }

    public function step($delta: Number):void {
        updateDepths();
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
//        for (var i: int = 0; i < TREES; i++) {
//            while (!cell || cell.locked) {
//                cell = getRandomCell();
//            }
//            createObject(cell.x, cell.y, _objectsStorage.getObjectData("so-tree-0"+int(Math.random()*2+1)));
//        }
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
//                        _grid.setWalkable(cell.x, cell.y, false);
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

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;

        for (var id: String in _fieldObj) {
            delete _fieldObj[id];
        }
        _fieldObj = null;
    }
}
}