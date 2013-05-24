/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 24.05.13
 * Time: 21:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller.events.selectDefender {

import com.projectz.utils.objectEditor.data.DefenderData;

import starling.events.Event;

/**
 * Событие выбора защитника для добавления на карту.
 */
public class SelectDefenderEvent extends Event {

    private var _defenderData:DefenderData;

    /**
     * Выбор защитника для добавление защитника на карту.
     */
     public static const SELECT_DEFENDER:String = "select defender";

    public function SelectDefenderEvent(defenderData:DefenderData, type:String = SELECT_DEFENDER, bubbles:Boolean = false) {
        this.defenderData = defenderData;
        super (type, bubbles, defenderData);
    }

    /**
     * Защитник для добавления на карту.
     */
    public function get defenderData():DefenderData {
        return _defenderData;
    }

    public function set defenderData(value:DefenderData):void {
        _defenderData = value;
    }
}
}
