/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups {
import com.projectz.game.App;
import com.projectz.app.ui.popups.events.PopUpEvent;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Sprite;

/**
 * Базовое всплывающее окно.
 */
public class BasicPopUp extends Sprite {

    private var processClosing:Boolean = false;//Значение, определяющее, выполняется ли процесс закрытия.

    private const TWEEN_TIME:Number = .3;

    public function BasicPopUp () {

    }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

    public function open ():void {
        App.showPopUp (this);
    }

    public function close ():void {
        App.hidePopUp (this);
        processClosing = true;
    }

    public function get isShowed ():Boolean {
        return ((stage != null) && (!processClosing));
    }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

    protected function startOpen ():void {
//        var tween:Tween = new Tween (flipTracker, BEND_CORNER_TWEEN_TIME);
//        tween.animate("x", containerWidth * 2 - bendCornerRightMargin);
//        tween.animate("y", containerHeight - bendCornerBottomMargin);
//        tween.onUpdate = moveTracker;
//        tween.onComplete = stopBendCorner;
//        Starling.juggler.add (tween);
//        Starling.juggler.removeTweens (shadowContainer);
//        Starling.juggler.removeTweens (glareContainer);
//        Starling.juggler.tween (shadowContainer, BEND_CORNER_TWEEN_TIME, { alpha: SHADOW_ALPHA });
//        Starling.juggler.tween (glareContainer, BEND_CORNER_TWEEN_TIME, { alpha: GLARE_ALPHA });
        this.y = - Constants.HEIGHT;
        var tween:Tween = new Tween (this, TWEEN_TIME);
        tween.animate("y", 0);
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
