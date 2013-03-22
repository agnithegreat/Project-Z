/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.03.13
 * Time: 10:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editObjects {
import starling.events.Event;

public class SelectObjectsTypeEvent extends Event {

    private var _objectsType:String;

    public static const SELECT_OBJECTS_TYPE:String = "select objects type";

    public function SelectObjectsTypeEvent(objectsType:String, type:String = SELECT_OBJECTS_TYPE, bubbles:Boolean = false) {
        this.objectsType = objectsType;
        super (type, bubbles, objectsType);
    }

    public function get objectsType():String {
        return _objectsType;
    }

    public function set objectsType(value:String):void {
        _objectsType = value;
    }

}
}
