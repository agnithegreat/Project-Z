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

    private var _meleeEnemies: Vector.<Enemy>;
    public function get melee():Boolean {
        return _meleeEnemies && _meleeEnemies.length>0;
    }

    private var _rangeEnemies: Vector.<Enemy>;
    public function get range():Boolean {
        return _rangeEnemies && _rangeEnemies.length>0;
    }

    public function Defender($data:DefenderData) {
        _defenderData = $data;
        super(_defenderData.getPart(), _defenderData.shadow);

        _ammo = 0;
        _cooldown = 0;
    }

    override public function place($cell: Cell):void {
        super.place($cell);
        _cell.addObject(this);
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

        if (melee || !_aim || !_aim.alive || Cell.getDistance(_cell, _aim.cell)>radius) {
            _aim = null;
            getEnemies();

            if (melee) {
                _meleeEnemies.sort(sortMeleeEnemies);
                _aim = _meleeEnemies[0];
            } else if (range) {
                _rangeEnemies.sort(sortRangeEnemies);
                _aim = _rangeEnemies[0];
            }
        }
        if (_aim) {
            _target = _aim.cell;
            var targets: Vector.<Enemy> = _defenderData.power ? _target.enemies : new <Enemy>[_aim];
            if (targets.length>0) {
                damageTargets(targets);
            }
        } else {
            stay();
        }
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

    private function damageTargets($targets: Vector.<Enemy>):void {
        var len: int = $targets.length;
        for (var i: int = 0; i < len; i++) {
            Starling.juggler.delayCall($targets[i].damage, 0.25, melee ? _defenderData.defence : _defenderData.strength);
        }
        _cooldown = _defenderData.cooldown;
        if (melee) {
            fight(true);
        } else {
            attack(true);
            _ammo--;
        }
    }

    private function getEnemies():void {
        // TODO: пофиксить
        _meleeEnemies = new <Enemy>[];
        _rangeEnemies = new <Enemy>[];
        var enemies: Vector.<Enemy> = new <Enemy>[];
        var len: int = _area.length;
        for (var i:int = 0; i < len; i++) {
            if (Cell.getDistance(_area[i], _cell) < 2) {
                _meleeEnemies = _meleeEnemies.concat(_area[i].enemies);
            } else {
                _rangeEnemies = _rangeEnemies.concat(_area[i].enemies);
            }
        }
    }

    // сортируем милишных врагов по здоровью
    private function sortMeleeEnemies($enemy1: Enemy, $enemy2: Enemy):int {
        if ($enemy1.hp > $enemy2.hp) {
            return 1;
        } else if ($enemy1.hp < $enemy2.hp) {
            return -1;
        }
        return 0;
    }

    // сортируем ранжевиков по расстоянию до цели
    private function sortRangeEnemies($enemy1: Enemy, $enemy2: Enemy):int {
//        var d1: int = Cell.getDistance($enemy1.cell, $enemy1.lastTarget);
//        var d2: int = Cell.getDistance($enemy2.cell, $enemy1.lastTarget);
//        if (d1 > d2) {
//            return 1;
//        } else if (d1 < d2) {
//            return -1;
//        }
        return 0;
    }
}
}
