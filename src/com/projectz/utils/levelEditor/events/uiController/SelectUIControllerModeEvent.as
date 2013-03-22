/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 12:03
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.events.uiController {
import starling.events.Event;

public class SelectUIControllerModeEvent extends Event {

    private var _mode:String;

    public static const SELECT_UI_CONTROLLER_MODE:String = "select mode";

    public function SelectUIControllerModeEvent(mode:String, type:String = SELECT_UI_CONTROLLER_MODE, bubbles:Boolean = false) {
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
