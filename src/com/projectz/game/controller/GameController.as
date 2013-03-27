/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 9:49
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller {
import com.projectz.game.model.Game;

import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    private var _model: Game;

    public function GameController($game: Game) {
        _model = $game;
    }

    public function addDefender($x: int, $y: int):void {
        _model.field.blockCell($x, $y);
    }
}
}
