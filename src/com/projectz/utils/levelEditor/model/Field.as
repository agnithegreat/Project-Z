/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {

import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    private var _width: int;
    private var _height: int;

    private var _objectsStorage: ObjectsStorage;

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;

    public function Field ($width: int, $height: int) {
        _width = $width;
        _height = $height;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get width():int {
        return _width;
    }

    public function set width(value:int):void {
        _width = value;

    }

    public function get height():int {
        return _height;
    }

    public function get field():Vector.<Cell> {
        return _field;
    }

    public function init($objectsStorage: ObjectsStorage):void {
        _objectsStorage = $objectsStorage;

        createField();
        createObjects();
    }

    public function step($delta: Number):void {
        updateDepths();
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

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //MAP:
    /////////////////////////////////////////////

    private function updateDepths():void {
        var len: int = _field.length;
        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            cell = _field[i];
            if (cell && cell.object) {
                cell.object.depth = 0;
                cell.object.clearSize();
            }
        }

        var index: int = 0;
        for (i = 0; i < _width+_height; i++) {
            for (var j:int = 0; j <= i; j++) {
                cell = getCell(i-j, j);
                if (cell && cell.object && !cell.object.depth) {
                    cell.object.markSize(cell.x, cell.y);
                    if (cell.object.sizeChecked) {
                        cell.object.depth = ++index;
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

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    private function createObjects():void {
        createObject(_width/2, _height/2, _objectsStorage.getObjectData ("so-testcar"));

        var cell: Cell;
//        for (var i: int = 0; i < TREES; i++) {
//            while (!cell || cell.locked || cell.object) {
//                cell = getRandomCell();
//            }
//            createObject(cell.x, cell.y, _objects["so-tree-01"]);
//        }
    }

    private function createObject($x: int, $y: int, $data: ObjectData):void {
        var object: FieldObject = new FieldObject($data);

        var cell: Cell;
        for (var i:int = 0; i < object.data.mask.length; i++) {
            for (var j:int = 0; j < object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    if (object.data.mask[i][j]==1) {
                        cell.lock();
                    }
                    cell.object = object;
                }
            }
        }
        object.place(getCell($x, $y));
    }

}
}
