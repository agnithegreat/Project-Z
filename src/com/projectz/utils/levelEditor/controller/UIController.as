/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 21.03.13
 * Time: 11:49
 * To change this template use File | Settings | File Templates.
 */

package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEditionModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetPartEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEditingModeEvent;
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
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEditingModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectCellEvent;
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
import com.projectz.utils.objectEditor.data.events.EditObjectDataEvent;
import com.projectz.utils.objectEditor.data.events.EditPartDataEvent;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Отправляется при выборе режима работы ui-конитроллера.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE
 */
[Event(name="select ui controller mode", type="com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent")]

/**
 * Отправляется при выборе объекта для редактирования (добавления не карту).
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent.SELECT_OBJECT
 */
[Event(name="select object", type="com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent")]

/**
 * Отправляется при выборе типа объектов для редактирования (добавления на карту).
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE
 */
[Event(name="select objects type", type="com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent")]

/**
* Отправляется при выборе бэкграунда.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent.SELECT_BACKGROUND
*/
[Event(name="select background", type="com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent")]

/**
 * Отправляется при выборе пути для редактирования.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent.SELECT_PATH
 */
[Event(name="select path", type="com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent")]

/**
 * Отправляется при выборе режима редактирования пути.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEditingModeEvent.SELECT_PATH_EDITING_MODE
 */
[Event(name="select path editing mode", type="com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEditingModeEvent")]

/**
 * Отправляется при выборе генератора для редактирования.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent.SELECT_GENERATOR
 */
[Event(name="select generator", type="com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent")]

/**
 * Отправляется при выборе зоны защитника для редактирования.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION
 */
[Event(name="select defender position", type="com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent")]

/**
 * Отправляется при выборе режима редактирования зон защитников.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEditingModeEvent.SELECT_DEFENDER_POSITION_EDITING_MODE
 */
[Event(name="select defender position editing mode", type="com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEditingModeEvent")]

/**
 * Отправляется при выборе ассета для редактирования.
 *
 * @eventType com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent.SELECT_ASSET
 */
[Event(name="select asset", type="com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent")]

/**
* Отправляется при выборе типа ассетов для редактирования.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent.SELECT_ASSETS_TYPE
*/
[Event(name="select assets type", type="com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent")]

/**
* Отправляется при выборе части ассета для редактирования.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetPartEvent.SELECT_ASSET_PART
*/
[Event(name="select asset part", type="com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetPartEvent")]

/**
* Отправляется при выборе режима редактирования ассетов.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEditionModeEvent.SELECT_ASSET_EDITING_MODE
*/
[Event(name="select asset editing mode", type="com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEditionModeEvent")]

/**
* Отправляется при выборе типа юнитов для редактирования.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitsTypeEvent.SELECT_UNITS_TYPE
*/
[Event(name="select units type", type="com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitsTypeEvent")]

/**
* Отправляется при выборе юнита для редактирования.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitEvent.SELECT_UNIT
*/
[Event(name="select unit", type="com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitEvent")]

/**
* Отправляется при выборе клетки поля. Используется для отображения информации о клетках.
*
* @eventType com.projectz.utils.levelEditor.controller.events.uiController.SelectCellEvent.SELECT_CELL
*/
[Event(name="select cell", type="com.projectz.utils.levelEditor.controller.events.uiController.SelectCellEvent")]

/**
* Отправляется при изменении данных текущего редактируемого юнита, если он является объектом EnemyData.
*
* @eventType com.projectz.utils.objectEditor.data.events.EditEnemyDataEvent.ENEMY_DATA_WAS_CHANGED
*/
[Event(name="enemy data was changed", type="com.projectz.utils.objectEditor.data.events.EditEnemyDataEvent")]

/**
* Отправляется при изменении данных текущего редактируемого юнита, если он является объектом DefenderData.
*
* @eventType com.projectz.utils.objectEditor.data.events.EditDefenderDataEvent.DEFENDER_DATA_WAS_CHANGED
*/
[Event(name="defender data was changed", type="com.projectz.utils.objectEditor.data.events.EditDefenderDataEvent")]

/**
* Отправляется при изменении данных текущей редактируемой части текущего ассета.
*
* @eventType com.projectz.utils.objectEditor.data.events.EditPartDataEvent.PART_DATA_WAS_CHANGED
*/
[Event(name="part data was changed", type="com.projectz.utils.objectEditor.data.events.EditPartDataEvent")]

