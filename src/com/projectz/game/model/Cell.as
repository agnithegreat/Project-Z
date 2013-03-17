/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.game.model.objects.FieldObject;

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

    private var _shadow: FieldObject;
    public function get shadow():FieldObject {
        return _shadow;
    }
    public function set shadow(value: FieldObject):void {
        _shadow = value;
    }

    private var _locked: Boolean;
    public function get locked():Boolean {
        return _locked;
    }

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
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

        _objects = new <FieldObject>[];
    }

    public function addObject($object: FieldObject):void {
        if (_objects.indexOf($object)<0) {
            _objects.push($object);
            _object = $object;
        }
    }

    public function removeObject($object: FieldObject):void {
        var index: int = _objects.indexOf($object);
        if (index>=0) {
            _objects.splice(index, 1);
            _object = null;
        }
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        _locked = false;
    }

    public function toString():String {
        return "{x: "+_x+", y: "+_y+"}";
    }

    public function destroy():void {
        _objects = null;
        _shadow = null;
    }
}
}
