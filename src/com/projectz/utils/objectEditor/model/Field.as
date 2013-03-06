/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.model {

import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    public static const ADD_OBJECT: String = "add_object_Field";

    private var _width: int;
    public function get width():int {
        return _width;
    }

    private var _height: int;
    public function get height():int {
        return _height;
    }

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _object: FieldObject;
    public function get object():FieldObject {
        return _object;
    }

    public function Field($width: int, $height: int) {
        _width = $width;
        _height = $height;
    }

    public function init():void {
        createField();
    }

    public function addObject($data: ObjectData):void {
        if (_object) {
            _object.destroy();
            _object = null;
        }

        _object = new FieldObject($data);
        _object.place(getCell(0,0));

        dispatchEventWith(ADD_OBJECT);
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                cell = new Cell(i, j);
                _field.push(cell);
                _fieldObj[i+"."+j] = cell;
            }
        }
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
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
