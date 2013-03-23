/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 11:49
 * To change this template use File | Settings | File Templates.
 */

package com.projectz.utils.levelEditor.controller {
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectEditPathModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.ShowCellInfoEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent;
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.ObjectData;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный для взаимодействия ui и view (возможна работа с нескольким ui).
 * <p>Сохраняет состояние режима работы (редактор объектов, редактор путей и т.д.)</p>
 * <p>Таккже реализует функционал классического контролера (композиция, ссылка на контролер редактора (классический mvc контроллер)).</p>
 */
public class UIController extends EventDispatcher {

    private var levelEditorController:LevelEditorController;

    private var _mode:String;//режим работы ui-контролера (редактор объектов, редактор путей и т.д.);
    private var _editPathMode:String = EditPathMode.ADD_POINTS;//режим работы ui-контролера при редактировании пути (удаление точек или добавление);
    private var _currentEditingPath:PathData;

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
     * Режим работы контролера (редактор объектов, редактор путей и т.д.)
     *
     * @see com.projectz.utils.levelEditor.controller.UIControllerMode
     */
    public function get mode():String {
        return _mode;
    }

    public function set mode(value:String):void {
        _mode = value;
        dispatchEvent(new SelectModeEvent(_mode));
    }

    /**
     * Режим работы контролера при редактировании пути (удаление точек или добавление);
     *
     * @see com.projectz.utils.levelEditor.controller.EditPathMode
     */
    public function get editPathMode():String {
        return _editPathMode;
    }

    public function set editPathMode(value:String):void {
        _editPathMode = value;
        dispatchEvent(new SelectEditPathModeEvent(_editPathMode));
    }

    /**
     * Текущий выбранный для редактирования путь;
     */
    public function get currentEditingPath():PathData {
        return _currentEditingPath;
    }

    public function set currentEditingPath(value:PathData):void {
        _currentEditingPath = value;
        dispatchEvent(new SelectPathEvent(_currentEditingPath));
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

    public function editPointToCurrentPath (point:Point):void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            if (editPathMode == EditPathMode.ADD_POINTS) {
                levelEditorController.addPointToPath (point, currentEditingPath);
            }
            else if (editPathMode == EditPathMode.REMOVE_POINTS) {
                levelEditorController.removePointFromPath (point, currentEditingPath);
            }
            else if (editPathMode == EditPathMode.SELECT_TARGET) {
                levelEditorController.selectPathTarget (point, currentEditingPath);
            }
        }
    }

    public function setPathColor (color:uint):void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            levelEditorController.setPathColor (color, currentEditingPath);
        }
    }

    public function addNewPath ():void {
        if (mode == UIControllerMode.EDIT_PATHS) {
            levelEditorController.addNewPath ();
        }
    }


    public function deleteCurrentEditingPath ():void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            levelEditorController.deletePath (currentEditingPath);
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
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.addObject(placeData);
        }
    }

    public function selectObject ($x: int, $y: int):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.selectObject($x,  $y);
        }
    }

    public function clearAllObjects():void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.clearAllObjects();
        }
    }

    public function save ():void {
        levelEditorController.save();
    }

    public function export ():void {
        levelEditorController.export();
    }

}
}