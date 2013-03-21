/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 19:10
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.events.levelEditorController {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

public class BackgroundWasChangedEvent extends Event{

    private var _objectData:ObjectData;

    public static const BACKGROUND_WAS_CHANGED:String = "background was changed";

    public function BackgroundWasChangedEvent (objectData:ObjectData, type:String = BACKGROUND_WAS_CHANGED, bubbles:Boolean = false) {
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
