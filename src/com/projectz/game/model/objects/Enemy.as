/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.EnemyData;

public class Enemy extends Personage {

    public static const WALK: String = "walk";
    public static const ATTACK: String = "attack";
    public static const DIE: String = "die";
    public static const STAY: String = "stay";

    private var _way: Vector.<Cell>;
    public function hasCell($cell: Cell):Boolean {
        return _way && _way.indexOf($cell)>=0;
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

    public function Enemy($data: EnemyData) {
        _enemyData = $data;
        super(_enemyData.getPart(), _enemyData.shadow);

        // TODO: сделать нормальный выбор пути
        _path = int(Math.random()*3);
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
            } else {
                // TODO: убрать эту заглушку
                die();
            }
        }
    }

    public function walk($force: Boolean = false):void {
        setState(WALK, $force);
    }

    public function stay():void {
        setState(STAY);
    }

    public function attack($cell: Cell):void {
        _target = $cell;
        setState(ATTACK);
    }

    public function die():void {
        leave();
        _alive = false;
        setState(DIE);
    }

    private function leave():void {
        _cell.removeObject(this);
    }

    public function step($delta: Number):void {
        if (_target) {
            if (!_target.object) {
                _target.addObject(this);
            }
            // TODO: выбрать стиль передвижения персонажей
//            if (_target.object==this) {
                _progress += _enemyData.speed * $delta/distance;
                update();
//            }
        }

        if (!_halfWay && _progress>=0.5) {
            leave();
            _halfWay = true;
        }

        if (_progress>=1) {
            place(_target);
            _target = null;

            go(_way);
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
