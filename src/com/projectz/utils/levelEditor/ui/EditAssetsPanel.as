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
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetPartEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetsTypeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.ObjectDataManager;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.objectEditor.data.events.EditObjectDataEvent;
import com.projectz.utils.objectEditor.data.events.EditPartDataEvent;

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
    private var chbWalkable:CheckBox;
    private var chbShotable:CheckBox;

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
        uiController.addEventListener(SelectAssetPartEvent.SELECT_ASSET_PART, selectAssetPartListener);
        uiController.addEventListener(SelectAssetsTypeEvent.SELECT_ASSETS_TYPE, selectAssetsTypeListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED, assetWasChangedListener);
        uiController.addEventListener(EditPartDataEvent.PART_DATA_WAS_CHANGED, assetPartWasChangedListener);

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
        chbShotable = CheckBox(getElement("chbShotable"));
        chbWalkable = CheckBox(getElement("chbWalkable"));
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
        chbShotable.focusEnabled = false;
        chbWalkable.focusEnabled = false;

        //Формируем список типов объектов:
        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"static object (" + ObjectType.STATIC_OBJECT + ")",data:ObjectType.STATIC_OBJECT});
        dataProvider.addItem({label:"target object (" + ObjectType.TARGET_OBJECT + ")",data:ObjectType.TARGET_OBJECT});
        dataProvider.addItem({label:"animated object (" + ObjectType.ANIMATED_OBJECT + ")",data:ObjectType.ANIMATED_OBJECT});
        dataProvider.addItem({label:"enemies (" + ObjectType.ENEMY + ")",data:ObjectType.ENEMY});
        dataProvider.addItem({label:"defenders (" + ObjectType.DEFENDER + ")",data:ObjectType.DEFENDER});
        cbxObjectsType.dataProvider = dataProvider;
        dataProvider = new DataProvider ();

        //Добавляем слушателей для компонентов:
        cbxObjectsType.addEventListener(Event.CHANGE, changeListener_cbxObjectsType);
        listObjectParts.addEventListener(Event.CHANGE, changeListener_listObjectParts);
        nstRows.addEventListener(Event.CHANGE, changeListener_nstRows);
        nstColumns.addEventListener(Event.CHANGE, changeListener_nstColumns);
        nstPivotX.addEventListener(Event.CHANGE, changeListener_nstPivotX);
        nstPivotY.addEventListener(Event.CHANGE, changeListener_nstPivotY);
        chbShotable.addEventListener(Event.CHANGE, changeListener_chbShotable);
        chbWalkable.addEventListener(Event.CHANGE, changeListener_chbWalkable);
    }

    /**
     * Обновление данных текущего редактируемого в контроллере ассета или его части.
     */
    private function updateData():void {
        if (uiController.currentEditingAssetPart) {
            trace ("show current asset part.");
            var partData:PartData = uiController.currentEditingAssetPart;
            nstPivotX.value = partData.pivotX;
            nstPivotY.value = partData.pivotY;
            nstColumns.value = partData.width;
            nstRows.value = partData.height;
        }
        else if (uiController.currentEditingAsset) {
            trace ("show current asset.");
            var objectData:ObjectData = uiController.currentEditingAsset;
            nstPivotX.value = 0;
            nstPivotY.value = 0;
            nstColumns.value = objectData.width;
            nstRows.value = objectData.height;
        }
        else {
            trace ("clear all data.");
            nstPivotX.value = 0;
            nstPivotY.value = 0;
            nstColumns.value = 0;
            nstRows.value = 0;
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectAssetListener (event:SelectAssetEvent):void {
        //Выделяем текущий редактируемый ассет и снимаем выделения с остальных:
        var objectData:ObjectData = event.objectData;
        var numObjects:int = objectsContainer.numChildren;
        for (var i:int = 0; i < numObjects; i++) {
            var child:DisplayObject = objectsContainer.getChildAt(i);
            var objectPreView:ObjectPreview = ObjectPreview (child);
            objectPreView.select = (objectPreView.objectData == objectData);
        }
        //Формируем список частей выбранного ассета:
        var dataProvider:DataProvider = new DataProvider();
        if (objectData) {
            var partData:PartData;
            var parts:Dictionary = objectData.parts;
            for each (partData in parts) {
                var partName:String = partData.name;
                if (!partName) {
                    partName = "front";
                }
                dataProvider.addItem({label:partName, data:partData});
            }
            if (objectData.shadow) {
                dataProvider.addItem({label:objectData.shadow.name, data:objectData.shadow});
            }
        }
        listObjectParts.dataProvider = dataProvider;

        updateData();
    }

    private function selectAssetPartListener (event:SelectAssetPartEvent):void {
        var partData:PartData = event.partData;

        updateData();
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
        var objectPreview:ObjectPreview;
        while (objectsContainer.numChildren > 0) {
            var child:DisplayObject = objectsContainer.getChildAt(0);
            objectPreview = ObjectPreview (child);
            objectPreview.removeEventListener(MouseEvent.CLICK, clickListener_objectPreView);
            objectsContainer.removeChild(child);
        }


        //Формируем список объектов выбранного типа:
        var object: ObjectData;
        var objects: Dictionary = objectStorage.getObjectsByType(event.objectsType);
        var objectsAsVector:Vector.<ObjectData> = new Vector.<ObjectData>();
        for each (object in objects) {
            objectsAsVector.push(ObjectData (object));
        }

        objectsAsVector.sort(ObjectDataManager.sortByName);

        var curColumn:int;
        var curRow:int;
        var numPreviewObjects:int = objectsAsVector.length;
        for (i = 0; i < numPreviewObjects; i++) {
            objectPreview = new ObjectPreview (objectsAsVector [i], assetsManager);
            objectsContainer.addChild (objectPreview);
            curRow = Math.floor (i / NUM_ELEMENTS_IN_ROW);
            curColumn = i - curRow * NUM_ELEMENTS_IN_ROW;
            objectPreview.x = ELEMENTS_START_X + curColumn * ELEMENT_DISTANCE_X;
            objectPreview.y = ELEMENTS_START_Y + curRow * ELEMENT_DISTANCE_Y;
            objectPreview.containerWidth = ELEMENT_WIDTH;
            objectPreview.containerHeight = ELEMENT_HEIGHT;
            objectPreview.addEventListener(MouseEvent.CLICK, clickListener_objectPreView);
        }
        scpObjects.source = objectsContainer;
    }

    private function clickListener_objectPreView (event:MouseEvent):void {
        var objectPreView:ObjectPreview = ObjectPreview (event.currentTarget);
        uiController.currentEditingAsset = objectPreView.objectData;
    }

    private function changeListener_cbxObjectsType (event:Event):void {
        uiController.selectCurrentEditingAssetType(String (cbxObjectsType.selectedItem.data));
    }

    private function changeListener_listObjectParts (event:Event):void {
        uiController.currentEditingAssetPart = PartData (listObjectParts.selectedItem.data);
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

    private function changeListener_chbShotable (event:Event):void {
        //
    }

    private function changeListener_chbWalkable (event:Event):void {
        //
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_ASSETS) {
            //Формируем новый список ассетов при переключении контроллера в режим редактирования ассетов.
            uiController.selectCurrentEditingAssetType(String (cbxObjectsType.getItemAt(0).data));
        }
    }

    private function assetWasChangedListener(event:EditObjectDataEvent):void {
        updateData();
    }

    private function assetPartWasChangedListener(event:EditPartDataEvent):void {
        updateData();
    }
}
}
