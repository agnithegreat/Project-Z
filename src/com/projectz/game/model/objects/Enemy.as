/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.EnemyData;

import starling.core.Starling;

public class Enemy extends Personage {

    public static const WALK: String = "walk";
    public static const ATTACK: String = "attack";
    public static const DIE: String = "die";
    public static const STAY: String = "stay";

    private var _way: Vector.<Cell>;
    public function hasCell($cell: Cell):Boolean {
        return _way && _way.indexOf($cell)>=0;
    }
    public function get stepsLeft():int {
        return _way.length;
    }

    override public function get cell():Cell {
        return _progress>0.5 && _target.depth>_cell.depth ? _target : _cell;
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

    protected var _hp: int;

    protected var _path: int;
    public function get path():int {
        return _path;
    }

    private var _enemyData: EnemyData;

    public function Enemy($data: EnemyData, $path: int) {
        _enemyData = $data;
        super(_enemyData.getPart(), _enemyData.shadow);

        _path = $path;
        _hp = _enemyData.hp;
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        _cell.addObject(this);
        _progress = 0;
        _halfWay = false;
    }

    public function go($cells: Vector.<Cell>):void {
        _way = $cells;
        if (!_target) {
            if (_way.length>0) {
                _target = _way.shift();
                walk(true);
            }
        }
    }

    public function step($delta: Number):void {
        if (_target) {
            var aim: FieldObject = _target.object;
            if (aim && !(aim is Enemy)) {
//                Starling.juggler.delayCall(_target.object.damage, 0.25, _enemyData.strength);
                attack();
            } else {
                // TODO: выбрать стиль передвижения персонажей
                if (!aim || aim==this) {
                    _progress += _enemyData.speed * $delta/distance;
                    update();
                }
            }
        }

        if (!_halfWay && _progress>=0.5) {
            leave();
            _target.addObject(this);
            _halfWay = true;
        }

        if (_progress>=1) {
            place(_target);
            _target = null;

            go(_way);
        }
    }

    public function damage($value: int):void {
        _hp -= $value;
        dispatchEventWith(GameEvent.DAMAGE);
        if (_hp<=0) {
            _hp = 0;
            die();
        }
    }

    public function walk($force: Boolean = false):void {
        setState(WALK, $force);
    }

    public function stay():void {
        setState(STAY);
    }

    public function attack():void {
        setState(ATTACK);
    }

    public function die():void {
        leave();
        if (_target) {
            _target.removeObject(this);
        }
        _alive = false;
        setState(DIE);
    }

    private function leave():void {
        _cell.removeObject(this);
    }

    override public function destroy():void {
        while (_way.length>0) {
            _way.pop();
        }
        _way = null;

        _enemyData = null;
    }
}
}
