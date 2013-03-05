/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
import com.projectz.event.GameEvent;

import flash.geom.Point;

import starling.events.EventDispatcher;

public class FieldObject extends EventDispatcher {

    protected var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    protected var _size: Array;
    public function get size():Array {
        return _size;
    }

    public function get positionX():Number {
        return _cell.x;
    }
    public function get positionY():Number {
        return _cell.y;
    }

    public function FieldObject($size: Array = null) {
        _size = $size ? $size : [[new Point(0,0)]];
    }

    public function place($cell: Cell):void {
        _cell = $cell;
    }

    public function update():void {
        dispatchEventWith(GameEvent.UPDATE);
    }
}
}
