/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.04.13
 * Time: 13:43
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {

import flash.filters.GlowFilter;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.AssetManager;
import starling.utils.HAlign;

public class SuppliesIndicator extends Sprite {

    private var _icon: Image;
    private var _tf: TextField;

    /**
     * @param $assetsManager Менеджер ресурсов старлинга.
     */
    public function SuppliesIndicator($assetsManager: AssetManager) {
        _icon = new Image($assetsManager.getTexture("icon-supplies"));
        addChild(_icon);

        _tf = new TextField(60, 60, "x0", "PoplarStd", 30, 0xFFFFFF);
        _tf.hAlign = HAlign.LEFT;
        _tf.x = _icon.width+10;
        var glowFilter:GlowFilter = new GlowFilter();
        glowFilter.color = 0x000000;
        glowFilter.blurX = 5;
        glowFilter.blurY = 5;
        glowFilter.strength = 4;
//        glowFilter.inner = true;
        _tf.nativeFilters = [glowFilter];
        addChild(_tf);

        _tf.filter = BlurFilter.createGlow(0, 1, 3, 1);
    }

    public function update($amount: int):void {
        _tf.text = "x"+$amount;
    }
}
}
