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

import starling.core.Starling;

import starling.events.Event;

public class ZombieView extends PersonageView {

    public static const WALK: String = "zombie_walk_";
    public static const ATTACK: String = "zombie_attack_";
    public static const DIE: String = "zombie_die";

    public function ZombieView($personage: Personage) {
        super($personage);

        _personage.addEventListener(Zombie.WALK, handleWalk);
        _personage.addEventListener(Zombie.ATTACK, handleAttack);
        _personage.addEventListener(Zombie.DIE, handleDie);

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

    private function handleDie($event: Event):void {
        die();
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
        _currentState.addEventListener(Event.COMPLETE, handleDied);
    }

    private function handleDied($event: Event):void {
        _currentState.removeEventListener(Event.COMPLETE, handleDied);

        Starling.juggler.tween(this, 1, {
            alpha: 0,
            onComplete: dispatchDestroy
        });
    }

    override public function destroy():void {
        if (_currentState) {
            _currentState.removeEventListeners();
        }
        super.destroy();
    }
}
}
