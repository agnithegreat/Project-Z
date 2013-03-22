/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 19:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.hogarLevelEditor {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.EditPathMode;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectEditPathModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;
import com.projectz.utils.levelEditor.model.Field;

import fl.controls.ColorPicker;

import fl.controls.ComboBox;

import fl.controls.List;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class EditPathsPanel extends GraphicStorage implements IPanel {

    private var model:Field;
    private var uiController:UIController;

    private var listPaths:List;
    private var cbxPoints:ComboBox;
    private var clpPathColor:ColorPicker;
    private var tfID:TextField;

    private var btnAddPathPoint:ButtonWithText;
    private var btnRemovePathPoint:ButtonWithText;
    private var btnSave:ButtonWithText;
    private var btnDelete:ButtonWithText;

    public function EditPathsPanel(mc:MovieClip, model:Field,  uiController:UIController) {
        this.model = model;
        this.uiController = uiController;
        super (mc);

        uiController.addEventListener(SelectModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(SelectPathEvent.SELECT_PATH, selectPathListener);
        uiController.addEventListener(SelectEditPathModeEvent.SELECT_EDIT_PATH_MODE, selectEditPathModeListener);
    }

    public function show():void {
        visible = true;
    }

    public function hide():void {
        visible = false;
    }

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        listPaths = List (getElement("listPaths"));
        cbxPoints = ComboBox (getElement("cbxPoints"));
        clpPathColor = ColorPicker (getElement("clpPathColor"));
        tfID = TextField (getElement("tfID"));

        listPaths.addEventListener (Event.CHANGE, changeListener_listPaths);
        cbxPoints.addEventListener (Event.CHANGE, changeListener_cbxPoints);
        clpPathColor.addEventListener (Event.CHANGE, changeListener_clpPathColor);

        //создание кнопок:
        btnAddPathPoint = new ButtonWithText(mc["btnAddPathPoint"]);
        btnRemovePathPoint = new ButtonWithText(mc["btnRemovePathPoint"]);
        btnSave = new ButtonWithText(mc["btnSave"]);
        btnDelete = new ButtonWithText(mc["btnDelete"]);

        btnAddPathPoint.selected = (uiController.editPathMode == EditPathMode.ADD_POINTS);
        btnRemovePathPoint.selected = (uiController.editPathMode == EditPathMode.REMOVE_POINTS);

        btnAddPathPoint.text = "Добавление";
        btnRemovePathPoint.text = "Удаление";
        btnSave.text = "Сохранить";
        btnDelete.text = "Удалить";

        btnAddPathPoint.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemovePathPoint.addEventListener(MouseEvent.CLICK, clickListener);
        btnSave.addEventListener(MouseEvent.CLICK, clickListener);
        btnDelete.addEventListener(MouseEvent.CLICK, clickListener);
    }

    private function initPathList (paths:Vector.<PathData>):void {
        var dataProvider:DataProvider = new DataProvider();
        for (var i:int = 0; i < paths.length; i++) {
            var pathData:PathData = paths [i];
            dataProvider.addItem({label:("path" + pathData.id),data:pathData});
        }
        listPaths.dataProvider = dataProvider;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnAddPathPoint):
                uiController.editPathMode = EditPathMode.ADD_POINTS;
                break;
            case (btnRemovePathPoint):
                uiController.editPathMode = EditPathMode.REMOVE_POINTS;
                break;
            case (btnSave):
                uiController.save();
                break;
            case (btnDelete):
                uiController.clearAllObjects();
                break;
        }
    }

    private function selectPathListener (event:SelectPathEvent):void {
        var pathData:PathData = event.pathData;
        //устанавливаем позицию листа для выбранноо пути:
        var dataProvider:DataProvider = listPaths.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.pathData) {
                listPaths.selectedItem = dataProviderItem;
//                trace ("select path = " + event.pathData.id);
                break;
            }
        }

        if (pathData) {
            //устанавливаем цвет в колорпикере:
            clpPathColor.selectedColor = pathData.color;
            tfID.text = String (pathData.id);
        }

    }

    private function selectUIControllerModeListener (event:SelectModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_PATHS) {
            if (model.levelData) {
                initPathList (model.levelData.paths);
            }
        }
    }

    private function selectEditPathModeListener (event:SelectEditPathModeEvent):void {
        if (event.mode == EditPathMode.ADD_POINTS) {
            btnAddPathPoint.selected = true;
            btnRemovePathPoint.selected = false;
        }
        else if (event.mode == EditPathMode.REMOVE_POINTS) {
            btnAddPathPoint.selected = false;
            btnRemovePathPoint.selected = true;
        }
    }

    private function changeListener_listPaths (event:Event):void {
        uiController.currentEditingPath = PathData (listPaths.selectedItem.data);
    }

    private function changeListener_cbxPoints (event:Event):void {
//        uiController.selectCurrentObject(ObjectData (listObjects.selectedItem.data));
    }

    private function changeListener_clpPathColor (event:Event):void {
//        uiController.selectCurrentObject(ObjectData (listObjects.selectedItem.data));
    }
}
}
