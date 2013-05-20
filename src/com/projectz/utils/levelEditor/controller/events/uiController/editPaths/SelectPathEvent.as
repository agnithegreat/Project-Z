/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.13
 * Time: 11:35
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editPaths {
import com.projectz.utils.levelEditor.data.PathData;

import starling.events.Event;

/**
 * Событие выбора пути для редактирования.
 */
public class SelectPathEvent extends Event {

    private var _pathData:PathData;

    /**
     * Выбор пути для редактирования.
     */
    public static const SELECT_PATH:String = "select path";

    public function SelectPathEvent(pathData:PathData, type:String = SELECT_PATH, bubbles:Boolean = false) {
        this.pathData = pathData;
        super(type, bubbles, pathData);
    }

    /**
     * Путь.
     */
    public function get pathData():PathData {
        return _pathData;
    }

    public function set pathData(value:PathData):void {
        _pathData = value;
    }
}
}
