/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectData;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, классический mvc-контроллер.
 */
public class LevelEditorController extends EventDispatcher {

    private var model:Field;//Ссылка на модель (mvc).

    /**
     *
     * @param model Ссылка на модель (mvc).
     */
    public function LevelEditorController(model:Field) {
        this.model = model;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    /**
     * Добавление объекта на карту.
     * @param placeData Объект.
     * @return Возращает <code>true</code>, если объект удалось добавить.
     */
    public function addObject (placeData:PlaceData):Boolean {
        return model.addObject(placeData);
    }

    /**
     * Поиск объекта в указанной позиции. При нахождении происходит удаление объекта и выбор его текущим выбранным объектом на карте.
     * @param $x
     * @param $y
     */
    public function selectObject ($x: int, $y: int):void {
        model.selectObject($x,  $y);
    }

    /**
     * Установка фонововой картинки для уровня.
     * @param objectData Объект, сождержащий фоновую картинку.
     */
    public function changeBackground (objectData:ObjectData):void {
        model.changeBackground (objectData.name);
    }

    /**
     * Удаление всех объектов на карте.
     */
    public function removeAllObject ():void {
        model.removeAllObject();
    }

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    /**
     * Добавление массива точек к пути.
     * @param points Массив точек.
     * @param pathData Путь.
     */
    public function addPointsToPath (points:Vector.<Point>, pathData:PathData):void {
        model.addPointsToPath (points, pathData);
    }

    /**
     * Удаление массива точек из пути.
     * @param points Массив точек.
     * @param pathData Путь.
     */
    public function removePointsFromPath (points:Vector.<Point>, pathData:PathData):void {
        model.removePointsFromPath (points, pathData);
    }

    /**
     * Установка цвета для пути (цвет пути отображается в самом редакторе).
     * @param color Цвет.
     * @param pathData Путь.
     */
    public function setPathColor (color:uint, pathData:PathData):void {
        model.setPathColor (color, pathData);
    }

    /**
     * Добавление нового пути.
     */
    public function addNewPath ():void {
        model.addNewPath ();
    }

    /**
     * Удаление пути.
     * @param pathData Путь.
     */
    public function deletePath (pathData:PathData):void {
        model.deletePath (pathData);
    }

    /////////////////////////////////////////////
    //GENERATORS:
    /////////////////////////////////////////////

    /**
     * Добавление нового генератора.
     */
    public function addNewGenerator ():void {
        model.addNewGenerator();
    }

    /**
     * Удаление генератора.
     * @param generatorData Генератор.
     */
    public function removeGenerator (generatorData:GeneratorData):void {
        model.removeGenerator(generatorData);
    }

    /**
     * Установка пути для выбранного генератора.
     * @param pathId Id'шник пути.
     * @param generatorData Генератор.
     */
    public function setGeneratorPath (pathId:int, generatorData:GeneratorData):void {
        model.setGeneratorPath(pathId, generatorData);
    }

    /**
     * Установка позиции для выбранного генератора.
     * @param point
     * @param generatorData
     */
    public function setGeneratorPosition (point:Point, generatorData:GeneratorData):void {
        model.setGeneratorPosition(point, generatorData);
    }

    /////////////////////////////////////////////
    //WAVES:
    /////////////////////////////////////////////

    /**
     * Добавление новой волны.
     */
    public function addNewWave():void {
        model.addNewWave();
    }

    /**
     * Удаление волны.
     * @param waveId Id'шник волны для удаления.
     */
    public function removeWave(waveId:int):void {
        model.removeWave(waveId);
    }

    /**
     * Устанавка времяни для волны. Время устанавливается для всех генераторов в волне.
     * @param time Время
     * @param waveData Волна
     */
    public function setWaveTime (time:int, waveData:WaveData):void {
        model.setWaveTime(time, waveData);
    }

    /**
     * Устанавка задержки для волны генератора.
     * @param delay
     * @param generatorWaveData Волна генератора.
     */
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        model.setDelayOfGeneratorWave(delay, generatorWaveData);
    }

    /**
     * Добавляем врага для стека волны генератора.
     * @param enemyId Id'шник врага.
     * @param positionId Позиция в списке врагов (влияет на очередность появления врагов).
     * @param count Количество добавляемых врагов с таким именем.
     * @param generatorWaveData Волна генератора.
     */
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, count:int, generatorWaveData:GeneratorWaveData):void {
        model.addEnemyToGeneratorWave(enemyId, positionId, count, generatorWaveData);
    }

    /**
     * Убираем врага из стека волны генератора.
     * @param positionId Позиция в списке врагов (влияет на очередность появления врагов).
     * @param generatorWaveData Волна генератора.
     */
    public function removeEnemyToGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        model.removeEnemyToGeneratorWave(positionId, generatorWaveData);
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    /**
     * Добавление новой зоны защитников.
     */
    public function addNewDefenderPosition ():void {
        model.addNewDefenderPosition();
    }

    /**
     * Удаление зоны защитников.
     * @param defenderPositionData Зона защтников.
     */
    public function removeDefenderPosition (defenderPositionData:DefenderPositionData):void {
        model.removeDefenderPosition(defenderPositionData);
    }

    /**
     * Добавление точек в зону защитников.
     * @param points Удаляемые точки.
     * @param defenderPositionData Зона защтников.
     */
    public function addPointsToDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        model.addPointsToDefenderPosition(points, defenderPositionData);
    }

    /**
     * Удаление точек в зоне защитников.
     * @param points Удаляемые точки.
     * @param defenderPositionData Зона защтников.
     */
    public function removePointsFromDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        model.removePointsFromDefenderPosition(points, defenderPositionData);
    }

    /**
     * Установка позиции зоны защитников.
     * @param point Точка установки.
     * @param defenderPositionData Зона защтников.
     */
    public function setPositionOfDefenderPosition (point:Point, defenderPositionData:DefenderPositionData):void {
        model.setPositionOfDefenderPosition (point, defenderPositionData);
    }

    /**
     * Удаление всех точек зоны защитников.
     * @param defenderPositionData Зона защтников.
     */
    public function clearAllPointsFromDefenderPosition (defenderPositionData:DefenderPositionData):void {
        model.clearAllPointsFromDefenderPosition(defenderPositionData);
    }

    /////////////////////////////////////////////
    //LEVELS:
    /////////////////////////////////////////////

    /**
     * Выбор текущего уровня.
     * @param levelData Уровень.
     */
    public function setCurrentLevel (levelData:LevelData):void {
        model.levelData = levelData;
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    /**
     * Сохранение файла с настройками уровня.
     */
    public function save ():void {
        model.save();
    }

    public function export ():void {
        model.export();
    }

}
}
