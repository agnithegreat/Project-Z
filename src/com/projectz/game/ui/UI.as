/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {
import com.projectz.game.controller.UIController;
import com.projectz.game.model.Game;
import com.projectz.game.ui.buttons.ButtonBase;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class UI extends Sprite {

    private var _topPanel: TopPanel;
    private var _bottomPanel: BottomPanel;

    /**
     * @param $model Ссылка на модель.
     * @param $assetsManager Менеджер ресурсов старлинга.
     * @param $uiController Ссылка на контроллер (mvc).
     */
    public function UI($model:Game, $uiController: UIController, $assetsManager: AssetManager) {
        ButtonBase.init($assetsManager);

        _topPanel = new TopPanel($model, $uiController, $assetsManager);
        addChild(_topPanel);

        _bottomPanel = new BottomPanel($model, $uiController, $assetsManager);
        _bottomPanel.y = Constants.HEIGHT;
        addChild(_bottomPanel);

        appear();
    }

    public function appear():void {
        _topPanel.appear();
        _bottomPanel.appear();
    }

    public function initDefenders (defenders:Vector.<DefenderData>):void {
        _bottomPanel.initDefenders(defenders);
    }
}
}
