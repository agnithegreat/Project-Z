/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class TopPanel extends Sprite {

    private var _bg: Image;

    public function TopPanel($assets: AssetManager) {
        _bg = new Image($assets.getTexture("panel-top"));
        _bg.touchable = false;
        addChild(_bg);
    }

    public function appear():void {
        pivotY = _bg.height;
        Starling.juggler.tween(this, 1, {
            pivotY: 0
        });
    }
}
}
