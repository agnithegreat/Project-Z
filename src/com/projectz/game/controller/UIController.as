/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 9:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller {
import starling.events.EventDispatcher;
import starling.utils.AssetManager;

public class UIController extends EventDispatcher {

    private var _gameController: GameController;

    private var _assets: AssetManager;
    public function get assets():AssetManager {
        return _assets;
    }

    public function UIController($game: GameController, $assets: AssetManager) {
        _gameController = $game;
        _assets = $assets;
    }

    public function addDefender($x: int, $y: int):void {
        _gameController.addDefender($x, $y);
    }
}
}
