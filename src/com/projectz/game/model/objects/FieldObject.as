/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;

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
        if (_data.width==_data.height==1) {
            return true;
        }
        return _size[_data.left.x][_data.left.y] && _size[_data.right.x][_data.right.y];
    }

    protected var _data: PartData;
    public function get data():PartData {
        return _data;
    }

    protected var _shadow: PartData;
    public function get shadow():PartData {
        return _shadow;
    }

    public function FieldObject($data:PartData, $shadow:PartData) {
        _data = $data;
        _shadow = $shadow;
        createSize();
    }

    protected function createSize():void {
        _size = [];
        for (var i:int = 0; i < _data.mask.length; i++) {
            _size[i] = [];
            for (var j:int = 0; j < _data.mask[i].length; j++) {
                _size[i][j] = 0;
            }
        }
    }
    public function clearSize():void {
        for (var i:int = 0; i < _size.length; i++) {
            for (var j:int = 0; j < _size[i].length; j++) {
                _size[i][j] = 0;
            }
        }
    }
    public function markSize($x: int, $y: int):void {
        var tx: int = $x-_cell.x+_data.top.x;
        var ty: int = $y-_cell.y+_data.top.y;
        if (tx>=0 && ty>=0 && tx<_data.width && ty<data.height) {
            _size[tx][ty] = 1;
        }
    }

    public function checkCell($x: int, $y: int):Boolean {
        var tx: int = $x-_cell.x+_data.top.x;
        var ty: int = $y-_cell.y+_data.top.y;
        if (tx>=0 && ty>=0 && tx<_data.width && ty<data.height) {
            return true;
        }
        return false;
    }

    public function place($cell: Cell):void {
        _cell = $cell;
        _cell.addObject(this);
    }

    public function update():void {
        dispatchEventWith(GameEvent.UPDATE);
    }

    public function destroy():void {
        removeEventListeners();

        _cell = null;

        for (var i:int = 0; i < _size.length; i++) {
            for (var j: int = 0; j < _size[i].length; j++) {
                _size[i][j] = null;
            }
            _size[i] = null;
        }
        _size = null;

        _data = null;
        _shadow = null;
    }
}
}
