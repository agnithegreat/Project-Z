/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:45
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.game.event.GameEvent;

import flash.geom.Point;

public class Personage extends FieldObject implements ITarget {

    protected var _positionX: Number;
    override public function get positionX():Number {
        return _positionX;
    }
    protected var _positionY: Number;
    override public function get positionY():Number {
        return _positionY;
    }

    protected var _target: Cell;
    public function get target():Cell {
        return _target;
    }

    protected var _direction: Point;
    public function get dirX():Number {
        return _direction.x;
    }
    public function get dirY():Number {
        return _direction.y;
    }

    public function get direction():int {
        var angle: Number = Math.atan2(dirY, dirX);
        return _target ? angle/(Math.PI/4)-1 : 0;
    }

    public function get cellDistance():Number {
        return Point.distance(new Point(_cell.x, _cell.y), new Point(_positionX, _positionY));
    }

    public function get targetDistance():Number {
        return _target ? Point.distance(new Point(_target.x, _target.y), new Point(_positionX, _positionY)) : 0;
    }

    protected var _alive: Boolean;
    public function get alive():Boolean {
        return _alive;
    }

    protected var _state: String;
    public function get state():String {
        return _state;
    }

    public function Personage($data: PartData, $shadow: PartData) {
        super($data, $shadow);

        _direction = new Point();
        _alive = true;
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        _positionX = $cell.x;
        _positionY = $cell.y;
    }

    public function turn($target: Cell):void {
        _target = $target;
        _direction.x = _target ? _target.x-_cell.x : 0;
        _direction.y = _target ? _target.y-_cell.y : 0;
    }

    public function damage($value: int):void {

    }

    public function setState($state: String, $force: Boolean = false):void {
        if (_state!=$state || $force) {
            _state = $state;
            dispatchEventWith(GameEvent.STATE);
        }
    }

    override public function destroy():void {
        super.destroy();

        _target = null;
    }
}
}
