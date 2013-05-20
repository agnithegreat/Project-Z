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
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEditingModeEvent;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent;

import fl.controls.CheckBox;
import fl.controls.List;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Панель редактора уровней для редактирования зон защитников.
 */
public class EditDefenderPositionsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).

    //Элементы ui:
    private var chbAreaMode:CheckBox;

    private var btnAddDefenderPositionPoints:ButtonWithText;
    private var btnRemoveDefenderPositionPoints:ButtonWithText;
    private var btnSetDefenderPositionPoint:ButtonWithText;
    private var listDefenderPositions:List;
    private var btnNew:ButtonWithText;
    private var btnDelete:ButtonWithText;

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     */
    public function EditDefenderPositionsPanel(mc:MovieClip, model:Field, uiController:UIController) {
        this.uiController = uiController;
        this.model = model;
        super(mc);

        model.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_ADDED, defenderPositionWasAddedListener);
        model.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_REMOVED, defenderPositionWasRemovedListener);
        uiController.addEventListener(SelectDefenderPositionEditingModeEvent.SELECT_DEFENDER_POSITION_EDITING_MODE, selectEditDefenderPositionModeListener);
        uiController.addEventListener(SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION, selectDefenderPositionListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //Инициализируем компоненты:
        chbAreaMode = CheckBox(getElement("chbAreaMode"));
        listDefenderPositions = List(getElement("listDefenderPositions"));

        //Отключаем фокус для компонентов:
        chbAreaMode.focusEnabled = false;
        listDefenderPositions.focusEnabled = false;

        //Добавляем слушателей для компонентов:
        chbAreaMode.addEventListener(Event.CHANGE, changeListener_chxAreaMode);
        listDefenderPositions.addEventListener(Event.CHANGE, selectListener_listDefenderPositions);

        //Создаём кнопки:
        btnAddDefenderPositionPoints = new ButtonWithText(mc["btnAddDefenderPositionPoints"]);
        btnRemoveDefenderPositionPoints = new ButtonWithText(mc["btnRemoveDefenderPositionPoints"]);
        btnSetDefenderPositionPoint = new ButtonWithText(mc["btnSetDefenderPositionPoint"]);
        btnNew = new ButtonWithText(mc["btnNew"]);
        btnDelete = new ButtonWithText(mc["btnDelete"]);

        //Устанавливаем выделение кнопок:
        btnAddDefenderPositionPoints.selected = (uiController.editDefenderPositionsMode == EditMode.ADD_POINTS);
        btnRemoveDefenderPositionPoints.selected = (uiController.editDefenderPositionsMode == EditMode.REMOVE_POINTS);
        btnSetDefenderPositionPoint.selected = (uiController.editDefenderPositionsMode == EditMode.SET_POINT);

        //Устанавливаем тексты на кнопках:
        btnAddDefenderPositionPoints.text = "Добавление";
        btnRemoveDefenderPositionPoints.text = "Удаление";
        btnSetDefenderPositionPoint.text = "Позиция";
        btnDelete.text = "<FONT size = '13'>Удалить зону<FONT>";
        btnNew.text = "<FONT size = '13'>Создать зону<FONT>";

        //Добавляем слушателей для кнопок:
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
            //Формируем список всех зон защитников текущего уровня:
            initDefenderPositionsList(model.levelData.defenderPositions);

            //Устанавливаем текущую выбранную зону защитников в контроллере, как первую зону в списке зон:
            var currentEditingDefenderPosition:DefenderPositionData;
            if (model.levelData.defenderPositions.length > 0) {
                currentEditingDefenderPosition = model.levelData.defenderPositions [0];
            }
            uiController.currentEditingDefenderPosition = currentEditingDefenderPosition;

        }
    }

    private function initDefenderPositionsList(defenderPositions:Vector.<DefenderPositionData>):void {
        //Формируем список всех зон защитников текущего уровня:
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
                uiController.editDefenderPositionsMode = EditMode.ADD_POINTS;
                break;
            case (btnRemoveDefenderPositionPoints):
                uiController.editDefenderPositionsMode = EditMode.REMOVE_POINTS;
                break;
            case (btnSetDefenderPositionPoint):
                uiController.editDefenderPositionsMode = EditMode.SET_POINT;
                break;
            case (btnNew):
                uiController.addNewDefenderPosition();
                break;
            case (btnDelete):
                uiController.removeCurrentDefenderPosition();
                break;
        }
    }

    private function selectEditDefenderPositionModeListener(event:SelectDefenderPositionEditingModeEvent):void {
        //Устанавливаем выделение кнопок в зависимости от установленного в контроллере режима редактирования:
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
        //Устанавливаем позицию листа для выбраной зоны защитника:
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
        //Устанавливаем режим редактирования зон защитников по двум точкам.
        uiController.editDefenderZonesAreaMode = chbAreaMode.selected;
    }

    private function selectListener_listDefenderPositions(event:Event):void {
        //Выбираем текущуую редактируемую зону защитника в контроллере.
        uiController.currentEditingDefenderPosition = listDefenderPositions.selectedItem.data;
    }

    private function defenderPositionWasAddedListener (event:EditDefenderPositionEvent):void {
        //Обрабатываем добавление новой зоны защитника:
        reInitDefenderPositionsList();//формируем новый список зон.
        uiController.currentEditingDefenderPosition = event.defenderPositionData;//устанавливаем новую зону в контроллере в качестве текущей редактируемой.
    }

    private function defenderPositionWasRemovedListener (event:EditDefenderPositionEvent):void {
        //Обрабатываем удаление зоны защитника:
        reInitDefenderPositionsList();
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) {
            //Формируем новый список зон при переключении контроллера в режим редактирования зон защитников.
            reInitDefenderPositionsList();
        }
    }

}
}
