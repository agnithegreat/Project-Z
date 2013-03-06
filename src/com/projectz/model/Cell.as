/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
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

    private var _object: FieldObject;
    public function get object():FieldObject {
        return _object;
    }
    public function set object(value: FieldObject):void {
        _object = value;
    }

    private var _locked: Boolean;
    public function get locked():Boolean {
        return _locked;
    }

    public function Cell($x: int, $y: int) {
        _x = $x;
        _y = $y;
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        _locked = false;
    }

    public function destroy():void {
        _object = null;
    }
}
}
