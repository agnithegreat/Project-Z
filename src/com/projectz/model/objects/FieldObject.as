/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model.objects {
import com.projectz.event.GameEvent;
import com.projectz.model.Cell;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

public class FieldObject extends EventDispatcher {

    protected var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }
    public function get positionX():Number {
        return _cell.x;
    }
    public function get positionY():Number {
        return _cell.y;
    }

    protected var _size: Array;
    public function get sizeChecked():Boolean {
        return _size[0][_size[0].length-1] && _size[_size.length-1][0];
    }

    private var _depth: int;
    public function get depth():int {
        return _depth;
    }
    public function set depth(value:int):void {
        _depth = value;
    }

    protected var _data: ObjectData;
    public function get data():ObjectData {
        return _data;
    }

    public function FieldObject($data:ObjectData) {
        _data = $data;
        createSize();
    }

    protected function createSize():void {
        _size = [];
        for (var i:int = 0; i < _data.mask.length; i++) {
            _size[i] = [];
            for (var j:int = 0; j < _data.mask[i].length; j++) {
                _size[i][j] = false;
            }
        }
    }
    public function clearSize():void {
        for (var i:int = 0; i < _size.length; i++) {
            for (var j:int = 0; j < _size[i].length; j++) {
                _size[i][j] = false;
            }
        }
    }
    public function markSize($x: int, $y: int):void {
        var tx: int = $x-_cell.x;
        var ty: int = $y-_cell.y;
        _size[tx][ty] = true;
    }

    public function place($cell: Cell):void {
        _cell = $cell;
    }

    public function update():void {
        dispatchEventWith(GameEvent.UPDATE);
    }

    public function destroy():void {
        _cell = null;

        for (var i:int = 0; i < _size.length; i++) {
            for (var j: int = 0; j < _size[i].length; j++) {
                _size[i][j] = null;
            }
            _size[i] = null;
        }
        _size = null;

        _data = null;
    }
}
}
