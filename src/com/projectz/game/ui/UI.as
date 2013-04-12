/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.game.ui.buttons.ButtonBase;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class UI extends Sprite {

    private var _topPanel: TopPanel;
    private var _bottomPanel: BottomPanel;

    public function UI($assets: AssetManager) {
        ButtonBase.init($assets);

        _topPanel = new TopPanel($assets);
        addChild(_topPanel);

        _bottomPanel = new BottomPanel($assets);
        _bottomPanel.y = Constants.HEIGHT;
        addChild(_bottomPanel);

        appear();
    }

    public function appear():void {
        _topPanel.appear();
        _bottomPanel.appear();
    }
}
}
