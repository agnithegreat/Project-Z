/**
 * Created with IntelliJ IDEA.
 * User: maxim
 * Date: 19.03.13
 * Time: 13:10
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.utils.levelEditor.data.PlaceData;

public class Generator {

    private var _x: int;
    private var _y: int;
    private var _type: String;
    private var _delay: int;
    private var _amount: int;

    private var _time: int;

    private var _enabled: Boolean;

    public function Generator($x: int, $y: int, $type: String, $delay: int, $amount: int) {
        _x = $x;
        _y = $y;
        _type = $type;
        _delay = $delay;
        _amount = $amount;

        _time = 0;
        _enabled = true;
    }

    public function createEnemy():PlaceData {
        if (!_enabled || ++_time < _delay) {
            return null;
        }
        _time = 0;
        _enabled = --_amount > 0;

        var place: PlaceData = new PlaceData();
        place.place(_x, _y);
        place.object = _type;
        return place;
    }
}
}
