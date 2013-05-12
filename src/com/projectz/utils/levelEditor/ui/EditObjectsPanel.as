/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectBackgroundEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.containers.ScrollPane;

import fl.controls.ComboBox;
import fl.data.DataProvider;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Панель редактора уровней для редактирования объектов на уровне.
 */
public class EditObjectsPanel extends BasicPanel {

    private var uiController:UIController;//Ссылка на модель (mvc).
    private var objectStorage:ObjectsStorage;//Хранилище всех игровых ассетов (для формирования списка обектов).
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    //Элементы ui:
    private var cbxObjectsType:ComboBox;
    private var scpObjects:ScrollPane;
    private var cbxBackgrounds:ComboBox;

    private var objectsContainer:Sprite = new Sprite ();//Контейнер для отображения списка объектов.

    private var btnClearAll:ButtonWithText;

    private static const NUM_ELEMENTS_IN_ROW:int = 3;
    private static const ELEMENTS_START_X:int = 1;
    private static const ELEMENTS_START_Y:int = 1;
    private static const ELEMENT_WIDTH:int = 122;
    private static const ELEMENT_HEIGHT:int = ELEMENT_WIDTH + 20;
    private static const ELEMENT_DISTANCE_X:int = ELEMENT_WIDTH + 1;
    private static const ELEMENT_DISTANCE_Y:int = ELEMENT_DISTANCE_X + 20;

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param uiController Ссылка на контроллер (mvc).
     * @param objectStorage Хранилище всех игровых ассетов.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function EditObjectsPanel(mc:MovieClip, uiController:UIController, objectStorage:ObjectsStorage, assetsManager:AssetManager) {
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        this.assetsManager = assetsManager;

        uiController.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        uiController.addEventListener(SelectBackgroundEvent.SELECT_BACKGROUND, selectBackGroundListener);
        uiController.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);

        super (mc);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        //Инициализируем компоненты:
        cbxObjectsType = ComboBox (getElement("cbxObjectsType"));
        scpObjects = ScrollPane (getElement("scpObjects"));
        cbxBackgrounds = ComboBox (getElement("cbxBackgrounds"));

        cbxObjectsType.focusEnabled = false;
        scpObjects.focusEnabled = false;
        cbxBackgrounds.focusEnabled = false;

        //Формируем список типов объектов:
        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"static object (" + ObjectType.STATIC_OBJECT + ")",data:ObjectType.STATIC_OBJECT});
        dataProvider.addItem({label:"target object (" + ObjectType.TARGET_OBJECT + ")",data:ObjectType.TARGET_OBJECT});
        dataProvider.addItem({label:"animated object (" + ObjectType.ANIMATED_OBJECT + ")",data:ObjectType.ANIMATED_OBJECT});
        cbxObjectsType.dataProvider = dataProvider;
        dataProvider = new DataProvider ();

        //Формируем список бэкграундов:
        var object: ObjectData;
        var objects: Dictionary = objectStorage.getType(ObjectType.BACKGROUND);
        for each (object in objects) {
            var objectData:ObjectData = ObjectData (object);
            dataProvider.addItem({label:objectData.name,data:objectData});
        }
        cbxBackgrounds.dataProvider = dataProvider;

        //Добавляем слушателей для компонентов:
        cbxObjectsType.addEventListener (Event.CHANGE, changeListener_cbxObjectsType);
        cbxBackgrounds.addEventListener (Event.CLOSE, changeListener_cbxBackgrounds);

        //Создаём кнопки:
        btnClearAll = new ButtonWithText (mc["btnClearAll"]);

        //Устанавливаем тексты на кнопках:
        btnClearAll.text = "очистить всё";

        //Добавляем слушателей для кнопок:
        btnClearAll.addEventListener(MouseEvent.CLICK, clickListener);
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnClearAll):
                uiController.removeAllObject();
                break;
        }
    }

    private function selectObjectListener (event:SelectObjectEvent):void {
        var numObjects:int = objectsContainer.numChildren;
        for (var i:int = 0; i < numObjects; i++) {
            var child:DisplayObject = objectsContainer.getChildAt(i);
            var objectPreView:ObjectPreView = ObjectPreView (child);
            objectPreView.select = (objectPreView.objectData == event.objectData);
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
        //Устанавливаем позицию комбобокса типов объектов для выбранноо типа:
        var dataProvider:DataProvider = cbxObjectsType.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.objectsType) {
                cbxObjectsType.selectedItem = dataProviderItem;
//                trace ("select objectsType = " + event.objectsType);
                break;
            }
        }

        //Очищаем список объектов:
        var objectPreView:ObjectPreView;
        while (objectsContainer.numChildren > 0) {
            var child:DisplayObject = objectsContainer.getChildAt(0);
            objectPreView = ObjectPreView (child);
            objectPreView.removeEventListener(MouseEvent.CLICK, clickListener_objectPreView);
            objectsContainer.removeChild(child);
        }


        //Формируем список объектов выбранного типа:
        var object: ObjectData;
        var objects: Dictionary = objectStorage.getType(event.objectsType);
        i = 0;
        var curColumn:int;
        var curRow:int;
        for each (object in objects) {
            var objectData:ObjectData = ObjectData (object);
            objectPreView = new ObjectPreView (objectData, assetsManager);
            objectsContainer.addChild (objectPreView);
            curRow = Math.floor (i / NUM_ELEMENTS_IN_ROW);
            curColumn = i - curRow * NUM_ELEMENTS_IN_ROW;
            objectPreView.x = ELEMENTS_START_X + curColumn * ELEMENT_DISTANCE_X;
            objectPreView.y = ELEMENTS_START_Y + curRow * ELEMENT_DISTANCE_Y;
            objectPreView.containerWidth = ELEMENT_WIDTH;
            objectPreView.containerHeight = ELEMENT_HEIGHT;
            objectPreView.addEventListener(MouseEvent.CLICK, clickListener_objectPreView);
            i++;
        }
        scpObjects.source = objectsContainer;
    }

    private function changeListener_cbxObjectsType (event:Event):void {
        //Устанавливаем тип объекта для редактирования в контроллере:
        uiController.selectCurrentObjectType(String (cbxObjectsType.selectedItem.data));
    }

    private function clickListener_objectPreView (event:MouseEvent):void {
        var objectPreView:ObjectPreView = ObjectPreView (event.currentTarget);
        uiController.selectCurrentObject(objectPreView.objectData);
    }

    private function changeListener_cbxBackgrounds (event:Event):void {
        //Устанавливаем фон:
        uiController.selectLevelBackground(ObjectData (cbxBackgrounds.selectedItem.data));
    }

}
}
