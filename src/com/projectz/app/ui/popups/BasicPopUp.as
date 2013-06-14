/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups {
import com.projectz.AppSettings;
import com.projectz.game.App;
import com.projectz.app.ui.popups.events.PopUpEvent;

import starling.animation.Transitions;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Sprite;

/**
 * Базовое всплывающее окно.
 */
public class BasicPopUp extends Sprite {

    private var processClosing:Boolean = false;//Значение, определяющее, выполняется ли процесс закрытия.

    protected static const TWEEN_TIME:Number = .3;

    public function BasicPopUp () {

    }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

    public function open ():void {
        App.showPopUp (this);
        startOpen ();
    }

    public function close ():void {
        App.hidePopUp (this);
        processClosing = true;
        startClose ();
    }

    public function get isShowed ():Boolean {
        return ((stage != null) && (!processClosing));
    }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

    protected function startOpen ():void {
        this.y = - AppSettings.appHeight;
        var tween:Tween = new Tween (this, TWEEN_TIME);
        tween.animate("y", 0);
        tween.transition = Transitions.EASE_IN_OUT;
        tween.onComplete = completeOpen;
        Starling.juggler.add (tween);
    }

    protected function startClose ():void {
        this.y = 0;
        var tween:Tween = new Tween (this, TWEEN_TIME);
        tween.animate("y", - AppSettings.appHeight);
        tween.onComplete = completeClose;
        Starling.juggler.add (tween);
    }

    protected function completeOpen ():void {
        dispatchEvent (new PopUpEvent (PopUpEvent.OPEN));
    }

    protected function completeClose ():void {
        processClosing = false;
        dispatchEvent (new PopUpEvent (PopUpEvent.CLOSE));
    }
}
}
