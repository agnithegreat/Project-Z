/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Game;

import starling.display.Sprite;

public class GameScreen extends Sprite {

    private var _game: Game;

    private var _field: FieldView;

    public function GameScreen($game: Game) {
        _game = $game;

        _field = new FieldView(_game.field);
        addChild(_field);
    }
}
}
