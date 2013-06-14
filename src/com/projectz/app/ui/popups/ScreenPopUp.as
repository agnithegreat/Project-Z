/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups {

import com.projectz.AppSettings;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;

import starling.textures.Texture;
import starling.utils.AssetManager;

public class ScreenPopUp extends BasicPopUp {

    private var topPart:Sprite;
    private var bottomPart:Sprite;

    private static const PRE_OPEN_DELAY:Number = .3;

    /**
     * Создание попапов.
     * @param assetManager Менеджер ассетов старлинга.
     */
    public function ScreenPopUp (assetManager:AssetManager) {

        topPart = new Sprite ();
        bottomPart = new Sprite ();

        var image:Image;
        var topPartTexture:Texture = assetManager.getTexture("screen_popup_top");
        var bottomPartTexture:Texture = assetManager.getTexture("screen_popup_bottom");
        image = new Image (topPartTexture);
        topPart.addChild (image);
        image = new Image (bottomPartTexture);
        bottomPart.addChild (image);

        addChild (bottomPart);
        addChild (topPart);
    }

//////////////////////////////////
//PROTECTED:
//////////////////////////////////

    override protected function startOpen ():void {
        topPart.y = - topPart.height;
        var tween:Tween = new Tween (topPart, TWEEN_TIME);
        tween.animate("y", 0);
        tween.transition = Transitions.EASE_OUT;
        tween.onComplete = completeOpenWithDelay;
        Starling.juggler.add (tween);

        bottomPart.y = AppSettings.appHeight;
        tween = new Tween (bottomPart, TWEEN_TIME);
        tween.animate("y", AppSettings.appHeight / 2);
        tween.transition = Transitions.EASE_OUT;
        Starling.juggler.add (tween);
    }

    override protected function startClose ():void {
        topPart.y = 0;
        var tween:Tween = new Tween (topPart, TWEEN_TIME);
        tween.animate("y", - AppSettings.appHeight);
        tween.transition = Transitions.EASE_IN;
        tween.onComplete = completeClose;
        Starling.juggler.add (tween);

        bottomPart.y = AppSettings.appHeight / 2;
        tween = new Tween (bottomPart, TWEEN_TIME);
        tween.animate("y", AppSettings.appHeight);
        tween.transition = Transitions.EASE_IN;
        Starling.juggler.add (tween);
    }

    private function completeOpenWithDelay ():void {
        Starling.juggler.delayCall (completeOpen, PRE_OPEN_DELAY);
    }
}
}
