/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.game.controller.UIController;
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Game;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class TopPanel extends Sprite {

    private var model:Game;//Ссылка на модель.
    private var uiController: UIController;//Ссылка на контроллер (mvc).

    private var _bg: Image;

    private var _supplies: SuppliesIndicator;

    /**
     * @param $model Ссылка на модель.
     * @param $assetsManager Менеджер ресурсов старлинга.
     * @param $uiController Ссылка на контроллер (mvc).
     */
    public function TopPanel($model:Game, $uiController: UIController, $assetsManager: AssetManager) {
        this.model = $model;
        this.uiController = $uiController;
        _bg = new Image($assetsManager.getTexture("panel-top"));
        _bg.touchable = false;
        addChild(_bg);

        _supplies = new SuppliesIndicator($assetsManager);
        addChild(_supplies);

        var menu: Button = new Button($assetsManager.getTexture("btn-temp-02"));
        menu.x = _bg.width-menu.width-10;
        menu.y = (_bg.height-menu.height)/2-2;
        addChild(menu);

        model.addEventListener(GameEvent.SET_MONEY, setMoneyListener);

//        var button: ButtonBase = new ButtonBase(2, "", $assets.getTexture("icon-btn_menu"));
//        button.scaleX = button.scaleY = 0.5;
//        button.x = _bg.width-button.width;
//        addChild(button);


    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function update($amount: int):void {
        _supplies.update($amount);
    }

    public function appear():void {
        pivotY = _bg.height;
        Starling.juggler.tween(this, 1, {
            pivotY: 0
        });
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function setMoneyListener (event:Event):void {
        update(model.money);
    }
}
}
