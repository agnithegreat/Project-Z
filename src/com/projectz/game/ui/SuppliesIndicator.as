/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.04.13
 * Time: 13:43
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.AssetManager;

public class SuppliesIndicator extends Sprite {

    private var _icon: Image;

    public function SuppliesIndicator($assets: AssetManager) {
        _icon = new Image($assets.getTexture("icon-supplies"));
        addChild(_icon);

//        var textfield:TextField = new TextField(30, 30, "", "font1");
//        textfield.fontSize = BitmapFont.NATIVE_SIZE;
//        textfield.color = Color.WHITE;
//        addChild(textfield);
    }
}
}
