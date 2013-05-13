/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 0:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.PartData;

import fl.containers.ScrollPane;
import fl.controls.CheckBox;

import fl.controls.ComboBox;
import fl.controls.List;
import fl.controls.NumericStepper;
import fl.data.DataProvider;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Панель редактора уровней для редактирования ресурсов (ассетов).
 */
public class EditAssetsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var objectStorage:ObjectsStorage;//Хранилище всех игровых ассетов.
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    //Элементы ui:
    private var cbxObjectsType:ComboBox;
    private var scpObjects:ScrollPane;
    private var listObjectParts:List;
    private var nstRows:NumericStepper;
    private var nstColumns:NumericStepper;
    private var nstPivotX:NumericStepper;
    private var nstPivotY:NumericStepper;
    private var chbShotThrough:CheckBox;

    private var objectsContainer:Sprite = new Sprite ();//Контейнер для отображения списка объектов.

    private static const NUM_ELEMENTS_IN_ROW:int = 3;
    private static const ELEMENTS_START_X:int = 1;
    private static const ELEMENTS_START_Y:int = 1;
    private static const ELEMENT_WIDTH:int = 122;
    private static const ELEMENT_HEIGHT:int = ELEMENT_WIDTH + 20;
    private static const ELEMENT_DISTANCE_X:int = ELEMENT_WIDTH + 1;
    private static const ELEMENT_DISTANCE_Y:int = ELEMENT_DISTANCE_X + 20;

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param objectStorage Хранилище всех игровых ассетов.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function EditAssetsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage, assetsManager:AssetManager) {
        this.model = model;
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        this.assetsManager = assetsManager;

        uiController.addEventListener(SelectAssetEvent.SELECT_ASSET, selectAssetListener);
        uiController.addEventListener(SelectAssetsTypeEvent.SELECT_ASSETS_TYPE, selectAssetsTypeListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);

        super(mc);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //Инициализируем элементы ui:
        cbxObjectsType = ComboBox(getElement("cbxObjectsType"));
        scpObjects = ScrollPane(getElement("scpObjects"));
        listObjectParts = List(getElement("listObjectParts"));
        nstRows = NumericStepper(getElement("nstRows"));
        nstColumns = NumericStepper(getElement("nstColumns"));
        nstPivotX = NumericStepper(getElement("nstPivotX"));
        nstPivotY = NumericStepper(getElement("nstPivotY"));
        chbShotThrough = CheckBox(getElement("chbShotThrough"));
        nstRows.minimum = 1;
        nstRows.maximum = 1000;
        nstColumns.minimum = 1;
        nstColumns.maximum = 1000;
        nstPivotX.minimum = -1000;
        nstPivotX.maximum = 1000;
        nstPivotY.minimum = -1000;
        nstPivotY.maximum = 1000;

        //Отключаем фокус для компонентов:
        cbxObjectsType.focusEnabled = false;
        scpObjects.focusEnabled = false;
        listObjectParts.focusEnabled = false;
        nstRows.focusEnabled = false;
        nstColumns.focusEnabled = false;
        nstPivotX.focusEnabled = false;
        nstPivotY.focusEnabled = false;
        chbShotThrough.focusEnabled = false;

        //Формируем список типов объектов:
        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"static object (" + ObjectType.STATIC_OBJECT + ")",data:ObjectType.STATIC_OBJECT});
        dataProvider.addItem({label:"target object (" + ObjectType.TARGET_OBJECT + ")",data:ObjectType.TARGET_OBJECT});
        dataProvider.addItem({label:"animated object (" + ObjectType.ANIMATED_OBJECT + ")",data:ObjectType.ANIMATED_OBJECT});
        dataProvider.addItem({label:"animated object (" + ObjectType.ENEMY + ")",data:ObjectType.ENEMY});
        dataProvider.addItem({label:"animated object (" + ObjectType.DEFENDER + ")",data:ObjectType.DEFENDER});
        cbxObjectsType.dataProvider = dataProvider;
        dataProvider = new DataProvider ();

        //Добавляем слушателей для компонентов:
        cbxObjectsType.addEventListener(Event.CHANGE, changeListener_cbxObjectsType);
        listObjectParts.addEventListener(Event.CHANGE, changeListener_listObjectParts);
        nstRows.addEventListener(Event.CHANGE, changeListener_nstRows);
        nstColumns.addEventListener(Event.CHANGE, changeListener_nstColumns);
        nstPivotX.addEventListener(Event.CHANGE, changeListener_nstPivotX);
        nstPivotY.addEventListener(Event.CHANGE, changeListener_nstPivotY);
        chbShotThrough.addEventListener(Event.CHANGE, changeListener_chbShotThrough);
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectAssetListener (event:SelectAssetEvent):void {
        //Выделяем текущий редактируемый ассет и снимаем выделения с остальных:
        var numObjects:int = objectsContainer.numChildren;
        for (var i:int = 0; i < numObjects; i++) {
            var child:DisplayObject = objectsContainer.getChildAt(i);
            var objectPreView:ObjectPreView = ObjectPreView (child);
            objectPreView.select = (objectPreView.objectData == event.objectData);
        }
    }

    private function selectAssetsTypeListener (event:SelectAssetsTypeEvent):void {
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
        var objects: Dictionary = objectStorage.getObjectsByType(event.objectsType);
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

    private function clickListener_objectPreView (event:MouseEvent):void {
        var objectPreView:ObjectPreView = ObjectPreView (event.currentTarget);
        uiController.currentEditingAsset = objectPreView.objectData;
    }

    private function changeListener_cbxObjectsType (event:Event):void {
        uiController.selectCurrentEditingAssetType(String (cbxObjectsType.selectedItem.data));
    }

    private function changeListener_listObjectParts (event:Event):void {
        var partData:PartData = PartData (listObjectParts.selectedItem.data);
        uiController.currentEditingAssetPart = partData;
    }

    private function changeListener_nstRows (event:Event):void {
        uiController
    }

    private function changeListener_nstColumns (event:Event):void {
        //
    }

    private function changeListener_nstPivotX (event:Event):void {
        //
    }

    private function changeListener_nstPivotY (event:Event):void {
        //
    }

    private function changeListener_chbShotThrough (event:Event):void {
        //
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_ASSETS) {
            //Формируем новый список ассетов при переключении контроллера в режим редактирования ассетов.
            uiController.selectCurrentEditingAssetType(String (cbxObjectsType.getItemAt(0).data));
        }
    }
}
}
