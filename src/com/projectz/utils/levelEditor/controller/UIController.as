/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 11:49
 * To change this template use File | Settings | File Templates.
 */

package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectEditDefenderPositionModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectEditPathModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.ShowCellInfoEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent;
import com.projectz.utils.levelEditor.data.WaveData;
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

    private var _currentEditingPath:PathData;//текущий редактируемый путь
    private var _editPathMode:String = EditMode.ADD_POINTS;//режим работы ui-контролера при редактировании пути (удаление точек или добавление);
    private var _editPathAreaMode:Boolean;//значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании путей.

    private var _currentEditingGenerator:GeneratorData;//текущий редактируемый генератор

    private var _currentEditingDefenderPosition:DefenderPositionData;//текущая редактируемая позиция защитника
    private var _editDefenderZonesMode:String = EditMode.ADD_POINTS;//режим работы ui-контролера при редактировании зон защитников (удаление точек или добавление);
    private var _editDefenderZonesAreaMode:Boolean;//значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании зон защитников.

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
     * Режим работы контролера (редактор объектов, редактор путей и т.д.).
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
    //PATHS:
    /////////////////////////////////////////////

    /**
     * Текущий редактируемый путь
     */
    public function get currentEditingPath():PathData {
        return _currentEditingPath;
    }

    public function set currentEditingPath(value:PathData):void {
        _currentEditingPath = value;
        dispatchEvent(new SelectPathEvent(_currentEditingPath));
    }

    /**
     * Режим работы контролера при редактировании пути (удаление точек или добавление).
     *
     * @see com.projectz.utils.levelEditor.controller.EditMode
     */
    public function get editPathMode():String {
        return _editPathMode;
    }

    public function set editPathMode(value:String):void {
        _editPathMode = value;
        dispatchEvent(new SelectEditPathModeEvent(_editPathMode));
    }

    /**
     * Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании путей.
     */
    public function get editPathAreaMode():Boolean {
        return _editPathAreaMode;
    }

    public function set editPathAreaMode(value:Boolean):void {
        _editPathAreaMode = value;
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

    /////////////////////////////////////////////
    //GENERATORS:
    /////////////////////////////////////////////

    public function get currentEditingGenerator():GeneratorData {
        return _currentEditingGenerator;
    }

    public function set currentEditingGenerator(value:GeneratorData):void {
        _currentEditingGenerator = value;
        dispatchEvent(new SelectGeneratorEvent(_currentEditingGenerator));
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    /**
     * Текущая редактируемая позиция защитника
     */
    public function get currentEditingDefenderPosition():DefenderPositionData {
        return _currentEditingDefenderPosition;
    }

    public function set currentEditingDefenderPosition(value:DefenderPositionData):void {
        _currentEditingDefenderPosition = value;
        dispatchEvent(new SelectDefenderPositionEvent(_currentEditingDefenderPosition));
    }

    /**
     * Режим работы контролера при редактировании зон защитников (удаление точек или добавление).
     *
     * @see com.projectz.utils.levelEditor.controller.EditMode
     */
    public function get editDefenderZonesMode():String {
        return _editDefenderZonesMode;
    }

    public function set editDefenderZonesMode(value:String):void {
        _editDefenderZonesMode = value;
        dispatchEvent(new SelectEditDefenderPositionModeEvent(_editDefenderZonesMode));
    }

    /**
     * Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при зон защитнико.
     */
    public function get editDefenderZonesAreaMode():Boolean {
        return _editDefenderZonesAreaMode;
    }

    public function set editDefenderZonesAreaMode(value:Boolean):void {
        _editDefenderZonesAreaMode = value;
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

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    public function selectLevelBackground(objectData:ObjectData):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectBackgroundEvent(objectData));
            levelEditorController.changeBackground(objectData);
        }
    }

    public function addObject (placeData:PlaceData):Boolean {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            return levelEditorController.addObject(placeData);
        }
        return false;
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

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    public function editPointToCurrentPath (points:Vector.<Point>):void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            if (editPathMode == EditMode.ADD_POINTS) {
                levelEditorController.addPointToPath (points, currentEditingPath);
            }
            else if (editPathMode == EditMode.REMOVE_POINTS) {
                levelEditorController.removePointFromPath (points, currentEditingPath);
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
    //GENERATORS:
    /////////////////////////////////////////////

    public function addNewGenerator ():void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addNewGenerator();
        }
    }

    public function removeGenerator (generatorData:GeneratorData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeGenerator(generatorData);
        }
    }

    public function setGeneratorPath (pathId:int):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            if (_currentEditingGenerator) {
                levelEditorController.setGeneratorPath(pathId, _currentEditingGenerator);
            }
        }
    }

    public function setGeneratorPosition (point:Point):void {
        if (mode == UIControllerMode.EDIT_GENERATORS && _currentEditingGenerator) {
            levelEditorController.setGeneratorPosition(point, _currentEditingGenerator);
        }
    }

    /////////////////////////////////////////////
    //WAVES:
    /////////////////////////////////////////////

    public function addNewWave():void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addNewWave();
        }
    }

    public function removeWave(waveId:int):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeWave(waveId);
        }
    }

    //устанавливаем время для волны:
    public function setWaveTime (time:int, waveData:WaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.setWaveTime(time, waveData);
        }
    }

    //устанавливаем задержку для волны генератора:
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.setDelayOfGeneratorWave(delay, generatorWaveData);
        }
    }

    //добавляем тип врага для волны генератора:
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addEnemyToGeneratorWave(enemyId, positionId, generatorWaveData);
        }
    }

    //убираем тип врага для волны генератора:
    public function removeEnemyFromGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeEnemyToGeneratorWave(positionId, generatorWaveData);
        }
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    public function editPointsToCurrentDefenderZone (points:Vector.<Point>):void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                currentEditingDefenderPosition
        ) {
            if (editDefenderZonesMode == EditMode.ADD_POINTS) {
                levelEditorController.addPointsToDefenderPosition (points, currentEditingDefenderPosition);
            }
            else if (editDefenderZonesMode == EditMode.REMOVE_POINTS) {
                levelEditorController.removePointsFromDefenderPosition (points, currentEditingDefenderPosition);
            }
        }
    }

    public function setCurrentDefenderZonePosition (point:Point):void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                (editDefenderZonesMode == EditMode.SET_POINT) &&
                currentEditingDefenderPosition
        ) {
            levelEditorController.setCurrentDefenderZonePosition (point, currentEditingDefenderPosition);
        }
    }

    public function addNewDefenderPosition ():void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS)
        ) {
            levelEditorController.addNewDefenderPosition();
        }
    }

    public function removeCurrentDefenderPosition ():void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                currentEditingDefenderPosition
        ) {
            levelEditorController.removeDefenderPosition(currentEditingDefenderPosition);
        }
    }

    public function clearAllDefenderZonesPoint ():void {
        if (currentEditingDefenderPosition) {
            levelEditorController.clearAllDefenderZonesPoint(currentEditingDefenderPosition);
        }
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    public function save ():void {
        levelEditorController.save();
    }

    public function export ():void {
        levelEditorController.export();
    }


}
}