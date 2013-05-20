/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.05.13
 * Time: 13:18
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editUnits {

import starling.events.Event;

/**
 * Событие выбора типа юнитов для редактирования.
 */
public class SelectUnitsTypeEvent extends Event {

    private var _objectsType:String;

    /**
     * Выбор типа юнитов для редактирования.
     */
    public static const SELECT_UNITS_TYPE:String = "select units type";

    public function SelectUnitsTypeEvent(objectsType:String, type:String = SELECT_UNITS_TYPE, bubbles:Boolean = false) {
        this.objectsType = objectsType;
        super (type, bubbles, objectsType);
    }

    /**
     * Тип юнита для редактирования.
     *
     * @see com.projectz.utils.objectEditor.data.ObjectType#DEFENDER
     * @see com.projectz.utils.objectEditor.data.ObjectType#ENEMY
     */
    public function get objectsType():String {
        return _objectsType;
    }

    public function set objectsType(value:String):void {
        _objectsType = value;
    }

}
}
