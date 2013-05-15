/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.05.13
 * Time: 18:36
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data.events.editLevels {
import com.projectz.utils.levelEditor.data.LevelData;

import starling.events.Event;

public class EditLevelsEvent extends Event {

    private var _levelData:LevelData;

    public static const LEVEL_WAS_ADDED: String = "level was added";
    public static const SET_LEVEL: String = "set level";
    public static const LEVEL_WAS_REMOVED: String = "level was removed";

    public function EditLevelsEvent (levelData:LevelData, type:String, bubbles:Boolean = false):void {
        this.levelData = levelData;
        super (type, bubbles, levelData);
    }

    public function get levelData():LevelData {
        return _levelData;
    }

    public function set levelData(value:LevelData):void {
        _levelData = value;
    }
}
}
