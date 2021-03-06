/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.05.13
 * Time: 11:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editAssets {
import starling.events.Event;

/**
 * Событие выбора типа ассетов для редактирования.
 */
public class SelectAssetsTypeEvent extends Event {

    private var _objectsType:String;

    /**
     * Выбор типа ассетов для редактирования.
     */
    public static const SELECT_ASSETS_TYPE:String = "select assets type";

    public function SelectAssetsTypeEvent(objectsType:String, type:String = SELECT_ASSETS_TYPE, bubbles:Boolean = false) {
        this.objectsType = objectsType;
        super (type, bubbles, objectsType);
    }

    /**
     * Тип ассетов.
     *
     * @see com.projectz.utils.objectEditor.data.ObjectType
     */
    public function get objectsType():String {
        return _objectsType;
    }

    public function set objectsType(value:String):void {
        _objectsType = value;
    }

}
}
