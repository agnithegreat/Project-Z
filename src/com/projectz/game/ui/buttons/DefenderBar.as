/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 12.04.13
 * Time: 18:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class DefenderBar extends Sprite {

    private var _glow: Image;
    private var _back: Image;
    private var _progress: Image;

    public function DefenderBar($assets: AssetManager) {
        _glow = new Image($assets.getTexture("bar_radial-glow"));
        addChild(_glow);

        _back = new Image($assets.getTexture("bar_radial-back"));
        addChild(_back);

        _progress = new Image($assets.getTexture("bar_radial-progress"));
        addChild(_progress);
    }
}
}
