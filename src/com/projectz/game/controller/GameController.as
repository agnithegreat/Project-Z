/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 9:49
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.controller {
import com.projectz.game.model.Game;
import com.projectz.utils.objectEditor.data.DefenderData;

import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    private var _model: Game;

    public function GameController($game: Game) {
        _model = $game;
    }

    /**
     * Добавление на карту защитника.
     * @param $defenderData Защитник.
     * @param $x Координата x защитника для добавления на карту.
     * @param $y Координата y защитника для добавления на карту.
     */
    public function addDefender($defenderData:DefenderData, $x: int, $y: int):void {
        _model.addDefender($defenderData, $x, $y);
    }
}
}
