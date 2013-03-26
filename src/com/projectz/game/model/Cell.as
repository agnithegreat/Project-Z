/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.game.model.objects.FieldObject;
import com.projectz.game.event.GameEvent;

import starling.events.EventDispatcher;

public class Cell extends EventDispatcher {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    public function get sorter():int {
        return x+y;
    }

    private var _walkable: Boolean;
    public function set walkable($value: Boolean):void {
        _walkable = $value;
        dispatchEventWith(GameEvent.UPDATE);
    }
    public function get walkable():Boolean {
        return _walkable;
    }

    private var _shotable: Boolean;
    public function set shotable($value: Boolean):void {
        _shotable = $value;
    }
    public function get shotable():Boolean {
        return _shotable;
    }

    private var _object: FieldObject;
    public function get object():FieldObject {
        return _object;
    }

    private var _depth: int;
    public function get depth():int {
        return _depth;
    }
    public function set depth(value:int):void {
        _depth = value;
    }

    public function Cell($x: int, $y: int) {
        _x = $x;
        _y = $y;
        _walkable = true;
    }

    public function addObject($object: FieldObject):void {
        _object = $object;
    }

    public function removeObject($object: FieldObject):void {
        if (_object==$object) {
            _object = null;
        }
    }

    public function toString():String {
        return "{x: "+_x+", y: "+_y+"}";
    }

    public function destroy():void {
        _object = null;
    }
}
}
