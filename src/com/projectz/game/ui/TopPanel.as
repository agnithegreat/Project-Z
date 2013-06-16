/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.AppSettings;
import com.projectz.app.ui.elements.BasicButtonWithIcon;
import com.projectz.app.ui.popups.PopUpManager;
import com.projectz.app.ui.screens.AppScreens;
import com.projectz.game.controller.UIController;
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Game;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class TopPanel extends Sprite {

    private var model:Game;//Ссылка на модель.
    private var uiController: UIController;//Ссылка на контроллер (mvc).

    private var _bg: Image;

    private var _supplies: SuppliesIndicator;

    private var btnMenu: BasicButtonWithIcon;
    private var btnPlay: BasicButtonWithIcon;
    private var btnPause: BasicButtonWithIcon;

    private const BUTTON_TOP_MARGIN:int = 2;
    private const BUTTON_RIGHT_MARGIN:int = 10;
    private const BUTTON_DISTANCE:int = 10;

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

        var scaleFactor:int = AppSettings.scaleFactor;
        btnMenu = new BasicButtonWithIcon(2, "Menu", $assetsManager.getTexture("icon-btn_menu"));
        btnMenu.x = _bg.width - btnMenu.width - BUTTON_RIGHT_MARGIN * scaleFactor;
        btnMenu.y = (_bg.height - btnMenu.height) / 2 - BUTTON_TOP_MARGIN * scaleFactor;
        btnMenu.addEventListener (TouchEvent.TOUCH, touchListener);
        addChild(btnMenu);

        btnPlay = new BasicButtonWithIcon(0, "", $assetsManager.getTexture("icon-btn_play"));
        btnPlay.x = _bg.width - btnMenu.width - btnPlay.width - (BUTTON_RIGHT_MARGIN + BUTTON_DISTANCE) * scaleFactor;
        btnPlay.y = (_bg.height - btnPlay.height) / 2 - BUTTON_TOP_MARGIN * scaleFactor;
        btnPlay.addEventListener (TouchEvent.TOUCH, touchListener);
        addChild(btnPlay);

        btnPause = new BasicButtonWithIcon(0, "", $assetsManager.getTexture("icon-btn_pause"));
        btnPause.x = _bg.width - btnMenu.width - btnPause.width - (BUTTON_RIGHT_MARGIN + BUTTON_DISTANCE) * scaleFactor;
        btnPause.y = (_bg.height - btnPause.height) / 2 - BUTTON_TOP_MARGIN * scaleFactor;
        btnPause.addEventListener (TouchEvent.TOUCH, touchListener);
        addChild(btnPause);

        model.addEventListener(GameEvent.SET_MONEY, setMoneyListener);
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

    private function touchListener (event:TouchEvent):void {
        var touch:Touch = event.getTouch(stage);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.BEGAN:                                      // press
                    switch (event.currentTarget) {
                        case (btnMenu):
                            PopUpManager.getInstance().openScreen(AppScreens.LEVEL_MENU_SCREEN);
                            break;
                        case (btnPlay):
                            //TODO:Привязать изменение модели.
                            playListener (null);
                            break;
                        case (btnPause):
                            //TODO:Привязать изменение модели.
                            pauseListener (null);
                            break;
                    }
                    break;
//                case TouchPhase.ENDED:                                      // click
//                    //
//                    break;
//                default :
            }
        }
    }

    private function pauseListener (event:Event):void {
        btnPause.visible = false;
        btnPlay.visible = true;
    }

    private function playListener (event:Event):void {
        btnPause.visible = true;
        btnPlay.visible = false;
    }
}
}
