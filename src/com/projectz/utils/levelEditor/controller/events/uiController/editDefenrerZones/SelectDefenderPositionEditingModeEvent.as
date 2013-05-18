/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 0:34
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones {
import starling.events.Event;

/**
 * Событие выбора режима редактирования зон защитников.
 */
public class SelectDefenderPositionEditingModeEvent extends Event {

    private var _mode:String;

    /**
     * Выбор режима редактирования зон защитников.
     */
    public static const SELECT_DEFENDER_POSITION_EDITING_MODE:String = "select defender position editing mode";

    public function SelectDefenderPositionEditingModeEvent(mode:String, type:String = SELECT_DEFENDER_POSITION_EDITING_MODE, bubbles:Boolean = false) {
        this.mode = mode;
        super(type, bubbles, mode);
    }

    /**
     * Режим редактирования зон защитников.
     *
     * @see com.projectz.utils.levelEditor.controller.EditMode
     */
    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
    }
}
}