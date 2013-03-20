/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.hogarLevelEditor {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.events.SelectBackGroundEvent;
import com.projectz.utils.levelEditor.events.SelectObjectEvent;
import com.projectz.utils.levelEditor.events.SelectObjectsTypeEvent;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.controls.ComboBox;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

public class EditObjectsPanel extends GraphicStorage implements IPanel{

    private var cbxObjectsType:ComboBox;
    private var cbxObjects:ComboBox;
    private var cbxBackgrounds:ComboBox;

    private var controller:LevelEditorController;
    private var objectStorage:ObjectsStorage;

    private var btnSave:ButtonWithText;
    private var btnClearAll:ButtonWithText;

    public function EditObjectsPanel(mc:MovieClip, controller:LevelEditorController, objectStorage:ObjectsStorage) {
        this.controller = controller;
        this.objectStorage = objectStorage;

        controller.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        controller.addEventListener(SelectBackGroundEvent.SELECT_BACKGROUND, selectBackGroundListener);
        controller.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);

        super (mc);
    }

    public function show():void {
        visible = true;
    }

    public function hide():void {
        visible = false;
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        cbxObjectsType = ComboBox (getElement("cbxObjectsType"));
        cbxObjects = ComboBox (getElement("cbxObjects"));
        cbxBackgrounds = ComboBox (getElement("cbxBackgrounds"));

        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"animated object (" + ObjectData.ANIMATED_OBJECT + ")",data:ObjectData.ANIMATED_OBJECT});
        dataProvider.addItem({label:"static object (" + ObjectData.STATIC_OBJECT + ")",data:ObjectData.STATIC_OBJECT});
        cbxObjectsType.dataProvider = dataProvider;
        cbxObjectsType.addEventListener (Event.CHANGE, changeListener_cbxObjectsType);

        var

        //создание кнопок:
        btnSave = new ButtonWithText (mc["btnSave"]);
        btnClearAll = new ButtonWithText (mc["btnClearAll"]);

        btnSave.text = "сохранить";
        btnClearAll.text = "очистить";

    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnSave):
                //действие
                break;
            case (btnClearAll):
                //действие
                break;
        }
    }

//    private function handleClick($event: Event):void {
//        switch ($event.currentTarget) {
//            case _bgTab:
//                _controller.selectObjectType(ObjectData.BACKGROUND);
//                break;
//            case _staticTab:
//                _controller.selectObjectType(ObjectData.STATIC_OBJECT);
//                break;
//            case _animatedTab:
//                _controller.selectObjectType(ObjectData.ANIMATED_OBJECT);
//                break;
//            case _enemiesTab:
//                _controller.selectObjectType(ObjectData.ENEMY);
//                break;
//        }
//    }

    private function selectObjectListener (event:SelectObjectEvent):void {
        cbxObjects
    }

    private function selectBackGroundListener (event:SelectBackGroundEvent):void {
        cbxBackgrounds
    }

    private function selectObjectsTypeListener (event:SelectObjectsTypeEvent):void {
        cbxObjectsType
    }

    private function changeListener_cbxObjectsType (event:Event):void {
        controller.selectObjectType(String (cbxObjectsType.selectedItem.data));
    }

    private function changeListener_cbxObjects (event:Event):void {
        controller.selectObject(ObjectData (cbxObjects.selectedItem.data));
    }

    private function changeListener_cbxBackgrounds (event:Event):void {
        controller.selectBackground(ObjectData (cbxBackgrounds.selectedItem.data));
    }

//    private function changeListener_cbxObjectsType (event:Event):void {
//
//    }

}
}
