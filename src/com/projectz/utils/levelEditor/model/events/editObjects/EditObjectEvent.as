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

public class EditObjectEvent extends Event {

    private var _fieldObject:FieldObject;

    public static const OBJECT_WAS_ADDED: String = "object was added";
    public static const OBJECT_WAS_REMOVED: String = "object was removed";

    public function EditObjectEvent (objectData:FieldObject, type:String, bubbles:Boolean = false):void {
        this.fieldObject = objectData;
        super (type, bubbles, objectData);
    }

    public function get fieldObject():FieldObject {
        return _fieldObject;
    }

    public function set fieldObject(value:FieldObject):void {
        _fieldObject = value;
    }

}
}
