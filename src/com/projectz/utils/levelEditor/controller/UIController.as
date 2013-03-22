/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 11:49
 * To change this template use File | Settings | File Templates.
 */

package com.projectz.utils.levelEditor.controller {
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.events.uiController.SelectBackgroundEvent;
import com.projectz.utils.levelEditor.events.uiController.SelectObjectEvent;
import com.projectz.utils.levelEditor.events.uiController.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.events.uiController.ShowCellInfoEvent;
import com.projectz.utils.levelEditor.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный для взаимодействия ui и view (возможна работа с нескольким ui).
 * <p>Сохраняет состояние режима работы (редактор объектов, редактор путей и т.д.)</p>
 * <p>Таккже реализует функционал классического контролера (композиция, ссылка на контролер редактора (классический mvc контроллер)).</p>
 */
public class UIController extends EventDispatcher {

    private var levelEditorController:LevelEditorController

    private var _mode:String;//режим работы ui-контролера (редактор объектов, редактор путей и т.д.);

    public function UIController(levelEditorController:LevelEditorController) {
        this.levelEditorController = levelEditorController;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //GET, SET:
    /////////////////////////////////////////////


    /**
     * Режим работы контролера редактора (редактор объектов, редактор путей и т.д.)
     *
     * @see com.projectz.utils.levelEditor.controller.UIControllerMode
     */
    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
        dispatchEvent(new SelectUIControllerModeEvent(_mode));
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    public function selectCurrentObject(objectData:ObjectData):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectEvent(objectData));
        }
    }

    public function selectCurrentObjectType(objectsType:String):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectsTypeEvent(objectsType));
        }
    }

    public function selectLevelBackground(objectData:ObjectData):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectBackgroundEvent(objectData));
            levelEditorController.changeBackground(objectData);
        }
    }

    /////////////////////////////////////////////
    //INFO:
    /////////////////////////////////////////////

    public function showCellInfo($cell:Cell):void {
        dispatchEvent(new ShowCellInfoEvent($cell));
    }

    /////////////////////////////////////////////
    //LEVEL EDITOR CONTROLLER:
    //Методы классического mvc контроллера
    /////////////////////////////////////////////

    public function addObject (placeData:PlaceData):void {
        levelEditorController.addObject(placeData);
    }

    public function selectObject ($x: int, $y: int):void {
        levelEditorController.selectObject($x,  $y);
    }

    public function clearAllObjects():void {
        levelEditorController.clearAllObjects();
    }

    public function save ():void {
        levelEditorController.save();
    }

    public function export ():void {
        levelEditorController.export();
    }

}
}