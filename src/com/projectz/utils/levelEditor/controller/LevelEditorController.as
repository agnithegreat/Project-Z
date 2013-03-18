/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {
import com.hogargames.errors.SingletonError;

import flash.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный редактирования карты уровня. Получая команды от view (представления) изменяет данные в модели.
 */
public class LevelEditorController extends EventDispatcher {

    private static var _instance:LevelEditorController;

    private var _editionMode:String;

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

    public function get editionMode():String {
        return _editionMode;
    }

    public function set editionMode(value:String):void {
        _editionMode = value;
    }
}
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey() {

    }

}
