/**
 * Created with IntelliJ IDEA.
 * User: maxim
 * Date: 19.03.13
 * Time: 13:10
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.PlaceData;

public class Generator {

    private var _data: GeneratorData;

    private var _amount: int;
    private var _time: int;

    public function get path():int {
        return _data.path;
    }

    private var _enabled: Boolean;

    public function Generator($data: GeneratorData) {
        _data = $data;

        _amount = _data.amount;
        _time = 0;
        _enabled = true;
    }

    public function createEnemy():PlaceData {
        if (!_enabled || ++_time < _data.delay) {
            return null;
        }
        _time = 0;
        _enabled = --_amount > 0;

        var place: PlaceData = new PlaceData();
        place.place(_data.x, _data.y);
        place.object = _data.type;
        return place;
    }
}
}
