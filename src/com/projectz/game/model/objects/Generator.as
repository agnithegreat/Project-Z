/**
 * Created with IntelliJ IDEA.
 * User: maxim
 * Date: 19.03.13
 * Time: 13:10
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.PlaceData;

public class Generator {

    private var _data: GeneratorData;

    private var _wave: GeneratorWaveData;

    private var _generated: int;
    private var _time: Number;

    public function get path():int {
        return _data.pathId;
    }

    private var _enabled: Boolean;
    public function get enabled():Boolean {
        return _enabled;
    }

    public function Generator($data: GeneratorData) {
        _data = $data;
    }

    public function initWave($wave: int):void {
        _wave = _data.waves[$wave-1];

        _generated = 0;
        _time = 0;
        _enabled = _wave.amount>0;
    }

    public function tick($delta: Number):void {
        _time += $delta;
    }

    public function get isReady():Boolean {
        return _enabled && _time >= _wave.delay;
    }

    public function createEnemy():PlaceData {
        if (!isReady) {
            return null;
        }
        _time = 0;

        var place: PlaceData = new PlaceData();
        place.place(_data.x, _data.y);
        place.object = _wave.sequence[_generated];

        _enabled = ++_generated < _wave.amount;
        return place;
    }
}
}
