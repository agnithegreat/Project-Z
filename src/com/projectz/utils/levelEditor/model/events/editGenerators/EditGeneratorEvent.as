/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.04.13
 * Time: 12:00
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editGenerators {
import com.projectz.utils.levelEditor.data.GeneratorData;

import starling.events.Event;

/**
 * Событие изменения генератора.
 */
public class EditGeneratorEvent extends Event {

    private var _generatorData:GeneratorData;

    /**
     * Добавление нового генератора.
     */
    public static const GENERATOR_WAS_ADDED:String = "generator was added";
    /**
     * Изменение генератора.
     */
    public static const GENERATOR_WAS_CHANGED:String = "generator was changed";
    /**
     * Удаление генератора.
     */
    public static const GENERATOR_WAS_REMOVED:String = "generator was removed";

    public function EditGeneratorEvent(generatorData:GeneratorData, type:String = GENERATOR_WAS_CHANGED, bubbles:Boolean = false) {
        this.generatorData = generatorData;
        super(type, bubbles, generatorData);
    }

    public function get generatorData():GeneratorData {
        return _generatorData;
    }

    public function set generatorData(value:GeneratorData):void {
        _generatorData = value;
    }
}
}
