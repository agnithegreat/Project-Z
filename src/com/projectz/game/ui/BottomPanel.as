/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.game.ui.buttons.DefenderBar;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class BottomPanel extends Sprite {

    private var _bg: Image;

    private var _defenderBarsContainer: Sprite;//Контейнер для кнопок выбора защитников.

    public function BottomPanel($assets: AssetManager) {
        _bg = new Image($assets.getTexture("panel-bottom"));
        _bg.touchable = false;
        addChild(_bg);

        _defenderBarsContainer = new Sprite();
        addChild(_defenderBarsContainer);

        var boy: DefenderBar = new DefenderBar($assets);
        _defenderBarsContainer.addChild(boy);

        var farmer: DefenderBar = new DefenderBar($assets);
        farmer.x = boy.x + boy.width;
        _defenderBarsContainer.addChild(farmer);

        var sheriff: DefenderBar = new DefenderBar($assets);
        sheriff.x = farmer.x + farmer.width;
        _defenderBarsContainer.addChild(sheriff);
    }

    public function appear():void {
        pivotY = 0;
        Starling.juggler.tween(this, 1, {
            pivotY: _bg.height
        });
    }
}
}
