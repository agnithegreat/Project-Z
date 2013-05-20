/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.05.13
 * Time: 9:45
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data.events {

import com.projectz.utils.objectEditor.data.PartData;

import starling.events.Event;

/**
 * Событие изменения части объекта.
 */
public class EditPartDataEvent extends Event {

    private var _partData:PartData;

    /**
     * Изменение части объекта.
     */
    public static const PART_DATA_WAS_CHANGED:String = "part data was changed";

    public function EditPartDataEvent(partData:PartData, type:String = PART_DATA_WAS_CHANGED, bubbles:Boolean = false) {
        this.partData = partData;
        super (type, bubbles, partData);
    }

    /**
     * Часть объекта.
     */
    public function get partData():PartData {
        return _partData;
    }

    public function set partData(value:PartData):void {
        _partData = value;
    }
}
}
