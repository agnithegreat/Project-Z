/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 20.03.13
 * Time: 14:45
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController {
import com.projectz.utils.levelEditor.model.Cell;

import starling.events.Event;

/**
 * Событие выбора клетки поля. Используется для отображения информации о клетках.
 */
public class SelectCellEvent extends Event {

    private var _cell:Cell;

    /**
     * Выбор клетки поля.
     */
    public static const SELECT_CELL:String = "select cell";

    public function SelectCellEvent($cell:Cell, type:String = SELECT_CELL, bubbles:Boolean = false) {
        this.cell = $cell;
        super (type, bubbles, $cell);
    }

    /**
     * Клетка поля.
     */
    public function get cell():Cell {
        return _cell;
    }

    public function set cell(value:Cell):void {
        _cell = value;
    }
}
}
