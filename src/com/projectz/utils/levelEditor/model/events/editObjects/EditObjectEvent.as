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

    public static const OBJECT_ADDED: String = "object_added_EditObjectEvent";
    public static const SHADOW_ADDED: String = "shadow_added_EditObjectEvent";
    public static const OBJECT_REMOVED: String = "object_removed_EditObjectEvent";

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
