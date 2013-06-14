/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {

import com.projectz.game.controller.UIController;
import com.projectz.game.model.Game;
import com.projectz.game.ui.UI;
import com.projectz.game.view.FieldView;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class GameScreen extends Sprite implements IScreen {

    private var _game: Game;//Ссылка на модель (mvc).

    private var _ui: UI;
    private var _field: FieldView;

    /**
     * @param $game Ссылка на модель (mvc).
     * @param $assetsManager Менеджер ресурсов старлинга.
     * @param $uiController Ссылка на контроллер (mvc).
     */
    public function GameScreen($game: Game, $uiController: UIController, $assetsManager: AssetManager) {
        _game = $game;

        _field = new FieldView(_game.field, $uiController);
        _ui = new UI(_game, $uiController, $assetsManager);

        addChild(_field);
        addChild(_ui);
    }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

    /**
     * @inheritDoc
     */
    public function onOpen ():void {

    }

    /**
     * @inheritDoc
     */
    public function onClose ():void {

    }

    public function initDefenders (defenders:Vector.<DefenderData>):void {
        _ui.initDefenders(defenders);
    }

    public function destroy():void {
        _game = null;

        _field.destroy();
        _field.removeFromParent(true);
        _field = null;

        _ui.destroy();
        _ui.removeFromParent(true);
        _ui = null;
    }
}
}
