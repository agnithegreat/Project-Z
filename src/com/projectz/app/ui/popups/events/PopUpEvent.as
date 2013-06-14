/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 11:43
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups.events {
import starling.events.Event;

/**
 * Событие, отправляемое всплывающими окнами.
 */
public class PopUpEvent extends Event {

    /**
     * Закрытие всплывающего окона.
     */
    public static var CLOSE:String = 'close popUp';
    /**
     * Открытие всплывающего окона.
     */
    public static var OPEN:String = 'open popUp';

    public function PopUpEvent (type:String, bubbles:Boolean = false, data:Object = null):void {
        super (type, bubbles, data);
    }

}

}