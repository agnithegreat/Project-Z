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

import flash.events.Event;

import flash.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный редактирования карты уровня. Получая команды от view (представления) изменяет данные в модели.
 */
public class LevelEditorController extends EventDispatcher {

    private static var _instance:LevelEditorController;

    private var _mode:String;
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

    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
        dispatchEvent (new Event (LevelEditorEvent.SELECT_EDITOR_MODE));
    }

    public function get action():String {
        return _action;
    }

    public function set action(value:String):void {
        _action = value;
    }
}
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey() {

    }

}
