/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.objects {
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;

public class Enemy extends Personage {

    public static const WALK: String = "walk";
    public static const ATTACK: String = "attack";
    public static const DIE: String = "die";
    public static const CAME: String = "came";

    private var _way: Vector.<Cell>;

    override public function get cell():Cell {
        return _progress>0.5 && _target.sorter<_cell.sorter ? _target : _cell;
    }

    protected var _progress: Number;
    public function get progress():Number {
        return _progress;
    }
    private var _halfWay: Boolean;

    override public function get positionX():Number {
        return _target ? _cell.x+(_target.x-_cell.x)*_progress : _cell.x;
    }
    override public function get positionY():Number {
        return _target ? _cell.y+(_target.y-_cell.y)*_progress : _cell.y;
    }

    public function Enemy($data: PartData) {
        super($data);
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        _progress = 0;
        _halfWay = false;
    }

    public function walk($cells: Vector.<Cell>):void {
        _way = $cells;
        if (_way.length>0) {
            _target = _way.shift();
            dispatchEventWith(WALK);
        } else {
            // TODO: remove this test
//            die();
        }
    }

    public function attack($cell: Cell):void {
        _target = $cell;
        dispatchEventWith(ATTACK);
    }

    public function die():void {
        _alive = false;
        dispatchEventWith(DIE);
    }

    public function step($delta: Number):void {
        if (_target) {
            _progress += $delta/distance;
            update();
        }

        if (!_halfWay && _progress>=0.5) {
            _cell.unlock();
            _cell.removeObject(this);
            _target.addObject(this);
            _target.lock();
            _halfWay = true;
        }

        if (_progress>=1) {
            place(_target);
            _target = null;

            walk(_way);
        }
    }

    override public function destroy():void {
        while (_way.length>0) {
            _way.pop();
        }
        _way = null;
    }
}
}
