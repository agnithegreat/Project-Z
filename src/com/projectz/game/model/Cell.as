/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.game.model.objects.Enemy;
import com.projectz.game.model.objects.FieldObject;
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.PositionData;

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

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }
    public function get object():FieldObject {
        return _objects.length>0 ? _objects[0] : null;
    }

    private var _depth: int;
    public function get depth():int {
        return _depth;
    }
    public function set depth(value:int):void {
        _depth = value;
    }

    private var _positionData: PositionData;
    public function get positionData():PositionData {
        return _positionData;
    }
    public function set positionData(value:PositionData):void {
        _positionData = value;
    }

    public function Cell($x: int, $y: int) {
        _x = $x;
        _y = $y;
        _walkable = true;

        _objects = new <FieldObject>[];
    }

    public function addObject($object: FieldObject):void {
        if (_objects.indexOf($object)<0) {
            _objects.push($object);
        }
    }

    public function removeObject($object: FieldObject):void {
        var index: int = _objects.indexOf($object);
        if (index>=0) {
            _objects.splice(index, 1);
        }
    }

    public function get enemies():Vector.<Enemy> {
        var targets: Vector.<Enemy> = new <Enemy>[];
        var len: int = _objects.length;
        for (var i: int = 0; i < len; i++) {
            var enemy: Enemy = _objects[i] as Enemy;
            if (enemy) {
                targets.push(enemy);
            }
        }
        return targets;
    }

    public function toString():String {
        return "{x: "+_x+", y: "+_y+"}";
    }

    public function destroy():void {
        _objects = null;
    }
}
}
