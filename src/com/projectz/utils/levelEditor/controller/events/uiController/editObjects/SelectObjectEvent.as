/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.03.13
 * Time: 10:13
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editObjects {

import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

/**
 * Событие выбора объекта для редактирования (добавления не карту).
 */
public class SelectObjectEvent extends Event {

    private var _objectData:ObjectData;

    /**
     * Выбор объекта для редактирования (добавления на карту).
     */
    public static const SELECT_OBJECT:String = "select object";

    public function SelectObjectEvent(objectData:ObjectData, type:String = SELECT_OBJECT, bubbles:Boolean = false) {
        this.objectData = objectData;
        super (type, bubbles, objectData);
    }

    /**
     * Объект для редактирования (добавления на карту).
     */
    public function get objectData():ObjectData {
        return _objectData;
    }

    public function set objectData(value:ObjectData):void {
        _objectData = value;
    }
}
}
