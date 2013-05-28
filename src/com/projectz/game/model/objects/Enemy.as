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

    public static var speedMultiplier: Number = 1;

    public static const WALK: String = "walk";
    public static const ATTACK: String = "attack";
    public static const DIE: String = "die";
    public static const STAY: String = "stay";

    protected var _hp: int;
    public function get hp():int {
        return _hp;
    }

    private var _cooldown: int;

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
        _cooldown = 0;
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        come($cell);
    }

    private function come($cell: Cell):void {
        $cell.addObject(this);
    }

    public function go($cells: Vector.<Cell>):void {
        if ($cells.length>0) {
            _target = $cells[0];

            walk(true);
        }
    }

    public function step($delta: Number):void {
        if (_target) {
            var spd: Number = _enemyData.speed * $delta * speedMultiplier;
//            var aim: FieldObject = _target.object;
//            if (aim is ITarget && !(aim is Enemy)) {
//                damageTarget(aim as ITarget);
//            } else {
//                // TODO: выбрать стиль передвижения персонажей
//                if (!aim || aim==this) {
                    _positionX += dirX * spd;
                    _positionY += dirY * spd;
                    update();
//                }
//            }

            if (cellDistance > 0.5) {
                leave();
            }
            if (targetDistance < 0.5) {
                come(_target);
            }
            if (targetDistance < 0.05) {
                place(_target);
                _target = null;
            }
        }
    }

    private function damageTarget($target: ITarget):void {
        if (_cooldown>0) {
            _cooldown--;
            return;
        }
        Starling.juggler.delayCall($target.damage, 0.25, _enemyData.strength);
        attack();
        _cooldown = _enemyData.cooldown;
    }

    override public function damage($value: int):void {
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
        _cell.walkable = true;
        leave();
        if (_target) {
            _target.removeObject(this);
        }
        _alive = false;
        setState(DIE);

        dispatchEventWith(GameEvent.ENEMY_DIE);
    }

    private function leave():void {
        _cell.removeObject(this);
    }

    override public function destroy():void {
        super.destroy();

        _enemyData = null;
    }
}
}
