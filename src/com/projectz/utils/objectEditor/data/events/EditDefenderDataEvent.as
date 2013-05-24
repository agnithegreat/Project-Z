/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.05.13
 * Time: 9:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data.events {
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.events.Event;

/**
 * Событие, отправляемое при изменении данных в объекте DefenderData.
 *
 * @see com.projectz.utils.objectEditor.data.DefenderData
 */
public class EditDefenderDataEvent extends Event {

    private var _defenderData:DefenderData;

    public static const DEFENDER_DATA_WAS_CHANGED:String = "defender data was changed";

    public function EditDefenderDataEvent(defenderData:DefenderData, type:String = DEFENDER_DATA_WAS_CHANGED, bubbles:Boolean = false) {
            this.defenderData = defenderData;
            super(type, bubbles, defenderData);
        }

        public function get defenderData():DefenderData {
            return _defenderData;
        }

        public function set defenderData(value:DefenderData):void {
            _defenderData = value;
        }
    }
    }