/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 0:14
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editDefenderZones {
import com.projectz.utils.levelEditor.data.DefenderPositionData;

import starling.events.Event;

/**
 * Событие изменения зоны защитников.
 */
public class EditDefenderPositionEvent extends Event {

    private var _defenderPositionData:DefenderPositionData;

    /**
     * Добавление зоны защитников.
     */
    public static const DEFENDER_POSITION_WAS_ADDED:String = "defender position was added";
    /**
     * Изменение зоны защитников.
     */
    public static const DEFENDER_POSITION_WAS_CHANGED:String = "defender position was changed";
    /**
     * Удаление зоны защитников.
     */
    public static const DEFENDER_POSITION_WAS_REMOVED:String = "defender position was removed";

    public function EditDefenderPositionEvent(defenderPositionData:DefenderPositionData, type:String, bubbles:Boolean = false) {
        this.defenderPositionData = defenderPositionData;
        super(type, bubbles, defenderPositionData);
    }

    /**
     * Зона защитников.
     */
    public function get defenderPositionData():DefenderPositionData {
        return _defenderPositionData;
    }

    public function set defenderPositionData(value:DefenderPositionData):void {
        _defenderPositionData = value;
    }
}
}
