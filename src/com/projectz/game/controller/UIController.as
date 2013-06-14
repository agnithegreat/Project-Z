/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 9:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller {
import com.projectz.game.controller.events.selectDefender.SelectDefenderEvent;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.events.EventDispatcher;
import starling.utils.AssetManager;

/**
* Отправляется при выборе защитника для добавления на карту.
*
* @eventType com.projectz.game.controller.events.selectDefender.SelectDefenderEvent.SELECT_DEFENDER
*/
[Event(name="select defender", type="com.projectz.game.controller.events.selectDefender.SelectDefenderEvent")]

public class UIController extends EventDispatcher {

    private var _currentDefenderData:DefenderData;

    private var _gameController: GameController;
    private var _assetManager: AssetManager;

    public function get assetManager():AssetManager {
        return _assetManager;
    }

    public function UIController($game: GameController, $assets: AssetManager) {
        _gameController = $game;
        _assetManager = $assets;
    }

    /**
     * Текущий выбранный защитник для добавления на карту.
     */
    public function get currentDefenderData():DefenderData {
        return _currentDefenderData;
    }

    public function set currentDefenderData(value:DefenderData):void {
        _currentDefenderData = value;
        dispatchEvent(new SelectDefenderEvent(_currentDefenderData, SelectDefenderEvent.SELECT_DEFENDER));
    }

    /**
     * Добавление на карту текущего выбранного защитника.
     * @param $x Координата x защитника для добавления на карту.
     * @param $y Координата y защитника для добавления на карту.
     */
    public function addDefender($x: int, $y: int):void {
        if (currentDefenderData) {
            _gameController.addDefender(currentDefenderData, $x, $y);
        }
    }


}
}
