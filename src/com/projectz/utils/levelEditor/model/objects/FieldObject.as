/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.objects {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;

import starling.events.EventDispatcher;

/**
 * Часть объекта для отображения на карте.
 * Любая часть любого объекта, создана для того, чтобы сортировать все части всех объектов.
 */
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
    public function get size():Array {
        return _size;
    }
    public function get sizeChecked():Boolean {
        if (_data.width==_data.height==1) {
            return true;
        }
        return _size[_data.left.x][_data.left.y] && _size[_data.right.x][_data.right.y];
    }

    private var _placeData: PlaceData;
    public function get placeData():PlaceData {
        return _placeData;
    }

    protected var _data: PartData;
    public function get data():PartData {
        return _data;
    }

    public function FieldObject($data:PartData, $placeData: PlaceData) {
        _data = $data;
        _placeData = $placeData;
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
