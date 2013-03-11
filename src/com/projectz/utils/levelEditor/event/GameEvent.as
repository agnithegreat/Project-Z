/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:02
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.event {
import flash.events.Event;

public class GameEvent extends Event {

    public static const UPDATE: String = "update_GameEvent";
    public static const DESTROY: String = "destroy_GameEvent";

    public function GameEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = true):void {
        super (type, bubbles, cancelable)
    }
}
}
