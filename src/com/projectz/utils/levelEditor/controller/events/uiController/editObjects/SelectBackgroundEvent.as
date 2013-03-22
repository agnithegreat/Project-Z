/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.03.13
 * Time: 10:28
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editObjects {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

public class SelectBackgroundEvent extends Event {

    private var _objectData:ObjectData;

    public static const SELECT_BACKGROUND:String = "select background";

    public function SelectBackgroundEvent(objectData:ObjectData, type:String = SELECT_BACKGROUND, bubbles:Boolean = false) {
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
