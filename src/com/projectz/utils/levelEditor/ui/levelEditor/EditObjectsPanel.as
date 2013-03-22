/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.levelEditor {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.controls.ComboBox;
import fl.controls.List;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class EditObjectsPanel extends GraphicStorage implements IPanel{

    private var cbxObjectsType:ComboBox;
    private var listObjects:List;
    private var cbxBackgrounds:ComboBox;

    private var uiController:UIController;
    private var objectStorage:ObjectsStorage;

    private var btnSave:ButtonWithText;
    private var btnClearAll:ButtonWithText;

    public function EditObjectsPanel(mc:MovieClip, uiController:UIController, objectStorage:ObjectsStorage) {
        this.uiController = uiController;
        this.objectStorage = objectStorage;

        uiController.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        uiController.addEventListener(SelectBackgroundEvent.SELECT_BACKGROUND, selectBackGroundListener);
        uiController.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);

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
        listObjects = List (getElement("listObjects"));
        cbxBackgrounds = ComboBox (getElement("cbxBackgrounds"));

        cbxObjectsType.focusEnabled = false;
        listObjects.focusEnabled = false;
        cbxBackgrounds.focusEnabled = false;

        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"animated object (" + ObjectData.ANIMATED_OBJECT + ")",data:ObjectData.ANIMATED_OBJECT});
        dataProvider.addItem({label:"static object (" + ObjectData.STATIC_OBJECT + ")",data:ObjectData.STATIC_OBJECT});
        dataProvider.addItem({label:"enemies (" + ObjectData.ENEMY + ")",data:ObjectData.ENEMY});
        cbxObjectsType.dataProvider = dataProvider;
        dataProvider = new DataProvider ();

        var object: ObjectData;
        var objects: Dictionary = objectStorage.getType(ObjectData.BACKGROUND);
        for each (object in objects) {
            var objectData:ObjectData = ObjectData (object);
            dataProvider.addItem({label:objectData.name,data:objectData});
        }
        cbxBackgrounds.dataProvider = dataProvider;

        listObjects.addEventListener (Event.CHANGE, changeListener_listObjects);
        cbxObjectsType.addEventListener (Event.CHANGE, changeListener_cbxObjectsType);
        cbxBackgrounds.addEventListener (Event.CHANGE, changeListener_cbxBackgrounds);

        //создание кнопок:
        btnSave = new ButtonWithText (mc["btnSave"]);
        btnClearAll = new ButtonWithText (mc["btnClearAll"]);

        btnSave.text = "сохранить";
        btnClearAll.text = "очистить всё";

        btnSave.addEventListener(MouseEvent.CLICK, clickListener);
        btnClearAll.addEventListener(MouseEvent.CLICK, clickListener);

    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnSave):
                uiController.save();
                break;
            case (btnClearAll):
                uiController.clearAllObjects();
                break;
        }
    }

    private function selectObjectListener (event:SelectObjectEvent):void {
        //устанавливаем позицию листа для выбранноо объекта:
        var dataProvider:DataProvider = listObjects.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.objectData) {
                listObjects.selectedItem = dataProviderItem;
                if (event.objectData) {
                    trace ("select object = " + event.objectData.name);
                }
                else {
                    trace ("select object = null");
                }
                break;
            }
        }
    }

    private function selectBackGroundListener (event:SelectBackgroundEvent):void {
        //устанавливаем позицию комбобокса для выбранноо фона:
        var dataProvider:DataProvider = cbxBackgrounds.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.objectData) {
                cbxBackgrounds.selectedItem = dataProviderItem;
                trace ("select background = " + event.objectData.name);
                break;
            }
        }
    }

    private function selectObjectsTypeListener (event:SelectObjectsTypeEvent):void {
        //устанавливаем позицию комбобокса для выбранноо типа:
        var dataProvider:DataProvider = cbxObjectsType.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.objectsType) {
                cbxObjectsType.selectedItem = dataProviderItem;
                trace ("select objectsType = " + event.objectsType);
                break;
            }
        }

        //формируем список объектов выбранного типа:
        dataProvider = new DataProvider ();
        var object: ObjectData;
        var objects: Dictionary = objectStorage.getType(event.objectsType);
//        dataProvider.addItem({label:"Выберете объект...",data:null});
        for each (object in objects) {
            var objectData:ObjectData = ObjectData (object);
            dataProvider.addItem({label:objectData.name,data:objectData});
        }
        listObjects.dataProvider = dataProvider;
    }

    private function changeListener_cbxObjectsType (event:Event):void {
        uiController.selectCurrentObjectType(String (cbxObjectsType.selectedItem.data));
    }

    private function changeListener_listObjects (event:Event):void {
        uiController.selectCurrentObject(ObjectData (listObjects.selectedItem.data));
    }

    private function changeListener_cbxBackgrounds (event:Event):void {
        uiController.selectLevelBackground(ObjectData (cbxBackgrounds.selectedItem.data));
    }

}
}
