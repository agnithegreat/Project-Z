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
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectData;

import flash.geom.Point;

import starling.events.EventDispatcher;

/**
 * Класс-контроллер, предназначенный редактирования карты уровня. Получая команды, диспатчит события.
 */
public class LevelEditorController extends EventDispatcher {

    private var model:Field;

    public function LevelEditorController(model:Field) {
        this.model = model;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    public function addObject (placeData:PlaceData):Boolean {
        return model.addObject(placeData);
    }

    public function selectObject ($x: int, $y: int):void {
        model.selectObject($x,  $y);
    }

    public function changeBackground (objectData:ObjectData):void {
        model.changeBackground (objectData.name);
    }

    public function clearAllObjects ():void {
        model.removeAllObject();
    }

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    public function addPointToPath (points:Vector.<Point>, pathData:PathData):void {
        model.addPointsToPath (points, pathData);
    }

    public function removePointFromPath (points:Vector.<Point>, pathData:PathData):void {
        model.removePointFromPath (points, pathData);
    }

    public function setPathColor (color:uint, pathData:PathData):void {
        model.setPathColor (color, pathData);
    }

    public function addNewPath ():void {
        model.addNewPath ();
    }


    public function deletePath (pathData:PathData):void {
        model.deletePath (pathData);
    }

    /////////////////////////////////////////////
    //GENERATORS:
    /////////////////////////////////////////////

    public function addNewGenerator ():void {
        model.addNewGenerator();
    }

    public function removeGenerator (generatorData:GeneratorData):void {
        model.removeGenerator(generatorData);
    }

    public function setGeneratorPath (pathId:int, generatorData:GeneratorData):void {
        model.setGeneratorPath(pathId, generatorData);
    }

    public function setGeneratorPosition (point:Point, generatorData:GeneratorData):void {
        model.setGeneratorPosition(point, generatorData);
    }

    /////////////////////////////////////////////
    //WAVES:
    /////////////////////////////////////////////

    public function addNewWave():void {
        model.addNewWave();
    }

    public function removeWave(waveId:int):void {
        model.removeWave(waveId);
    }

    //устанавливаем время для волны:
    public function setWaveTime (time:int, waveData:WaveData):void {
        model.setWaveTime(time, waveData);
    }

    //устанавливаем задержку для волны генератора:
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        model.setDelayOfGeneratorWave(delay, generatorWaveData);
    }

    //добавляем тип врага для волны генератора:
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, count:int, generatorWaveData:GeneratorWaveData):void {
        model.addEnemyToGeneratorWave(enemyId, positionId, count, generatorWaveData);
    }

    //убираем тип врага для волны генератора:
    public function removeEnemyToGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        model.removeEnemyToGeneratorWave(positionId, generatorWaveData);
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    /**
     * Добавление новой зоны защитников
     */
    public function addNewDefenderPosition ():void {
        model.addNewDefenderPosition();
    }

    /**
     * Удаление зоны защитников
     * @param defenderPositionData Зона защтников
     */
    public function removeDefenderPosition (defenderPositionData:DefenderPositionData):void {
        model.removeDefenderPosition(defenderPositionData);
    }

    /**
     * Добавление точек в зону защитников.
     * @param points Удаляемые точки
     * @param defenderPositionData Зона защтников
     */
    public function addPointsToDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        model.addPointsToDefenderPosition(points, defenderPositionData);
    }

    /**
     * Удаление точек в зоне защитников.
     * @param points Удаляемые точки
     * @param defenderPositionData Зона защтников
     */
    public function removePointsFromDefenderPosition (points:Vector.<Point>, defenderPositionData:DefenderPositionData):void {
        model.removePointsFromDefenderPosition(points, defenderPositionData);
    }

    /**
     * Установка позиции зоны защитников.
     * @param point Точка установки
     * @param defenderPositionData Зона защтников
     */
    public function setPositionOfDefenderPosition (point:Point, defenderPositionData:DefenderPositionData):void {
        model.setPositionOfDefenderPosition (point, defenderPositionData);
    }

    /**
     * Удаление всех точек зоны защитников
     * @param defenderPositionData Зона защтников
     */
    public function clearAllPointsFromDefenderPosition (defenderPositionData:DefenderPositionData):void {
        model.clearAllPointsFromDefenderPosition(defenderPositionData);
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    /**
     * Сохранение файла с настройками уровня
     */
    public function save ():void {
        model.save();
    }

    public function export ():void {
        model.export();
    }

}
}
