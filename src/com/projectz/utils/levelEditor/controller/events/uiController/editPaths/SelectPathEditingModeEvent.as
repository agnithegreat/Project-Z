/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.13
 * Time: 13:59
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editPaths {
import starling.events.Event;

/**
 * Событие выбора режима редактирования пути.
 */
public class SelectPathEditingModeEvent extends Event {

    private var _mode:String;

    /**
     * Выбор режима редактирования пути.
     */
    public static const SELECT_PATH_EDITING_MODE:String = "select path editing mode";

    public function SelectPathEditingModeEvent(mode:String, type:String = SELECT_PATH_EDITING_MODE, bubbles:Boolean = false) {
        this.mode = mode;
        super(type, bubbles, mode);
    }

    /**
     * Режим редактирования пути.
     *
     * @see com.projectz.utils.levelEditor.controller.EditingMode
     */
    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
    }
}
}