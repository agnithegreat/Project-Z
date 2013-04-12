/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class TopPanel extends Sprite {

    private var _bg: Image;

    public function TopPanel($assets: AssetManager) {
        _bg = new Image($assets.getTexture("panel-top"));
        _bg.touchable = false;
        addChild(_bg);

        var supplies: SuppliesIndicator = new SuppliesIndicator($assets);
        addChild(supplies);

        var menu: Button = new Button($assets.getTexture("btn-temp-02"));
        menu.x = _bg.width-menu.width-10;
        menu.y = (_bg.height-menu.height)/2-2;
        addChild(menu);

//        var button: ButtonBase = new ButtonBase(2, "", $assets.getTexture("icon-btn_menu"));
//        button.scaleX = button.scaleY = 0.5;
//        button.x = _bg.width-button.width;
//        addChild(button);
    }

    public function appear():void {
        pivotY = _bg.height;
        Starling.juggler.tween(this, 1, {
            pivotY: 0
        });
    }
}
}
