/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {

public class Zombie extends Personage {

    public static const WALK: String = "walk";
    public static const ATTACK: String = "attack";
    public static const CAME: String = "came";

    private var _way: Vector.<Cell>;

    protected var _progress: Number;
    public function get progress():Number {
        return _progress;
    }

    override public function get positionX():Number {
        return _target ? _cell.x+(_target.x-_cell.x)*_progress : _cell.x;
    }
    override public function get positionY():Number {
        return _target ? _cell.y+(_target.y-_cell.y)*_progress : _cell.y;
    }

    public function Zombie() {
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        _progress = 0;
    }

    public function walk($cells: Vector.<Cell>):void {
        _way = $cells;
        if (_way.length>0) {
            _target = _way.shift();
            dispatchEventWith(WALK);
        } else {
            dispatchEventWith(CAME);
        }
    }

    public function attack($cell: Cell):void {
        _target = $cell;
        dispatchEventWith(ATTACK);
    }

    public function step($delta: Number):void {
        if (_target) {
            _progress += $delta/distance;
            update();
        }

        if (_progress>=1) {
            _cell.unlock();
            _cell.object = null;

            place(_target);
            _target.lock();
            _target.object = this;

            _target = null;

            walk(_way);
        }
    }
}
}
