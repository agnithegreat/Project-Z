/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 22:28
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editObjects {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

public class EditPlaceEvent extends Event{

    private var _objectData:ObjectData;

    public static const PLACE_ADDED: String = "place_added";

    public function EditPlaceEvent(objectData:ObjectData, type:String, bubbles:Boolean = false):void {
            this.objectData = objectData;
            super (type, bubbles, objectData);
        }

    public function get objectData():ObjectData {
        return _objectData;
    }

    public function set objectData(value:ObjectData):void {
        _objectData = value;
    }
}
}
