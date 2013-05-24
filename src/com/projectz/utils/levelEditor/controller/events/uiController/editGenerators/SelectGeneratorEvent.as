/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.04.13
 * Time: 12:04
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editGenerators {
import com.projectz.utils.levelEditor.data.GeneratorData;

import starling.events.Event;

/**
 * Событие выбора генератора для редактирования.
 */
public class SelectGeneratorEvent extends Event {

    private var _generatorData:GeneratorData;

    /**
     * Выбор генератора для редактирования.
     */
    public static const SELECT_GENERATOR:String = "select generator";

    public function SelectGeneratorEvent(generatorData:GeneratorData, type:String = SELECT_GENERATOR, bubbles:Boolean = false) {
        this.generatorData = generatorData;
        super(type, bubbles, generatorData);
    }

    /**
     * Генератор.
     */
    public function get generatorData():GeneratorData {
        return _generatorData;
    }

    public function set generatorData(value:GeneratorData):void {
        _generatorData = value;
    }
}
}
