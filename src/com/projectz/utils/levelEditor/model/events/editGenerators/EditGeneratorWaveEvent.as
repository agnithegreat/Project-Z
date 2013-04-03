/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.04.13
 * Time: 15:11
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editGenerators {
import com.projectz.utils.levelEditor.data.GeneratorWaveData;

import starling.events.Event;

public class EditGeneratorWaveEvent extends Event {

    private var _generatorWaveData:GeneratorWaveData;

    public static const GENERATOR_WAVE_WAS_CHANGED:String = "generator wave was changed";

    public function EditGeneratorWaveEvent(generatorWaveData:GeneratorWaveData, type:String = GENERATOR_WAVE_WAS_CHANGED, bubbles:Boolean = false) {
        this.generatorWaveData = generatorWaveData;
        super(type, bubbles, generatorWaveData);
    }

    public function get generatorWaveData():GeneratorWaveData {
        return _generatorWaveData;
    }

    public function set generatorWaveData(value:GeneratorWaveData):void {
        _generatorWaveData = value;
    }
}
}