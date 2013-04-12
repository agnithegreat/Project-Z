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
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.AssetManager;
import starling.utils.HAlign;

public class SuppliesIndicator extends Sprite {

    private var _icon: Image;
    private var _tf: TextField;

    public function SuppliesIndicator($assets: AssetManager) {
        _icon = new Image($assets.getTexture("icon-supplies"));
        addChild(_icon);

        _tf = new TextField(60, 60, "x0", "Polar Std", 30, 0xFFFFFF);
        _tf.hAlign = HAlign.LEFT;
        _tf.x = _icon.width+10;
        addChild(_tf);

        _tf.filter = BlurFilter.createGlow(0, 1, 3, 1);
    }

    public function update($amount: int):void {
        _tf.text = "x"+$amount;
    }
}
}
