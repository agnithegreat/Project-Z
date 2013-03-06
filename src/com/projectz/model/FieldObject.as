/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
import com.projectz.event.GameEvent;

import starling.events.EventDispatcher;

public class FieldObject extends EventDispatcher {

    protected var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    protected var _mask: Array;
    public function get mask():Array {
        return _mask;
    }

    public function get positionX():Number {
        return _cell.x;
    }
    public function get positionY():Number {
        return _cell.y;
    }

    private var _size: Array;

    private var _depth: int;
    public function get depth():int {
        return _depth;
    }
    public function set depth(value:int):void {
        _depth = value;
    }

    public function FieldObject($mask: Array = null) {
        _mask = $mask ? $mask : [[1]];
        createSize();
    }

    private function createSize():void {
        _size = [];
        for (var i:int = 0; i < _mask.length; i++) {
            _size[i] = [];
            for (var j:int = 0; j < _mask[i].length; j++) {
                _size[i][j] = false;
            }
        }
    }

    public function clearSize():void {
        for (var i:int = 0; i < _mask.length; i++) {
            for (var j:int = 0; j < _mask[i].length; j++) {
                _size[i][j] = false;
            }
        }
    }

    public function markSize($x: int, $y: int):void {
        var tx: int = (_size.length-1)-(_cell.x-$x);
        var ty: int = (_size[0].length-1)-(_cell.y-$y);
        _size[tx][ty] = true;
    }

    public function get sizeChecked():Boolean {
        return _size[0][_size[0].length-1] && _size[_size.length-1][0];
    }

    public function place($cell: Cell):void {
        _cell = $cell;
    }

    public function update():void {
        dispatchEventWith(GameEvent.UPDATE);
    }

    public function destroy():void {
        _cell = null;

        for (var i:int = 0; i < _mask.length; i++) {
            for (var j:int = 0; j < _mask[i].length; j++) {
                _mask[i][j] = null;
            }
            _mask[i] = null;
        }
        _mask = null;

        for (i = 0; i < _size.length; i++) {
            for (j = 0; j < _size[i].length; j++) {
                _size[i][j] = null;
            }
            _size[i] = null;
        }
        _size = null;
    }
}
}
