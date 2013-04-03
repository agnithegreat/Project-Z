/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {

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

    public function addPointToPath (point:Point, pathData:PathData):void {
        model.addPointToPath (point, pathData);
    }

    public function removePointFromPath (point:Point, pathData:PathData):void {
        model.removePointFromPath (point, pathData);
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

    public function removeWave(waveData:WaveData):void {
        model.removeWave(waveData);
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
    public function addEnemyToGeneratorWave (enemy:String, generatorWaveData:GeneratorWaveData):void {
        model.addEnemyToGeneratorWave(enemy, generatorWaveData);
    }

    //убираем тип врага для волны генератора:
    public function removeEnemyToGeneratorWave (enemy:String, generatorWaveData:GeneratorWaveData):void {
        model.removeEnemyToGeneratorWave(enemy, generatorWaveData);
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    public function save ():void {
        model.save();
    }

    public function export ():void {
        model.export();
    }

}
}
