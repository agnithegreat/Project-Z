/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 9:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller {

import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectData;

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

    public function addObject (placeData:PlaceData):void {
        model.addObject(placeData);
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

    public function save ():void {
        model.save();
    }

    public function export ():void {
        model.export();
    }
}
}
