/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 0:34
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones {
import starling.events.Event;

public class SelectEditDefenderZonesModeEvent extends Event {

    private var _mode:String;

    public static const SELECT_EDIT_DEFENDERS_ZONES_MODE:String = "select edit defender zones mode";

    public function SelectEditDefenderZonesModeEvent(mode:String, type:String = SELECT_EDIT_DEFENDERS_ZONES_MODE, bubbles:Boolean = false) {
        this.mode = mode;
        super(type, bubbles, mode);
    }

    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
    }
}
}