/**
* Отправляется при изменении данных текущего редактируемого ассета.
*
* @eventType com.projectz.utils.objectEditor.data.events.EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED
*/
[Event(name="object data was changed", type="com.projectz.utils.objectEditor.data.events.EditObjectDataEvent")]

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
    private var _editPathMode:String = EditingMode.ADD_POINTS;//Режим работы ui-контролера при редактировании пути (удаление точек или добавление);
    private var _editPathAreaMode:Boolean;//Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании путей.

    //Редактирование генераторов:
    private var _currentEditingGenerator:GeneratorData;//Текущий редактируемый генератор

    //Редактирование зон защитников:
    private var _currentEditingDefenderPosition:DefenderPositionData;//Текущая редактируемая зона защитника
    private var _editDefenderPositionsMode:String = EditingMode.ADD_POINTS;//Режим работы ui-контролера при редактировании зон защитников (удаление точек или добавление);
    private var _editDefenderZonesAreaMode:Boolean;//Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при редактировании зон защитников.

    //Редактирование ассетов:
    private var _currentEditingAsset:ObjectData;//Текущий редактируемый ассет.
    private var _currentEditingAssetPart:PartData;//Текущая редактируемая часть ассета.
    private var _editAssetWalkableMode:Boolean = true;//Режим работы контроллера в котором происходит редактирование проходимости клеток у текущего выбранного ассета.
    private var _editAssetShotableMode:Boolean = false;//Режим работы контроллера в котором происходит редактирование простреливаемости клеток у текущего выбранного ассета.

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
        dispatchEvent(new SelectUIControllerModeEvent(_mode, SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE));
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
            dispatchEvent(new SelectObjectEvent(objectData, SelectObjectEvent.SELECT_OBJECT));
        }
    }

    /**
     * Выбор типа объектов для редактирования.
     * @param objectsType Тип объекта.
     * @see com.projectz.utils.objectEditor.data.ObjectType
     */
    public function selectCurrentEditingObjectType(objectsType:String):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            dispatchEvent(new SelectObjectsTypeEvent(objectsType, SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE));
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
        dispatchEvent(new SelectPathEvent(_currentEditingPath, SelectPathEvent.SELECT_PATH));
    }

    /**
     * Режим работы контролера при редактировании пути (удаление точек или добавление).
     *
     * @see com.projectz.utils.levelEditor.controller.EditingMode
     */
    public function get editPathMode():String {
        return _editPathMode;
    }

    public function set editPathMode(value:String):void {
        _editPathMode = value;
        dispatchEvent(new SelectPathEditingModeEvent(_editPathMode, SelectPathEditingModeEvent.SELECT_PATH_EDITING_MODE));
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
        dispatchEvent(new SelectGeneratorEvent(_currentEditingGenerator, SelectGeneratorEvent.SELECT_GENERATOR));
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
        dispatchEvent(new SelectDefenderPositionEvent(_currentEditingDefenderPosition, SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION));
    }

    /**
     * Режим работы контролера при редактировании зон защитников (удаление точек или добавление).
     *
     * @see com.projectz.utils.levelEditor.controller.EditingMode
     */
    public function get editDefenderPositionsMode():String {
        return _editDefenderPositionsMode;
    }

    public function set editDefenderPositionsMode(value:String):void {
        _editDefenderPositionsMode = value;
        dispatchEvent(new SelectDefenderPositionEditingModeEvent(_editDefenderPositionsMode, SelectDefenderPositionEditingModeEvent.SELECT_DEFENDER_POSITION_EDITING_MODE));
    }

    /**
     * Значение, которое определяет, включен ли режим редактирования областей по двум точкам или нет при зон защитников.
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
            dispatchEvent(new SelectAssetsTypeEvent(objectsType, SelectAssetsTypeEvent.SELECT_ASSETS_TYPE));
        }
    }

    /**
     * Текущий редактируемый ассет.
     */
    public function get currentEditingAsset():ObjectData {
        return _currentEditingAsset;
    }

    public function set currentEditingAsset(objectData:ObjectData):void {
        currentEditingAssetPart = null;
        if (_currentEditingAsset) {
            _currentEditingAsset.removeEventListener(EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED, objectDataWasChangedListener);
        }
        _currentEditingAsset = objectData;
        if (_currentEditingAsset) {
            _currentEditingAsset.addEventListener(EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED, objectDataWasChangedListener);
        }
        dispatchEvent(new SelectAssetEvent(objectData, SelectAssetEvent.SELECT_ASSET));
    }

    /**
     * Текущая редактируемая часть ассета.
     */
    public function get currentEditingAssetPart():PartData {
        return _currentEditingAssetPart;
    }

    public function set currentEditingAssetPart(partData:PartData):void {
        if (_currentEditingAssetPart) {
            _currentEditingAssetPart.removeEventListener(EditPartDataEvent.PART_DATA_WAS_CHANGED, partDataWasChangedListener);
        }
        _currentEditingAssetPart = partData;
        if (_currentEditingAssetPart) {
            _currentEditingAssetPart.addEventListener(EditPartDataEvent.PART_DATA_WAS_CHANGED, partDataWasChangedListener);
        }
        dispatchEvent(new SelectAssetPartEvent(partData, SelectAssetPartEvent.SELECT_ASSET_PART));
    }

    /**
     * Значение, которое определяет, включен ли режим редактирования проходимости клеток у текущего выбранного ассета.
     */
    public function get editAssetWalkableMode():Boolean {
        return _editAssetWalkableMode;
    }

    public function set editAssetWalkableMode(value:Boolean):void {
        _editAssetWalkableMode = value;
        dispatchEvent(new SelectAssetEditionModeEvent(SelectAssetEditionModeEvent.SELECT_ASSET_EDITING_MODE));
    }

    /**
     * Значение, которое определяет, включен ли режим редактирования простреливаемости клеток у текущего выбранного ассета.
     */
    public function get editAssetShotableMode():Boolean {
        return _editAssetShotableMode;
    }

    public function set editAssetShotableMode(value:Boolean):void {
        _editAssetShotableMode = value;
        dispatchEvent(new SelectAssetEditionModeEvent(SelectAssetEditionModeEvent.SELECT_ASSET_EDITING_MODE));
    }

    /**
     * Смещение текущей редактируемой части ассета (если она не равна <code>null</code>)
     * или всех частей текущего редактируемого ассета на указанное значение.
     * @param toX Смещение по оси x.
     * @param toY Смещение по оси y.
     */
    public function moveAsset (toX:int, toY:int):void {
        if (currentEditingAssetPart) {
            var partData:PartData = currentEditingAssetPart;
            partData.place(partData.pivotX + toX, partData.pivotY + toY);
        }
        else if (currentEditingAsset) {
            currentEditingAsset.moveParts(toX, toY);
        }
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
            dispatchEvent(new SelectUnitsTypeEvent(objectsType, SelectUnitsTypeEvent.SELECT_UNITS_TYPE));
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
        dispatchEvent(new SelectUnitEvent(objectData, SelectUnitEvent.SELECT_UNIT));
    }

    /////////////////////////////////////////////
    //INFO:
    /////////////////////////////////////////////

    /**
     * Вывод информации о клетке поля.
     */
    public function showCellInfo($cell:Cell):void {
        dispatchEvent(new SelectCellEvent($cell, SelectCellEvent.SELECT_CELL));
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
            dispatchEvent(new SelectBackgroundEvent(objectData, SelectBackgroundEvent.SELECT_BACKGROUND));
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
    public function selectAndRemoveObject ($x: int, $y: int):void {
        if (mode == UIControllerMode.EDIT_OBJECTS) {
            levelEditorController.selectAndRemoveObject($x,  $y);
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
            if (editPathMode == EditingMode.ADD_POINTS) {
                levelEditorController.addPointsToPath (points, currentEditingPath);
            }
            else if (editPathMode == EditingMode.REMOVE_POINTS) {
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
            if (editDefenderPositionsMode == EditingMode.ADD_POINTS) {
                levelEditorController.addPointsToDefenderPosition (points, currentEditingDefenderPosition);
            }
            else if (editDefenderPositionsMode == EditingMode.REMOVE_POINTS) {
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
                (editDefenderPositionsMode == EditingMode.SET_POINT) &&
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
        if (mode == UIControllerMode.EDIT_ASSETS) {
            if (currentEditingAsset) {
                currentEditingAsset.saveFile();
            }
        }
        else if (mode == UIControllerMode.EDIT_UNITS) {
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
        dispatchEvent(new EditEnemyDataEvent(enemyData, EditEnemyDataEvent.ENEMY_DATA_WAS_CHANGED));
    }

    /**
     * Слушатель события изменения текущего редактируемого юнита, как объекта DefenderData.
     *
     * @see com.projectz.utils.objectEditor.data.DefenderData
     */
    private function defenderDataWasChangedListener (event:EditDefenderDataEvent):void {
        var defenderData:DefenderData = event.defenderData;
        dispatchEvent(new EditDefenderDataEvent(defenderData, EditDefenderDataEvent.DEFENDER_DATA_WAS_CHANGED));
    }

    /**
     * Слушатель события изменения текущего редактируемого ассета.
     *
     * @see com.projectz.utils.objectEditor.data.ObjectData
     */
    private function objectDataWasChangedListener (event:EditObjectDataEvent):void {
        var objectData:ObjectData = event.objectData;
        dispatchEvent(new EditObjectDataEvent(objectData, EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED));
    }

    /**
     * Слушатель события изменения текущей редактируемой части текущего редактируемого ассета.
     *
     * @see com.projectz.utils.objectEditor.data.ObjectData
     */
    private function partDataWasChangedListener (event:EditPartDataEvent):void {
        var partData:PartData = event.partData;
        dispatchEvent(new EditPartDataEvent(partData, EditPartDataEvent.PART_DATA_WAS_CHANGED));
    }

}
}