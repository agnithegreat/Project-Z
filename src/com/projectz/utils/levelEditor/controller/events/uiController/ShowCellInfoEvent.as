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

public class ShowCellInfoEvent extends Event {

    private var _cell:Cell;

    public static const SHOW_CELL_INFO:String = "show cell info";

    public function ShowCellInfoEvent($cell:Cell, type:String = SHOW_CELL_INFO, bubbles:Boolean = false) {
        this.cell = $cell;
        super (type, bubbles, $cell);
    }

    public function get cell():Cell {
        return _cell;
    }

    public function set cell(value:Cell):void {
        _cell = value;
    }
}
}
