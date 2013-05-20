/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.05.13
 * Time: 13:34
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editUnits {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

/**
 * Событие выбора юнита для редактирования.
 */
public class SelectUnitEvent extends Event {

    private var _objectData:ObjectData;

    /**
     * Выбор юнита.
     */
    public static const SELECT_UNIT:String = "select unit";

    public function SelectUnitEvent(objectData:ObjectData, type:String = SELECT_UNIT, bubbles:Boolean = false) {
        this.objectData = objectData;
        super (type, bubbles, objectData);
    }

    /**
     * Юнит для редактирования в виде объекта ObjectData.
     */
    public function get objectData():ObjectData {
        return _objectData;
    }

    public function set objectData(value:ObjectData):void {
        _objectData = value;
    }
}
}
