/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.04.13
 * Time: 12:21
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editGenerators {
import com.projectz.utils.levelEditor.data.WaveData;

import starling.events.Event;

/**
 * Событие изменение волны.
 */
public class EditWavesEvent extends Event {

    private var _waveData:WaveData;
    /**
     * Добавление волны.
     */
    public static const WAVE_WAS_ADDED:String = "wave was added";
    /**
     * Изменение волны.
     */
    public static const WAVE_WAS_CHANGED:String = "wave was changed";
    /**
     * Удаление волны.
     */
    public static const WAVE_WAS_REMOVED:String = "wave was removed";


    public function EditWavesEvent(waveData:WaveData, type:String = WAVE_WAS_CHANGED, bubbles:Boolean = false) {
        this.waveData = waveData;
        super(type, bubbles, waveData);
    }

    /**
     * Волна.
     */
    public function get waveData():WaveData {
        return _waveData;
    }

    public function set waveData(value:WaveData):void {
        _waveData = value;
    }
}
}