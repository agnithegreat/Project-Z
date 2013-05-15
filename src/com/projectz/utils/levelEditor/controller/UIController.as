/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 11:49
 * To change this template use File | Settings | File Templates.
 */

package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectEditDefenderPositionModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitsTypeEvent;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.LevelData;
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
import com.projectz.utils.objectEditor.data.DefenderData;
import com.projectz.utils.objectEditor.data.EnemyData;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.objectEditor.data.events.EditDefenderDataEvent;
import com.projectz.utils.objectEditor.data.events.EditEnemyDataEvent;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный для взаимодействия ui (панели) и view (отображение игрового поля).
 * Возможна работа с нескольким ui.
 * <p><img src="../../../../../images/MVC_and_Cui.png"/></p>
 * <p>Сохраняет состояние режима работы (редактор объектов, редактор путей и т.д.).</p>
 * <p>Хранит данные о текущих выбранных для редактирования объектах (текущий редактируемый путь, текущий редактируемый ассет и т.д.).</p>
 * <p>Также реализует функционал классического контролера через композицию (ссылка на контролер редактора (классический mvc контроллер)).
 * Иногда сам выступает в качестве классического mvc контролера.
 * Например, при редактировании ассетов или юнитов является прослойкой между текущими редактируемыми данными (model) и ui (view).
 * Контроллер отлавливает события изменения текущих редактируемых данных и диспатчит события для ui.</p>
 */
public class UIController extends EventDispatcher {

    private var levelEditorController:LevelEditorController;//Классический mvc контроллер.

    private var _mode:String;//Режим работы ui-контролера (редактор объектов, редактор путей и т.д.);

    //Редактирование путей:
    private var _currentEditingPath:PathData;//Текущий редактируемый путь
    private var _editPathMode:String = EditMode.ADD_POINTS;//Режим работы ui-контролера при редактировании пути (удаление точек или добавление);
    private var _editPathAreaMode:Boolean;//Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании путей.

    //Редактирование генераторов:
    private var _currentEditingGenerator:GeneratorData;//Текущий редактируемый генератор

    //Редактирование зон защитников:
    private var _currentEditingDefenderPosition:DefenderPositionData;//Текущая редактируемая зона защитника
    private var _editDefenderPositionsMode:String = EditMode.ADD_POINTS;//Режим работы ui-контролера при редактировании зон защитников (удаление точек или добавление);
    private var _editDefenderZonesAreaMode:Boolean;//Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании зон защитников.

    //Редактирование ассетов:
    private var _currentEditingAsset:ObjectData;//Текущий редактируемый ассет.
    private var _currentEditingAssetPart:PartData;//Текущая редактируемая часть ассета.

    //Редактирование юнитов:
    private var _currentEditingUnit:ObjectData;//Текущий редактируемый юнит.

    /**
     * @param levelEditorController Ссылка на классический mvc контроллер.
     */
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
    //OBJECTS:
    /////////////////////////////////////////////

