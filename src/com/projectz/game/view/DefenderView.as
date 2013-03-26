/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.model.objects.Defender;
import com.projectz.game.model.objects.Personage;

import starling.events.Event;

public class DefenderView extends PersonageView {

    public static const FIGHT: String = "fight-0";
    public static const ATTACK: String = "attack-0";
    public static const RELOAD: String = "reload-0";
    public static const STAY: String = "static-0";

    public function DefenderView($personage: Personage) {
        super($personage);

        _personage.addEventListener(Defender.FIGHT, handleFight);
        _personage.addEventListener(Defender.ATTACK, handleAttack);
        _personage.addEventListener(Defender.RELOAD, handleReload);
        _personage.addEventListener(Defender.STATIC, handleStay);

        for (var i:int = 1; i <= 5; i++) {
            addState(FIGHT+i, _personage.data.states[FIGHT+i], 12);
            addState(ATTACK+i, _personage.data.states[ATTACK+i], 12);
            addState(RELOAD+i, _personage.data.states[RELOAD+i], 12);
            addState(STAY+i, _personage.data.states[STAY+i], 12);
        }
    }

    private function handleFight($event: Event):void {
        fight(_personage.direction);
    }

    private function handleAttack($event: Event):void {
        attack(_personage.direction);
    }

    private function handleReload($event: Event):void {
        reload(1);
    }

    private function handleStay($event: Event):void {
        stay(1);
    }

    public function fight(dir: int = 0):void {
        setState(FIGHT+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function attack(dir: int = 0):void {
        setState(ATTACK+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function reload(dir: int = 0):void {
        setState(RELOAD+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    public function stay(dir: int = 0):void {
        setState(STAY+(Math.abs(dir)+1));
        _currentState.scaleX = dir>0 ? 1 : -1;
    }

    override public function destroy():void {
        if (_currentState) {
            _currentState.removeEventListeners();
        }
        super.destroy();
    }
}
}
