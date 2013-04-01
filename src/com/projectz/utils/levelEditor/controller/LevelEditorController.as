/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
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
