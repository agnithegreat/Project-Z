/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.13
 * Time: 13:59
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editPaths {
import starling.events.Event;

public class SelectEditPathModeEvent extends Event {

    private var _mode:String;

    public static const SELECT_EDIT_PATH_MODE:String = "select edit path mode";

    public function SelectEditPathModeEvent(mode:String, type:String = SELECT_EDIT_PATH_MODE, bubbles:Boolean = false) {
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