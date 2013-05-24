/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.game.controller.UIController;
import com.projectz.game.controller.events.selectDefender.SelectDefenderEvent;
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Game;
import com.projectz.game.ui.buttons.DefenderBar;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class BottomPanel extends Sprite {

    private var model:Game;//Ссылка на модель.
    private var uiController: UIController;//Ссылка на контроллер (mvc).
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    private var _bg: Image;

    private var _defenderBarsContainer: Sprite;//Контейнер для кнопок выбора защитников.

    private static const BAR_DISTANCE_X:int = 104;

    /**
     * @param $model Ссылка на модель.
     * @param $assetsManager Менеджер ресурсов старлинга.
     * @param $uiController Ссылка на контроллер (mvc).
     */
    public function BottomPanel($model:Game, $uiController: UIController, $assetsManager: AssetManager) {
        this.model = $model;
        this.assetsManager = $assetsManager;
        this.uiController = $uiController;

        _bg = new Image($assetsManager.getTexture("panel-bottom"));
        _bg.touchable = false;
        addChild(_bg);

        _defenderBarsContainer = new Sprite();
        addChild(_defenderBarsContainer);

        uiController.addEventListener(SelectDefenderEvent.SELECT_DEFENDER, selectDefenderListener);
        model.addEventListener(GameEvent.SET_MONEY, setMoneyListener);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function initDefenders (defenders:Vector.<DefenderData>):void {
        var defenderBar:DefenderBar;
        while (_defenderBarsContainer.numChildren > 0) {
            defenderBar = DefenderBar (_defenderBarsContainer.getChildAt(0));
            defenderBar.removeEventListener(TouchEvent.TOUCH, touchListener);
            defenderBar.destroy();
        }
        for (var i:int = 0; i < defenders.length; i++) {
            defenderBar = new DefenderBar(assetsManager);
            defenderBar.addEventListener(TouchEvent.TOUCH, touchListener);
            defenderBar.x = BAR_DISTANCE_X * i;
            defenderBar.defenderData = defenders [i];
            _defenderBarsContainer.addChild(defenderBar);
        }
    }

    public function appear():void {
        pivotY = 0;
        Starling.juggler.tween(this, 1, {
            pivotY: _bg.height
        });
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    protected function touchListener(event:TouchEvent):void {
        var defenderBar:DefenderBar = DefenderBar (event.currentTarget);
        var touch:Touch = event.getTouch(stage);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.BEGAN:                                      // press
                    var defenderData:DefenderData = defenderBar.defenderData;
                    if (defenderData) {
                        trace("select defenderData " + defenderData.name);
                        if (uiController.currentDefenderData == defenderData) {
                            uiController.currentDefenderData = null;
                        }
                        else {
                            if (defenderData.cost <= model.money) {
                                uiController.currentDefenderData = defenderData;
                            }
                        }
                    }
                    break;
//                case TouchPhase.ENDED:                                      // click
//                    //
//                    break;
//                default :
            }
        }
    }

    private function selectDefenderListener (event:SelectDefenderEvent):void {
        var defenderData:DefenderData = event.defenderData;
        var numDefendersBars:int = _defenderBarsContainer.numChildren;
        for (var i:int = 0; i < numDefendersBars; i++) {
            var defenderBar:DefenderBar = DefenderBar (_defenderBarsContainer.getChildAt(i));
            if (defenderData) {
                if (defenderBar.defenderData == defenderData) {
                    defenderBar.show();
                }
                else {
                    defenderBar.hide();
                }
            }
            else {
                defenderBar.show();
            }
        }
    }

    private function setMoneyListener (event:Event):void {
        var money:int = model.money;
        var numDefendersBars:int = _defenderBarsContainer.numChildren;
        for (var i:int = 0; i < numDefendersBars; i++) {
            var defenderBar:DefenderBar = DefenderBar (_defenderBarsContainer.getChildAt(i));
            var defenderData:DefenderData = defenderBar.defenderData;
            if (defenderData) {
                var percent:int = money / defenderData.cost * 100;
                defenderBar.setPercent(percent);
            }
        }
    }

}
}
