/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 0:14
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editDefenderZones {
import starling.events.Event;

public class EditDefenderZonesEvent extends Event {

    public static const DEFENDER_ZONES_WAS_CHANGED:String = "defender zones was changed";

    public function EditDefenderZonesEvent(type:String = DEFENDER_ZONES_WAS_CHANGED, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }

}
}
