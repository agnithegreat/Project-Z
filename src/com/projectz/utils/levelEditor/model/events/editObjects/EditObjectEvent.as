/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 10:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editObjects {
import com.projectz.utils.levelEditor.model.objects.FieldObject;

import starling.events.Event;

/**
 * Событие удаление/добавления частей объектов (FieldObject) на карте.
 */
public class EditObjectEvent extends Event {

    private var _fieldObject:FieldObject;

    /**
     * Объект был добавлен на карту.
     */
    public static const FIELD_OBJECT_WAS_ADDED: String = "object was added";
    /**
     * Объект был удалён с карты.
     */
    public static const FIELD_OBJECT_WAS_REMOVED: String = "object was removed";

    public function EditObjectEvent (objectData:FieldObject, type:String, bubbles:Boolean = false):void {
        this.fieldObject = objectData;
        super (type, bubbles, objectData);
    }

    /**
     * Часть объекта.
     */
    public function get fieldObject():FieldObject {
        return _fieldObject;
    }

    public function set fieldObject(value:FieldObject):void {
        _fieldObject = value;
    }

}
}
