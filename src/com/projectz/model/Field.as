/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
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

    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    public function Field($width: int, $height: int) {
        _width = $width;
        _height = $height;
    }

    public function init():void {
        createField();
    }

    private function createField():void {
        _field = new <Cell>[];
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                var cell: Cell = new Cell(i, j);
                _field.push(cell);
            }
        }
    }

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;
    }
}
}
