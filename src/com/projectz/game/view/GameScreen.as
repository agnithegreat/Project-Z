/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.model.Game;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class GameScreen extends Sprite {

    private var _assets: AssetManager;

    private var _game: Game;

    private var _field: FieldView;

    public function GameScreen($game: Game, $assets: AssetManager) {
        _assets = $assets;

        _game = $game;

        _field = new FieldView(_game.field, _assets);
        addChild(_field);
    }

    public function destroy():void {
        _game = null;

        _field.destroy();
        _field.removeFromParent(true);
        _field = null;
    }
}
}
