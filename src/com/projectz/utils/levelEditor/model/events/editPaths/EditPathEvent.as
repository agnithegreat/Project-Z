/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.13
 * Time: 15:14
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editPaths {
import com.projectz.utils.levelEditor.data.PathData;

import starling.events.Event;

/**
 * Событие изменения пути.
 */
public class EditPathEvent extends Event {

    private var _pathData:PathData;

    /**
     * Добавление пути.
     */
    public static const PATH_WAS_ADDED:String = "path was added";
    /**
     * Изменение пути.
     */
    public static const PATH_WAS_CHANGED:String = "path was changed";
    /**
     * Изменение цвета пути.
     */
    public static const PATH_COLOR_WAS_CHANGED:String = "path color was changed";
    /**
     * Удаление пути.
     */
    public static const PATH_WAS_REMOVED:String = "path was removed";

    public function EditPathEvent(pathData:PathData, type:String = PATH_WAS_CHANGED, bubbles:Boolean = false) {
        this.pathData = pathData;
        super(type, bubbles, pathData);
    }

    /**
     * Данные о пути.
     */
    public function get pathData():PathData {
        return _pathData;
    }

    public function set pathData(value:PathData):void {
        _pathData = value;
    }
}
}
