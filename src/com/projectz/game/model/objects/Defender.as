/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 14.03.13
 * Time: 21:19
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.core.Starling;

public class Defender extends Personage {

    public static const FIGHT: String = "fight";
    public static const ATTACK: String = "attack";
    public static const RELOAD: String = "reload";
    public static const STATIC: String = "static";

    private var _ammo: int;
    private var _cooldown: int;

    private var _defenderData: DefenderData;
    public function get radius():int {
        return _defenderData.radius;
    }

    private var _area: Vector.<Cell>;
    private var _aim: Enemy;

    public function Defender($data:DefenderData) {
        _defenderData = $data;
        super(_defenderData.getPart(), _defenderData.shadow);

        _ammo = 0;
        _cooldown = 0;
    }

    public function watch($area: Vector.<Cell>):void {
        _area = $area;
        stay();
    }

    public function step():void {
        if (_cooldown>0) {
            _cooldown--;
            return;
        }
        if (!_ammo) {
            reload();
            _cooldown = _defenderData.cooldown;
            _ammo = _defenderData.ammo;
            return;
        }

        if (!_aim || !_aim.alive || getDistance(_aim.cell)>radius) {
            _aim = null;
            var enemy: Enemy;
            var len: int = _area.length;
            for (var i:int = 0; i < len; i++) {
                enemy = _area[i].object as Enemy;
                if (enemy) {
                    _aim = enemy;
                }
            }
        }
        if (_aim) {
            _target = _aim.cell;
            Starling.juggler.delayCall(_aim.damage, 0.25, _defenderData.strength);
            attack(true);
            _cooldown = _defenderData.cooldown;
            _ammo--;
        }
    }

    private function getDistance($cell: Cell):Number {
        var dx: int = $cell.x-cell.x;
        var dy: int = $cell.y-cell.y;
        return Math.sqrt(dx*dx+dy*dy);
    }

    public function fight($force: Boolean = false):void {
        setState(FIGHT, $force);
    }

    public function attack($force: Boolean = false):void {
        setState(ATTACK, $force);
    }

    public function reload():void {
        setState(RELOAD);
    }

    public function stay():void {
        setState(STATIC);
    }
}
}
