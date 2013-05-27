/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {

import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.objectEditor.data.DefenderData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import starling.core.Starling;

import starling.events.EventDispatcher;

/**
* Отправляется при изменении денег, полученных при прохождении уровня.
*
* @eventType com.projectz.game.event.GameEvent.SET_MONEY
*/
[Event(name="set_money_GameEvent", type="starling.events.Event")]

public class Game extends EventDispatcher {

    private var _objectsStorage: ObjectsStorage;

    private var _money:int;
    /**
     * Деньги, полученные при прохождении уровня.
     */
    public function get money():int {
        return _money;
    }

    public function set money(value:int):void {
        _money = value;
        dispatchEventWith(GameEvent.SET_MONEY);
    }

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    private var _active: Boolean;

    public function Game($objectsStorage: ObjectsStorage, $level: LevelData) {
        _objectsStorage = $objectsStorage;

        _field = new Field(72, 72, _objectsStorage, $level);


        //FOR_TEST+++
        testAddMoney();
        //FOR_TEST---
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function init():void {
        _field.init();
        start();
        money = 0;
    }

    public function start():void {
        _active = true;

        handleTimer();
    }

    public function stop():void {
        _active = false;
    }

    public function destroy():void {
        _active = false;

        _field.destroy();
        _field = null;
    }

    /**
     * Добавление на карту защитника.
     * @param $defenderData Защитник.
     * @param $x Координата x защитника для добавления на карту.
     * @param $y Координата y защитника для добавления на карту.
     */
    public function addDefender($defenderData:DefenderData, $x: int, $y: int):void {
        if ($defenderData && $defenderData.cost <= money) {
            if (field.addDefender($defenderData, $x, $y)) {
                money -= $defenderData.cost;
            }
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function handleTimer():void {
        if (_field && _active) {
            _field.step(1/60);

            Starling.juggler.delayCall(handleTimer, 1/60);
        }
    }

    //FOR_TEST+++
    private function testAddMoney ():void {
        money += 1;
        Starling.juggler.delayCall(testAddMoney, 1);
    }
    //FOR_TEST---
}
}
