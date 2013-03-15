/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.model.objects.Personage;
import com.projectz.game.model.objects.Enemy;

import starling.core.Starling;

import starling.events.Event;

public class EnemyView extends PersonageView {

    public static const WALK: String = "walk_0";
    public static const ATTACK: String = "attack_0";
    public static const DIE: String = "die";

    public function EnemyView($personage: Personage) {
        super($personage);

        _personage.addEventListener(Enemy.WALK, handleWalk);
        _personage.addEventListener(Enemy.ATTACK, handleAttack);
        _personage.addEventListener(Enemy.DIE, handleDie);

        for (var i:int = 1; i <= 5; i++) {
            addState(WALK+i, _personage.data.states[WALK+i], 12);
            addState(ATTACK+i, _personage.data.states[ATTACK+i], 12);
        }
        addState(DIE, _personage.data.states[DIE], 12, false);
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
        _currentState.currentFrame = 0;
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
