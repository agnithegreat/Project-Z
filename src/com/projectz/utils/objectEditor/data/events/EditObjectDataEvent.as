/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.05.13
 * Time: 16:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data.events {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

/**
 * Событие, отправляемое при изменении данных в объекте ObjectData.
 *
 * @see com.projectz.utils.objectEditor.data.ObjectData
 */
public class EditObjectDataEvent extends Event {

    private var _objectData:ObjectData;

    public static const OBJECT_DATA_WAS_CHANGED:String = "object data was changed";

    public function EditObjectDataEvent(objectData:ObjectData, type:String = OBJECT_DATA_WAS_CHANGED, bubbles:Boolean = false) {
        this.objectData = objectData;
        super(type, bubbles, objectData);
    }

    public function get objectData():ObjectData {
        return _objectData;
    }

    public function set objectData(value:ObjectData):void {
        _objectData = value;
    }
}
}