    /**
     * Выбор объекта для редактирования.
     * @param objectData Выбранный объект.
     * @see com.projectz.utils.objectEditor.data.ObjectData
     */
    public function selectCurrentEditingObject(objectData:ObjectData):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectEvent(objectData));
        }
    }

    /**
     * Выбор типа объектов для редактирования.
     * @param objectsType Тип объекта.
     * @see com.projectz.utils.objectEditor.data.ObjectType
     */
    public function selectCurrentEditingObjectType(objectsType:String):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectsTypeEvent(objectsType));
        }
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
    //GENERATORS:
    /////////////////////////////////////////////

    /**
     * Текущий редактируемый генератор.
     */
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
     * Текущая редактируемая зона защитника.
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
    public function get editDefenderPositionsMode():String {
        return _editDefenderPositionsMode;
    }

    public function set editDefenderPositionsMode(value:String):void {
        _editDefenderPositionsMode = value;
        dispatchEvent(new SelectEditDefenderPositionModeEvent(_editDefenderPositionsMode));
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
    //ASSETS:
    /////////////////////////////////////////////

    /**
     * Выбор типа ассетов для редактирования.
     * @param objectsType Тип объекта.
     */
    public function selectCurrentEditingAssetType(objectsType:String):void {
        if (mode == UIControllerMode.EDIT_ASSETS) {
            dispatchEvent(new SelectAssetsTypeEvent(objectsType));
        }
    }

    /**
     * Текущий редактируемый ассет.
     */
    public function get currentEditingAsset():ObjectData {
        return _currentEditingAsset;
    }

    public function set currentEditingAsset(objectData:ObjectData):void {
        _currentEditingAsset = objectData;
        dispatchEvent(new SelectAssetEvent(objectData));
    }

    /**
     * Текущая редактируемая часть ассета.
     */
    public function get currentEditingAssetPart():PartData {
        return _currentEditingAssetPart;
    }

    public function set currentEditingAssetPart(partData:PartData):void {
        _currentEditingAssetPart = partData;
    }

    /////////////////////////////////////////////
    //UNITS:
    /////////////////////////////////////////////

    /**
     * Выбор типа юнитов для редактирования.
     * @param objectsType Тип объекта.
     */
    public function selectCurrentEditingUnitType(objectsType:String):void {
        if (mode == UIControllerMode.EDIT_UNITS) {
            dispatchEvent(new SelectUnitsTypeEvent(objectsType));
        }
    }

    /**
     * Текущий редактируемый юнит.
     */
    public function get currentEditingUnit():ObjectData {
        return _currentEditingUnit;

    }

    public function set currentEditingUnit(objectData:ObjectData):void {
        if (_currentEditingUnit) {
            _currentEditingUnit.removeEventListener(EditEnemyDataEvent.ENEMY_DATA_WAS_CHANGED, enemyDataWasChangedListener);
            _currentEditingUnit.removeEventListener(EditDefenderDataEvent.DEFENDER_DATA_WAS_CHANGED, defenderDataWasChangedListener);
        }
        _currentEditingUnit = objectData;
        if (_currentEditingUnit) {
            _currentEditingUnit.addEventListener(EditEnemyDataEvent.ENEMY_DATA_WAS_CHANGED, enemyDataWasChangedListener);
            _currentEditingUnit.addEventListener(EditDefenderDataEvent.DEFENDER_DATA_WAS_CHANGED, defenderDataWasChangedListener);
        }
        dispatchEvent(new SelectUnitEvent(objectData));
    }

    /////////////////////////////////////////////
    //INFO:
    /////////////////////////////////////////////

    /**
     * Вывод информации о клетке поля.
     */
    public function showCellInfo($cell:Cell):void {
        dispatchEvent(new ShowCellInfoEvent($cell));
    }

/////////////////////////////////////////////
//LEVEL EDITOR CONTROLLER:
//Методы классического mvc контроллера (выполняются соответствующие функции в переменной levelEditorController)
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    /**
     * Установка фонововой картинки для уровня.
     * @param objectData Объект, сождержащий фоновую картинку.
     */
    public function selectLevelBackground(objectData:ObjectData):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectBackgroundEvent(objectData));
            levelEditorController.changeBackground(objectData);
        }
    }

    /**
     * Добавление объекта на карту.
     * @param placeData Объект.
     * @return Возращает <code>true</code>, если объект удалось добавить.
     */
    public function addObject (placeData:PlaceData):Boolean {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            return levelEditorController.addObject(placeData);
        }
        return false;
    }

    /**
     * Поиск объекта в указанной позиции. При нахождении происходит удаление объекта и выбор его текущим выбранным объектом на карте.
     * @param $x
     * @param $y
     */
    public function selectObject ($x: int, $y: int):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.selectObject($x,  $y);
        }
    }

    /**
     * Удаление всех объектов на карте.
     */
    public function removeAllObject():void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.removeAllObject();
        }
    }

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    /**
     * Редактирование точек текущего выбранного пути (currentEditingPath).
     * Способ редактирования (добавление, удаление) зависит от режима ui контроллера (editPathMode).
     * @param points Редактируемые точки
     *
     * @see #editPathMode
     * @see #currentEditingPath
     */
    public function editPointToCurrentPath (points:Vector.<Point>):void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            if (editPathMode == EditMode.ADD_POINTS) {
                levelEditorController.addPointsToPath (points, currentEditingPath);
            }
            else if (editPathMode == EditMode.REMOVE_POINTS) {
                levelEditorController.removePointsFromPath (points, currentEditingPath);
            }
        }
    }

    /**
     * Выбор цвета для текущего редактируемого пути (currentEditingPath).
     * @param color Цвет.
     *
     * @see #currentEditingPath
     */
    public function setPathColor (color:uint):void {
        if (
                (mode == UIControllerMode.EDIT_PATHS) &&
                currentEditingPath
        ) {
            levelEditorController.setPathColor (color, currentEditingPath);
        }
    }

    /**
     * Добавление нового пути.
     */
    public function addNewPath ():void {
        if (mode == UIControllerMode.EDIT_PATHS) {
            levelEditorController.addNewPath ();
        }
    }

    /**
     * Удаление текущего редактируемого пути (currentEditingPath).
     *
     * @see #currentEditingPath
     */
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

    /**
     * Добавление нового генератора.
     */
    public function addNewGenerator ():void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addNewGenerator();
        }
    }

    /**
     * Удаление генератора.
     * @param generatorData Генератор.
     */
    public function removeGenerator (generatorData:GeneratorData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeGenerator(generatorData);
        }
    }

    /**
     * Установка пути для текущего редактируемого генератора (currentEditingGenerator).
     * @param pathId
     *
     * @see #currentEditingGenerator
     */
    public function setGeneratorPath (pathId:int):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            if (_currentEditingGenerator) {
                levelEditorController.setGeneratorPath(pathId, currentEditingGenerator);
            }
        }
    }

    /**
     * Установка позиции для текущего редактируемого генератора (currentEditingGenerator).
     * @param point
     *
     * @see #currentEditingGenerator
     */
    public function setGeneratorPosition (point:Point):void {
        if (mode == UIControllerMode.EDIT_GENERATORS && currentEditingGenerator) {
            levelEditorController.setGeneratorPosition(point, currentEditingGenerator);
        }
    }

    /////////////////////////////////////////////
    //WAVES:
    /////////////////////////////////////////////

    /**
     * Добавление новой волны.
     */
    public function addNewWave():void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addNewWave();
        }
    }

    /**
     * Удаление волны.
     * @param waveId Id'шник волны для удаления.
     */
    public function removeWave(waveId:int):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeWave(waveId);
        }
    }

    /**
     * Устанавка времяни для волны. Время устанавливается для всех генераторов в волне.
     * @param time Время
     * @param waveData Волна
     */
    public function setWaveTime (time:int, waveData:WaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.setWaveTime(time, waveData);
        }
    }

    /**
     * Устанавка задержки для волны генератора.
     * @param delay
     * @param generatorWaveData Волна генератора.
     */
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.setDelayOfGeneratorWave(delay, generatorWaveData);
        }
    }

    /**
     * Добавляем врага для стека волны генератора.
     * @param enemyId Id'шник врага.
     * @param positionId Позиция в списке врагов (влияет на очередность появления врагов).
     * @param count Количество добавляемых врагов с таким именем.
     * @param generatorWaveData Волна генератора.
     */
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, count:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.addEnemyToGeneratorWave(enemyId, positionId, count, generatorWaveData);
        }
    }

    /**
     * Убираем врага из стека волны генератора.
     * @param positionId Позиция в списке врагов (влияет на очередность появления врагов).
     * @param generatorWaveData Волна генератора.
     */
    public function removeEnemyFromGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (mode == UIControllerMode.EDIT_GENERATORS) {
            levelEditorController.removeEnemyToGeneratorWave(positionId, generatorWaveData);
        }
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    /**
     * Добавление новой зоны защитников.
     */
    public function addNewDefenderPosition ():void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS)
        ) {
            levelEditorController.addNewDefenderPosition();
        }
    }

    /**
     * Удаление текущей редактируемой зоны защитников (currentEditingDefenderPosition).
     *
     * @see #currentEditingDefenderPosition
     */
    public function removeCurrentDefenderPosition ():void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                currentEditingDefenderPosition
        ) {
            levelEditorController.removeDefenderPosition(currentEditingDefenderPosition);
        }
    }

    /**
     * Редактирование точек в текущей редактируемой зоне защитников.
     * Способ редактирования (добавление, удаление) зависит от режима ui контроллера (editDefenderPositionsMode).
     * @param points Редактируемые точки.
     *
     * @see #editDefenderPositionsMode
     */
    public function editPointsToCurrentDefenderPosition (points:Vector.<Point>):void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                currentEditingDefenderPosition
        ) {
            if (editDefenderPositionsMode == EditMode.ADD_POINTS) {
                levelEditorController.addPointsToDefenderPosition (points, currentEditingDefenderPosition);
            }
            else if (editDefenderPositionsMode == EditMode.REMOVE_POINTS) {
                levelEditorController.removePointsFromDefenderPosition (points, currentEditingDefenderPosition);
            }
        }
    }

    /**
     * Установка позиции текущей редактируемой зоны защитников (editDefenderPositionsMode).
     *
     * @param point Точка установки.
     *
     * @see #editDefenderPositionsMode
     */
    public function setPositionOfCurrentDefenderPosition (point:Point):void {
        if (
                (mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) &&
                (editDefenderPositionsMode == EditMode.SET_POINT) &&
                currentEditingDefenderPosition
        ) {
            levelEditorController.setPositionOfDefenderPosition (point, currentEditingDefenderPosition);
        }
    }

    /**
     * Удаление всех точек текущей редактируемой зоны защитников.
     *
     * @see #editDefenderPositionsMode
     */
    public function clearAllPointsFromCurrentDefenderPosition ():void {
        if (currentEditingDefenderPosition) {
            levelEditorController.clearAllPointsFromDefenderPosition(currentEditingDefenderPosition);
        }
    }

    /////////////////////////////////////////////
    //ASSETS:
    /////////////////////////////////////////////

    /////////////////////////////////////////////
    //LEVELS:
    /////////////////////////////////////////////

    /**
     * Выбор текущего уровня.
     * @param levelData Уровень.
     */
    public function setCurrentLevel (levelData:LevelData):void {
        levelEditorController.setCurrentLevel(levelData);
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    /**
     * Сохранение файла с настройками уровня.
     */
    public function save ():void {
        if (mode == UIControllerMode.EDIT_UNITS) {
            if (currentEditingUnit) {
                currentEditingUnit.saveFile();
            }
        }
        else {
            levelEditorController.save();
        }
    }

    /**
     * @private
     */
    public function export ():void {
        levelEditorController.export();
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    /**
     * Слушатель события изменения текущего редактируемого юнита, как объекта EnemyData.
     *
     * @see com.projectz.utils.objectEditor.data.EnemyData
     */
    private function enemyDataWasChangedListener (event:EditEnemyDataEvent):void {
        var enemyData:EnemyData = event.enemyData;
        dispatchEvent(new EditEnemyDataEvent(enemyData));
    }

    /**
     * Слушатель события изменения текущего редактируемого юнита, как объекта DefenderData.
     *
     * @see com.projectz.utils.objectEditor.data.DefenderData
     */
    private function defenderDataWasChangedListener (event:EditDefenderDataEvent):void {
        var defenderData:DefenderData = event.defenderData;
        dispatchEvent(new EditDefenderDataEvent(defenderData));
    }

}
}