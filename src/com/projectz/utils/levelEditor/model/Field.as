/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {

import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.DataUtils;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent;
import com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditBackgroundEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditPlaceEvent;
import com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.levelEditor.data.PlaceData;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Отправляется при выборе текущего уровня.
 *
 * @eventType com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent.SET_LEVEL
 */
[Event(name="set level", type="com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent")]

/**
 * Отправляется при обновлении игры.
 *
 * @eventType com.projectz.game.event.GameEvent.UPDATE
 */
[Event(name="update_GameEvent", type="starling.events.Event")]

/**
 * Отправляется при изменении места на поле. Был выбран и удалён объект на карте.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editObjects.EditPlaceEvent.PLACE_WAS_CHANGED
 */
[Event(name="place was changed", type="com.projectz.utils.levelEditor.model.events.editObjects.EditPlaceEvent")]

/**
 * Отправляется при изменении бэкграунда.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editObjects.EditBackgroundEvent.BACKGROUND_WAS_CHANGED
 */
[Event(name="background was changed", type="com.projectz.utils.levelEditor.model.events.editObjects.EditBackgroundEvent")]

/**
 * Отправляется при части объекта.
 *
 * @eventType com.projectz.utils.objectEditor.data.events.EditPartDataEvent.PART_DATA_WAS_CHANGED
 */
[Event(name="part data was changed", type="com.projectz.utils.objectEditor.data.events.EditPartDataEvent")]

/**
 * Отправляется при добавлении пути.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent.PATH_WAS_ADDED
 */
[Event(name="path was added", type="com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent")]

/**
 * Отправляется при изменении пути.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent.PATH_WAS_CHANGED
 */
[Event(name="path was changed", type="com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent")]

/**
 * Отправляется при изменении цвета пути.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent.PATH_COLOR_WAS_CHANGED
 */
[Event(name="path color was changed", type="com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent")]

/**
 * Отправляется при удалении пути.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent.PATH_WAS_REMOVED
 */
[Event(name="path was removed", type="com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent")]

/**
 * Отправляется при добавлении генератора.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent.GENERATOR_WAS_ADDED
 */
[Event(name="generator was added", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent")]

/**
 * Отправляется при изменении генератора.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent.GENERATOR_WAS_CHANGED
 */
[Event(name="generator was changed", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent")]

/**
 * Отправляется при удалении генератора.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent.GENERATOR_WAS_REMOVED
 */
[Event(name="generator was removed", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent")]

/**
 * Отправляется при добавлении волны.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent.WAVE_WAS_ADDED
 */
[Event(name="wave was added", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent")]

/**
 * Отправляется при изменении волны.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent.WAVE_WAS_CHANGED
 */
[Event(name="wave was changed", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent")]

/**
 * Отправляется при удалении волны.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent.WAVE_WAS_REMOVED
 */
[Event(name="wave was removed", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent")]

/**
 * Отправляется при изменении волны генератора.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED
 */
[Event(name="generator wave was changed", type="com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent")]

/**
 * Отправляется при добавлении зоны защитников.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent.DEFENDER_POSITION_WAS_ADDED
 */
[Event(name="defender position was added", type="com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent")]

/**
 * Отправляется при изменении зоны защитников.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED
 */
[Event(name="defender position was changed", type="com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent")]

/**
 * Отправляется при удалении зоны защитников.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent.DEFENDER_POSITION_WAS_REMOVED
 */
[Event(name="defender position was removed", type="com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent")]

/**
 * Отправляется при добавлении части объекта на поле.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent.FIELD_OBJECT_WAS_ADDED
 */
[Event(name="defender position was added", type="com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent")]

/**
 * Отправляется при удалении части объекта с поля.
 *
 * @eventType com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent.FIELD_OBJECT_WAS_REMOVED
 */
[Event(name="defender position was removed", type="com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent")]

public class Field extends EventDispatcher {

    private var _width: int;
    private var _height: int;

    private var _objectsStorage: ObjectsStorage;

    private var _fieldAsObj: Object;//представление поля клеток Cell в виде объекта. Ключом для получения служит строка с координатами клетки вида x_y
    private var _field: Vector.<Cell>;

    private var _levelData: LevelData;

    private var _objects: Vector.<FieldObject>;

    public function Field($width: int, $height: int, $objectsStorage: ObjectsStorage) {
        _width = $width;
        _height = $height;

        _objectsStorage = $objectsStorage;
        _objects = new <FieldObject>[];

        createField();

    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //GET & SET:
    /////////////////////////////////////////////

    /**
     * Ширина поля (в клетках).
     */
    public function get width():int {
        return _width;
    }

    /**
     * Высота поля (в клетках).
     */
    public function get height():int {
        return _height;
    }

    public function set levelData(levelData:LevelData):void {
        _levelData = levelData;
        if (_levelData) {
            dispatchEvent(new EditLevelsEvent (levelData, EditLevelsEvent.SET_LEVEL));
            createObjects(_levelData.objects);
            changeBackground(_levelData.bg);
        }
    }

    /**
     * Текущий уровень.
     */
    public function get levelData():LevelData {
        return _levelData;
    }

    /**
     * Объекты на карте в виде массива частей объектов.
     */
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    /**
     * Поле клеток.
     */
    public function get field():Vector.<Cell> {
        return _field;
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    /**
     * Добавление объекта.
     * @param $placeData Объект для добавления.
     * @return Возвращает <code>true</code>, если объект был успешно добавлен.
     */
    public function addObject($placeData: PlaceData):Boolean {
        if (!checkObject($placeData.x, $placeData.y, $placeData.realObject)) {
            return false;
        }
        if (_levelData) {
            _levelData.addObject($placeData);
            createObject($placeData.x, $placeData.y, $placeData.realObject, $placeData);
            updateDepths();
            dispatchEventWith(GameEvent.UPDATE);
        }
        return true;
    }

    /**
     * Поиск объекта в указанной позиции.
     * Если объект найден, то он удаляется и диспатчся событие с этим объектом для его дальнейшего редактирования.
     *
     * @param $x Координата x на карте для поиска объекта.
     * @param $y Координата y на карте для поиска объекта.
     */
    public function selectAndRemoveObject($x: int,  $y: int):void {
        if (_levelData) {
            var object: PlaceData;

            var len: int = _levelData.objects.length;
            for (var i:int = 0; i < len; i++) {
                object = _levelData.objects[i];
                if (object.hitTest($x, $y)) {
                    break;
                } else {
                    object = null;
                }
            }

            if (object) {
                removeObject(object);
                dispatchEvent(new EditPlaceEvent (_objectsStorage.getObjectData(object.object), EditPlaceEvent.PLACE_WAS_CHANGED));
            }
        }
    }

    /**
     * Узменение бэкграунда.
     * @param backgroundId Бэкграунд.
     */
    public function changeBackground (backgroundId:String):void {
        if (_levelData) {
            _levelData.bg = backgroundId;
            if (backgroundId) {
                var objectData:ObjectData = _objectsStorage.getObjectData (backgroundId);
                dispatchEvent(new EditBackgroundEvent(objectData, EditBackgroundEvent.BACKGROUND_WAS_CHANGED));
            }
        }
    }

    /**
     * Удаление всех объектов в текущем уровне.
     */
    public function removeAllObject():void {
        if (_levelData) {
            var placeData: PlaceData;
            var len: int = _levelData.objects.length;
            while (_levelData.objects.length > 0) {
                placeData = _levelData.objects[0];
                removeObject(placeData);
            }
        }
    }

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    /**
     * Добавление точек в путь.
     * @param points Массив точек.
     * @param pathData Путь.
     */
    public function addPointsToPath (points:Vector.<Point>, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                for (var i:int = 0; i < points.length; i++) {
                    var point:Point = points [i];
                    var pointAsString:String = DataUtils.pointToStringData(point);
                    if (pathData.points.indexOf(pointAsString) == -1) {
                        pathData.points.push(pointAsString);
                    }
                }
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_CHANGED));
            }
        }
    }

    /**
     * Удаление точек из пути.
     * @param points Массив точек.
     * @param pathData Путь.
     */
    public function removePointsFromPath (points:Vector.<Point>, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                for (var i:int = 0; i < points.length; i++) {
                    var point:Point = points [i];
                    var pointAsString:String = DataUtils.pointToStringData(point);
                    var pointIndex:int = pathData.points.indexOf(pointAsString);
                    if (pointIndex != -1) {
                        pathData.points.splice(pointIndex, 1);
                    }
                }
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_CHANGED));
            }
        }
    }

    /**
     * Установка цвета пути.
     * @param color Цвент пути.
     * @param pathData Путь.
     */
    public function setPathColor (color:uint, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                pathData.color = color;
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_COLOR_WAS_CHANGED));
            }
        }
    }

    /**
     * Добавление пути в текущем уровне.
     */
    public function addNewPath ():void {
        if (_levelData) {
            var pathData:PathData = _levelData.addNewPath ();
            dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_ADDED));
        }
    }

    /**
     * Удаление пути в текущем уровне.
     * @param pathData Удаляемый путь.
     */
    public function deletePath (pathData:PathData):void {
        if (_levelData) {
            if (_levelData.deletePath (pathData)) {
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_REMOVED));
            }
        }
    }

    /////////////////////////////////////////////
    //GENERATORS & WAVES:
    /////////////////////////////////////////////

    /**
     * Добавление нового генерата в текущем уровне.
     */
    public function addNewGenerator ():void {
        if (_levelData) {
            var generatorData:GeneratorData = _levelData.addNewGenerator ();
            var numWaves:int = _levelData.waves.length;
            for (var i:int = 0; i < numWaves; i++) {
                var generatorWaveData:GeneratorWaveData = new GeneratorWaveData();
                var waveData:WaveData = _levelData.waves [i];
                generatorWaveData.id = waveData.id;
                generatorData.waves.push (generatorWaveData);
            }
            dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_ADDED));
        }
    }

    /**
     * Удаление генератора в текущем уровне.
     * @param generatorData Удаляемый генератор.
     */
    public function removeGenerator (generatorData:GeneratorData):void {
        if (_levelData) {
            if (_levelData.removeGenerator(generatorData)) {
                dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_REMOVED));
            }
        }
    }

    /**
     * Установка пути для генератора.
     * @param pathId Id'шник пути.
     * @param generatorData Генератор.
     */
    public function setGeneratorPath (pathId:int, generatorData:GeneratorData):void {
        if (_levelData) {
            var index:int = _levelData.generators.indexOf (generatorData);
            if (index != -1) {
                //проверяем, существует ли путь с таким id:
                var numPaths:int = _levelData.paths.length;
                for (var i:int = 0; i < numPaths; i++) {
                    var pathData:PathData = _levelData.paths [i];
                    if (pathData.id == pathId) {
                        generatorData.pathId = pathId;
                        if (pathData.points.length > 0) {
                            var point:Point = DataUtils.stringDataToPoint(pathData.points [0]);
                            generatorData.place (point.x, point.y);
                        }
                        dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                        break;
                    }
                }
            }
        }
    }

    /**
     * Установка позиции генератора.
     * @param point Позиция генератора.
     * @param generatorData Генератор.
     */
    public function setGeneratorPosition (point:Point, generatorData:GeneratorData):void {
        if (_levelData) {
            var index:int = _levelData.generators.indexOf (generatorData);
            if (index != -1) {
                //находим текущий путь по id:
                var numPaths:int = _levelData.paths.length;
                for (var i:int = 0; i < numPaths; i++) {
                    var pathData:PathData = _levelData.paths [i];
                    if (pathData.id == generatorData.pathId) {
                        //проверяем, существует ли в текущем пути указаная точка:
                        var numPoints:int = pathData.points.length;
                        for (var j:int = 0; j < numPoints; j++) {
                            var pathPoint:Point = DataUtils.stringDataToPoint(pathData.points [j]);
                            if (pathPoint.equals (point)) {
                                generatorData.place(point.x, point.y);
                                dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                                break;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    /**
     * Добавление новой волны в текущем уровне.
     */
    public function addNewWave():void {
        if (_levelData) {
            var waveData:WaveData = _levelData.addNewWave ();
            dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_ADDED));
        }
    }

    /**
     * Удаление волны в текущем уровне.
     * @param waveId Id'шник волны.
     */
    public function removeWave(waveId:int):void {
        if (_levelData) {
            var waveData:WaveData = _levelData.getWaveDataById(waveId);
            if (_levelData.removeWave (waveId)) {
                dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_REMOVED));
                trace ("удаляем волну " + waveId);
            }
            else {
                trace ("не можем удалить волну " + waveId);
            }
        }
    }

    /**
     * Установка времени для волны в текущем уровне.
    */
    public function setWaveTime (time:int, waveData:WaveData):void {
        if (_levelData) {
            var index:int = _levelData.waves.indexOf (waveData);
            if (index != -1) {
                waveData.time = time;
                dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_CHANGED));
            }
        }
    }

    /**
     * Установка задержки для волны генератора в текущем уровне.
     */
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData) {
            var numGenerators:int = _levelData.generators.length;
            for (var i:int = 0; i < numGenerators; i++) {
                var generatorData:GeneratorData = _levelData.generators [i];
                var index:int = generatorData.waves.indexOf (generatorWaveData);
                if (index != -1) {
                    generatorWaveData.delay = delay;
                    dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED));
                    dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                    break;
                }
            }
        }
    }

    /**
     * Добавление врага в стек волны генератора.
     */
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, count:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData && hasGeneratorWaveData (generatorWaveData)) {
            if (generatorWaveData.sequence.length >= positionId) {
                for (var i:int = 0; i < count; i++) {
                    generatorWaveData.sequence.splice(positionId, 0, enemyId);
                }
                dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED));
            }
        }
    }

    /**
     * Удаление врага из стека волны генератора.
     */
    public function removeEnemyToGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData && hasGeneratorWaveData (generatorWaveData)) {
            if (generatorWaveData.sequence.length > positionId) {
                generatorWaveData.sequence.splice(positionId, 1);
                dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED))
            }
        }
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    /**
     * Добавление новой зоны защитников.
     */
    public function addNewDefenderPosition ():void {
        if (_levelData) {
            var newDefenderPositionData:DefenderPositionData = new DefenderPositionData();
            var middleCell:Cell = _field[Math.round(_field.length / 2)];
            newDefenderPositionData.place(middleCell.x, middleCell.y);
            _levelData.defenderPositions.push(newDefenderPositionData);
            dispatchEvent(new EditDefenderPositionEvent (newDefenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_ADDED));
        }
    }

    /**
     * Удаление зоны защитников.
     * @param defenderPositionData Зона защтников.
     */
    public function removeDefenderPosition (defenderPositionData:DefenderPositionData):void {
        if (_levelData) {
            var positionIndex:int = _levelData.defenderPositions.indexOf(defenderPositionData);
            if (positionIndex != -1) {
                _levelData.defenderPositions.splice(positionIndex, 1);
                dispatchEvent(new EditDefenderPositionEvent (defenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_REMOVED));
            }
        }
    }

    /**
     * Добавление точек в зону защитников.
     * @param points Удаляемые точки.
     * @param defenderPositionData Зона защтников.
     */
    public function addPointsToDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        if (_levelData) {
            if (_levelData.defenderPositions.indexOf(defenderPositionData) != -1) {
                var numPoints:int = points.length;
                for (var i:int = 0; i < numPoints; i++) {
                    var point:Point = points [i];
                    var pointAsString:String = DataUtils.pointToStringData(point);
                    if (defenderPositionData.availablePoints.indexOf(pointAsString) == -1) {
                        defenderPositionData.availablePoints.push(pointAsString);
                        trace("add point " + point);
                    }
                }
                dispatchEvent(new EditDefenderPositionEvent (defenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED));
            }
        }
    }

    /**
     * Удаление точек в зоне защитников.
     * @param points Удаляемые точки.
     * @param defenderPositionData Зона защтников.
     */
    public function removePointsFromDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        if (_levelData) {
            if (_levelData) {
                if (_levelData.defenderPositions.indexOf(defenderPositionData) != -1) {
                    var numPoints:int = points.length;
                    for (var i:int = 0; i < numPoints; i++) {
                        var point:Point = points [i];
                        var pointAsString:String = DataUtils.pointToStringData(point);
                        var pointIndex:int = defenderPositionData.availablePoints.indexOf(pointAsString);
                        if (pointIndex != -1) {
                            defenderPositionData.availablePoints.splice(pointIndex, 1);
                        }
                    }
                    dispatchEvent(new EditDefenderPositionEvent (defenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED));
                }
            }
        }
    }

    /**
     * Установка позиции зоны защитников.
     * @param point Точка установки.
     * @param defenderPositionData Зона защтников.
     */
    public function setPositionOfDefenderPosition (point:Point, defenderPositionData:DefenderPositionData):void {
        if (_levelData) {
            if (_levelData) {
                if (_levelData.defenderPositions.indexOf(defenderPositionData) != -1) {
                    defenderPositionData.place(point.x,  point.y);
                    dispatchEvent(new EditDefenderPositionEvent (defenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED));
                }
            }
        }
    }

    /**
     * Удаление всех точек зоны защитников.
     * @param defenderPositionData Зона защтников.
     */
    public function clearAllPointsFromDefenderPosition (defenderPositionData:DefenderPositionData):void {
        if (_levelData) {
            defenderPositionData.clearAllDefenderZonesPoint();
            dispatchEvent(new EditDefenderPositionEvent (defenderPositionData, EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED));
        }
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    /**
     * Сохранение файла с настройками уровня.
     */
    public function save ():void {
        levelData.save(levelData.export());
    }

    public function export ():void {
        //
    }

    /**
     * Деактивация.
     */
    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;

        for (var id: String in _fieldAsObj) {
            delete _fieldAsObj[id];
        }
        _fieldAsObj = null;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function updateDepths():void {
        var toCheck: Vector.<Cell> = new <Cell>[];

        var object: FieldObject;
        var cell: Cell;
        var len: int = _field.length;
        for (var i:int = 0; i < len; i++) {
            _field[i].depth = 0;
            toCheck.push(_field[i]);
        }

        var index: int = 0;
        var tries: int = 100;
        var checkedObjects: Array = [];
        while (len && tries-->0) {
            for (i = 0; i < len; i++) {
                cell = toCheck[i];
                if (!cell.depth && checkUpperCells(cell)) {
                    object = cell.object;
                    if (object && object.data.width>1 && object.data.height>1) {
                        object.markSize(cell.x, cell.y);
                        checkedObjects.push(object);
                        if (object.sizeChecked) {
                            setObjectDepth(object, ++index);
                        }
                    } else {
                        cell.depth = ++index;
                    }
                }
            }
            while (checkedObjects.length>0) {
                checkedObjects.pop().clearSize();
            }
            for (var k: int = 0; k < len; k++) {
                if (toCheck[k].depth) {
                    toCheck.splice(k--, 1);
                    len--;
                }
            }
        }
    }

    private function setObjectDepth($object: FieldObject, $depth: int):void {
        for (var i:int = 0; i < $object.data.width; i++) {
            for (var j:int = 0; j < $object.data.height; j++) {
                if ($object.data.mask[i][j]) {
                    var cell: Cell = getCell($object.cell.x+i-$object.data.top.x, $object.cell.y+j-$object.data.top.y);
                    cell.depth = $depth;
                }
            }
        }
    }

    private function checkUpperCells($cell: Cell):Boolean {
        return checkUpperCell( getCell($cell.x, $cell.y-1), $cell.object ) &&
               checkUpperCell( getCell($cell.x-1, $cell.y), $cell.object );
    }

    private function checkUpperCell($cell: Cell, $object: FieldObject):Boolean {
        return !$cell || $cell.depth || ($cell.object && $cell.object==$object);
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldAsObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                if (i+j>0.4*_width && i+j<1.6*_width && Math.abs(i-j)<0.4*_height) {
                    cell = new Cell(i, j);
                    _field.push(cell);
                    _fieldAsObj[i+"."+j] = cell;
                }
            }
        }
        _field.sort(sortField);
    }

    private function sortField($cell1: Cell, $cell2: Cell):int {
        if ($cell1.sorter>$cell2.sorter) {
            return 1;
        } else if ($cell1.sorter<$cell2.sorter) {
            return -1;
        }
        if ($cell1.y>$cell2.y) {
            return 1;
        } else if ($cell1.y<$cell2.y) {
            return -1;
        }
        return 0;
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldAsObj[x+"."+y];
    }

    private function removeObject($object: PlaceData):void {
        if (_levelData) {
            _levelData.removeObject($object);
            var len: int = _objects.length;
            for (var i:int = 0; i < len; i++) {
                var obj: FieldObject = _objects[i];
                if (obj.placeData == $object) {
                    removePart(obj.placeData.x, obj.placeData.y, obj);

                    _objects.splice(i--, 1);
                    len--;
                    dispatchEvent(new EditObjectEvent(obj, EditObjectEvent.FIELD_OBJECT_WAS_REMOVED));
                }
            }
        }
    }

    private function removePart($x: int, $y: int, $object: FieldObject):void {
        var cell: Cell;
        for (var i:int = 0; i < $object.data.mask.length; i++) {
            for (var j:int = 0; j < $object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    cell.unlock();
                    if ($object.data.mask[i][j]==1) {
                        cell.removeObject($object);
                    }
                }
            }
        }
    }

    private function createObjects($objects: Vector.<PlaceData>):void {
        _objects = new <FieldObject>[];
        var len: int = $objects.length;
        for (var i: int = 0; i < len; i++) {
            var obj: PlaceData = $objects[i];
            obj.realObject = _objectsStorage.getObjectData(obj.object);
            createObject(obj.x, obj.y, obj.realObject, obj);
        }
        updateDepths();
        dispatchEventWith(GameEvent.UPDATE);
    }

    private function createObject($x: int, $y: int, $data: ObjectData, $placeData: PlaceData):void {
        for each (var part: PartData in $data.parts) {
            createPart($x, $y, part, $placeData);
        }
    }

    private function checkObject($x: int, $y: int, $data: ObjectData):Boolean {
        for each (var part: PartData in $data.parts) {
            for (var i:int = 0; i < $data.mask.length; i++) {
                for (var j:int = 0; j < $data.mask[i].length; j++) {
                    var cell: Cell = getCell($x+i, $y+j);
                    if (cell) {
                        if ($data.mask[i][j]==1 && cell.object) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    private function createPart($x: int, $y: int, $data: PartData, $placeData: PlaceData):void {
        var object: FieldObject = new FieldObject($data, $placeData);

        var cell: Cell;
        for (var i:int = 0; i < object.data.mask.length; i++) {
            for (var j:int = 0; j < object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    if (object.data.mask[i][j]) {
                        cell.lock();
                        cell.addObject(object);
                    }
                }
            }
        }
        if (cell) {
            object.place(getCell($x+object.data.top.x, $y+object.data.top.y));
            _objects.push(object);

            dispatchEvent(new EditObjectEvent (object, EditObjectEvent.FIELD_OBJECT_WAS_ADDED));
        }
    }

    private function hasGeneratorWaveData (generatorWaveData:GeneratorWaveData):Boolean {
        if (_levelData) {
            var numGenerators:int = _levelData.generators.length;
            for (var i:int = 0; i < numGenerators; i++) {
                var generatorData:GeneratorData = _levelData.generators [i];
                var index:int = generatorData.waves.indexOf (generatorWaveData);
                if (index != -1) {
                    return true;
                }
            }
        }
        return false;
    }
}
}
