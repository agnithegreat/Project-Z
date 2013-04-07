/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.04.13
 * Time: 0:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.EditMode;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectEditDefenderPositionModeEvent;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent;

import fl.controls.CheckBox;
import fl.controls.List;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

public class EditDefenderPositionsPanel extends BasicPanel {

    private var model:Field;
    private var uiController:UIController;

    private var chxAreaMode:CheckBox;

    private var btnAddDefenderPositionPoints:ButtonWithText;
    private var btnRemoveDefenderPositionPoints:ButtonWithText;
    private var btnSetDefenderPositionPoint:ButtonWithText;
    private var listDefenderPositions:List;
    private var btnNew:ButtonWithText;
    private var btnDelete:ButtonWithText;

    public function EditDefenderPositionsPanel(mc:MovieClip, model:Field, uiController:UIController) {
        this.uiController = uiController;
        this.model = model;
        super(mc);

        model.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_ADDED, defenderPositionWasAddedListener);
        model.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_REMOVED, defenderPositionWasRemovedListener);
        uiController.addEventListener(SelectEditDefenderPositionModeEvent.SELECT_EDIT_DEFENDER_POSITION_MODE, selectEditDefenderPositionModeListener);
        uiController.addEventListener(SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION, selectDefenderPositionListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements():void {
        super.initGraphicElements();

        chxAreaMode = CheckBox(getElement("chxAreaMode"));
        listDefenderPositions = List(getElement("listDefenderPositions"));

        chxAreaMode.addEventListener(Event.CHANGE, changeListener_chxAreaMode);
        listDefenderPositions.addEventListener(Event.CHANGE, selectListener_listDefenderPositions);

        chxAreaMode.focusEnabled = false;
        listDefenderPositions.focusEnabled = false;

        //создание кнопок:
        btnAddDefenderPositionPoints = new ButtonWithText(mc["btnAddDefenderPositionPoints"]);
        btnRemoveDefenderPositionPoints = new ButtonWithText(mc["btnRemoveDefenderPositionPoints"]);
        btnSetDefenderPositionPoint = new ButtonWithText(mc["btnSetDefenderPositionPoint"]);
        btnNew = new ButtonWithText(mc["btnNew"]);
        btnDelete = new ButtonWithText(mc["btnDelete"]);


        btnAddDefenderPositionPoints.selected = (uiController.editDefenderZonesMode == EditMode.ADD_POINTS);
        btnRemoveDefenderPositionPoints.selected = (uiController.editDefenderZonesMode == EditMode.REMOVE_POINTS);
        btnSetDefenderPositionPoint.selected = (uiController.editDefenderZonesMode == EditMode.SET_POINT);

        btnAddDefenderPositionPoints.text = "Добавление";
        btnRemoveDefenderPositionPoints.text = "Удаление";
        btnSetDefenderPositionPoint.text = "Позиция";
        btnDelete.text = "<FONT size = '13'>Удалить зону<FONT>";
        btnNew.text = "<FONT size = '13'>Создать зону<FONT>";


        btnAddDefenderPositionPoints.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveDefenderPositionPoints.addEventListener(MouseEvent.CLICK, clickListener);
        btnSetDefenderPositionPoint.addEventListener(MouseEvent.CLICK, clickListener);
        btnNew.addEventListener(MouseEvent.CLICK, clickListener);
        btnDelete.addEventListener(MouseEvent.CLICK, clickListener);

    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function reInitDefenderPositionsList ():void {
        if (model.levelData) {
            //формируем список всех позиций защитников текущего уровня:
            initDefenderPositionsList(model.levelData.defenderPositions);

            //устанавливаем текущий редактируемый путь:
            var currentEditingDefenderPosition:DefenderPositionData;
            if (model.levelData.defenderPositions.length > 0) {
                currentEditingDefenderPosition = model.levelData.defenderPositions [0];
            }
            uiController.currentEditingDefenderPosition = currentEditingDefenderPosition;

        }
    }

    private function initDefenderPositionsList(defenderPositions:Vector.<DefenderPositionData>):void {
        var dataProvider:DataProvider = new DataProvider();
        for (var i:int = 0; i < defenderPositions.length; i++) {
            var defenderPositionData:DefenderPositionData = defenderPositions [i];
            dataProvider.addItem({label: ("position " + i), data: defenderPositionData});
        }
        listDefenderPositions.dataProvider = dataProvider;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener(event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnAddDefenderPositionPoints):
                uiController.editDefenderZonesMode = EditMode.ADD_POINTS;
                break;
            case (btnRemoveDefenderPositionPoints):
                uiController.editDefenderZonesMode = EditMode.REMOVE_POINTS;
                break;
            case (btnSetDefenderPositionPoint):
                uiController.editDefenderZonesMode = EditMode.SET_POINT;
                break;
            case (btnNew):
                uiController.addNewDefenderPosition();
                break;
            case (btnDelete):
                uiController.removeCurrentDefenderPosition();
                break;
        }
    }

    private function selectEditDefenderPositionModeListener(event:SelectEditDefenderPositionModeEvent):void {
        if (event.mode == EditMode.ADD_POINTS) {
            btnAddDefenderPositionPoints.selected = true;
            btnRemoveDefenderPositionPoints.selected = false;
            btnSetDefenderPositionPoint.selected = false;
        }
        else if (event.mode == EditMode.REMOVE_POINTS) {
            btnAddDefenderPositionPoints.selected = false;
            btnRemoveDefenderPositionPoints.selected = true;
            btnSetDefenderPositionPoint.selected = false;
        }
        else if (event.mode == EditMode.SET_POINT) {
            btnAddDefenderPositionPoints.selected = false;
            btnRemoveDefenderPositionPoints.selected = false;
            btnSetDefenderPositionPoint.selected = true;
        }
    }

    private function selectDefenderPositionListener (event:SelectDefenderPositionEvent):void {
        //устанавливаем позицию листа для выбраной позиции защитника:
        var dataProvider:DataProvider = listDefenderPositions.dataProvider;
        var defenderPositionData:DefenderPositionData = event.defenderPositionData;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == defenderPositionData) {
                listDefenderPositions.selectedItem = dataProviderItem;
                break;
            }
        }
    }

    private function changeListener_chxAreaMode(event:Event):void {
        uiController.editDefenderZonesAreaMode = chxAreaMode.selected;
    }

    private function selectListener_listDefenderPositions(event:Event):void {
        uiController.currentEditingDefenderPosition = listDefenderPositions.selectedItem.data;
    }

    private function defenderPositionWasAddedListener (event:EditDefenderPositionEvent):void {
        reInitDefenderPositionsList();
        uiController.currentEditingDefenderPosition = event.defenderPositionData;
    }

    private function defenderPositionWasRemovedListener (event:EditDefenderPositionEvent):void {
        reInitDefenderPositionsList();
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) {
            reInitDefenderPositionsList();
        }
    }

}
}
