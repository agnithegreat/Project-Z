/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 13:19
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones {
import com.projectz.utils.levelEditor.data.DefenderPositionData;

import starling.events.Event;

public class SelectDefenderPositionEvent extends Event {

    private var _defenderPositionData:DefenderPositionData;

    public static const SELECT_DEFENDER_POSITION:String = "select defender position";

    public function SelectDefenderPositionEvent(defenderPositionData:DefenderPositionData, type:String = SELECT_DEFENDER_POSITION, bubbles:Boolean = false) {
        this.defenderPositionData = defenderPositionData;
        super(type, bubbles, defenderPositionData);
    }

    public function get defenderPositionData():DefenderPositionData {
        return _defenderPositionData;
    }

    public function set defenderPositionData(value:DefenderPositionData):void {
        _defenderPositionData = value;
    }
}
}
