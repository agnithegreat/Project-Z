/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {
import com.hogargames.errors.SingletonError;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;
import com.projectz.utils.levelEditor.events.SelectBackGroundEvent;
import com.projectz.utils.levelEditor.events.SelectObjectEvent;
import com.projectz.utils.levelEditor.events.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.events.ShowCellInfoEvent;
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный редактирования карты уровня. Получая команды, диспатчит события.
 */
public class LevelEditorController extends EventDispatcher {

    private static var _instance:LevelEditorController;

    private var _mode:String;//режим работы редактора (редактор объектов, редактор путей и т.д.);
    private var _action:String;

    public function LevelEditorController(key:SingletonKey = null) {
        if (!key) {
            throw new SingletonError();
        }
    }

    public static function getInstance():LevelEditorController {
        if (!_instance) {
            _instance = new LevelEditorController(new SingletonKey());
        }
        return _instance;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //GET, SET:
    /////////////////////////////////////////////

    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
        dispatchEventWith(LevelEditorEvent.SELECT_EDITOR_MODE);
    }

    public function get action():String {
        return _action;
    }

    public function set action(value:String):void {
        _action = value;
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    public function selectObject (objectData:ObjectData):void {
        if (mode == LevelEditorMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectEvent(objectData));
        }
    }

    public function selectObjectType (objectsType:String):void {
        if (mode == LevelEditorMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectsTypeEvent(objectsType));
        }
    }

    public function selectBackground (objectData:ObjectData):void {
        if (mode == LevelEditorMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectBackGroundEvent(objectData));
        }
    }

    public function clearAllObjects ():void {
        if (mode == LevelEditorMode.EDIT_OBJECTS) {
            dispatchEvent(new LevelEditorEvent(LevelEditorEvent.REMOVE_ALL_OBJECTS));
        }
    }

    /////////////////////////////////////////////
    //MAP:
    /////////////////////////////////////////////

    public function showCellInfo ($cell:Cell):void {
        dispatchEvent(new ShowCellInfoEvent($cell));
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    public function save ():void {
        dispatchEvent(new LevelEditorEvent(LevelEditorEvent.SAVE));
    }

    public function export ():void {
        dispatchEvent(new LevelEditorEvent(LevelEditorEvent.EXPORT));
    }
}
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey() {

    }

}
