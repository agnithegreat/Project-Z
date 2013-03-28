/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.objects {
import com.projectz.game.view.*;
import com.projectz.game.model.objects.Enemy;
import com.projectz.game.model.objects.Personage;
import com.projectz.game.event.GameEvent;
import com.projectz.game.view.effects.Effect;

import starling.core.Starling;

import starling.events.Event;

public class EnemyView extends PersonageView {

    public static const WALK: String = "walk-0";
    public static const ATTACK: String = "attack-0";
    public static const DIE: String = "die-0";

    public function EnemyView($personage: Personage) {
        super($personage);

        _personage.addEventListener(GameEvent.STATE, handleState);
        _personage.addEventListener(GameEvent.DAMAGE, handleDamage);

        for (var i:int = 1; i <= 5; i++) {
            addState(WALK+i, _personage.data.states[WALK+i], 12);
            addState(ATTACK+i, _personage.data.states[ATTACK+i], 12);
            addState(DIE+i, _personage.data.states[DIE+i], 12, false);
        }

        handleState(null);
    }

    private function handleState($event: Event):void {
        switch (_personage.state) {
            case Enemy.WALK:
                walk(_personage.direction);
                break;
            case Enemy.STAY:
                _currentState.stop();
                break;
            case Enemy.ATTACK:
                attack(_personage.direction);
                break;
            case Enemy.DIE:
                die(1);
                break;
        }
    }

    private function handleDamage($event: Event):void {
        dispatchEventWith(GameEvent.SHOW_EFFECT, true, Effect.BLOOD);
    }

    public function walk(dir: int = 0):void {
        setState(WALK+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function attack(dir: int = 0):void {
        setState(ATTACK+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function die(dir: int = 0):void {
        dispatchEventWith(GameEvent.SHOW_EFFECT, true, Effect.DIE);

        setState(DIE+(Math.abs(dir)+1));
        _currentState.currentFrame = 0;
        _currentState.scaleX = 1;
        _currentState.addEventListener(Event.COMPLETE, handleDied);
    }

    private function handleDied($event: Event):void {
        _currentState.removeEventListener(Event.COMPLETE, handleDied);
        dispatchEventWith(Event.COMPLETE);

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
