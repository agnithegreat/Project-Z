/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Personage;
import com.projectz.model.Zombie;

import starling.events.Event;

public class ZombieView extends PersonageView {

    public static const WALK: String = "zombie_walk_";
    public static const ATTACK: String = "zombie_attack_";
    public static const DIE: String = "zombie_die";

    public function ZombieView($personage: Personage) {
        super($personage);

        _personage.addEventListener(Zombie.WALK, handleWalk);
        _personage.addEventListener(Zombie.ATTACK, handleAttack);

        for (var i:int = 1; i <= 5; i++) {
            addState(WALK+i, App.assets.getTextureAtlas(WALK+i).getTextures(), 8);
            addState(ATTACK+i, App.assets.getTextureAtlas(ATTACK+i).getTextures(), 8);
        }
        addState(DIE, App.assets.getTextureAtlas(DIE).getTextures(), 8, false);
    }

    private function handleWalk($event: Event):void {
        walk(_personage.direction);
    }

    private function handleAttack($event: Event):void {
        attack(_personage.direction);
    }

    public function walk(dir: int = 0):void {
        setState(WALK+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function attack(dir: int = 0):void {
        setState(ATTACK+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function die():void {
        setState(DIE);
        _currentState.scaleX = 1;
    }
}
}
