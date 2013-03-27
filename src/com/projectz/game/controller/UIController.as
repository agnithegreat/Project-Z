/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 9:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller {
import starling.events.EventDispatcher;

public class UIController extends EventDispatcher {

    private var _gameController: GameController;

    public function UIController($game: GameController) {
        _gameController = $game;
    }

    public function addDefender($x: int, $y: int):void {
        _gameController.addDefender($x, $y);
    }
}
}
