/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.model {
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

    private var _name: String;
    public function get name():String {
        return _name;
    }

    public function FieldObject($name: String) {
        _name = $name;
    }

    public function place($cell: Cell):void {
        _cell = $cell;
    }

    public function destroy():void {
        _cell = null;
    }
}
}
