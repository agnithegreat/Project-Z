/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.03.13
 * Time: 10:13
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.events.uiController {
import com.projectz.utils.objectEditor.data.ObjectData;


import starling.events.Event;

public class SelectObjectEvent extends Event {

    private var _objectData:ObjectData;

    public static const SELECT_OBJECT:String = "select object";

    public function SelectObjectEvent(objectData:ObjectData, type:String = SELECT_OBJECT, bubbles:Boolean = false) {
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
