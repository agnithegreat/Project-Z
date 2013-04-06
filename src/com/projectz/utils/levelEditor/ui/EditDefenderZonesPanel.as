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
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectEditDefenderZonesModeEvent;

import fl.controls.CheckBox;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

public class EditDefenderZonesPanel extends BasicPanel {

    private var uiController:UIController;

    private var chxAreaMode:CheckBox;

    private var btnAddDefenderZonesPoint:ButtonWithText;
    private var btnRemoveDefenderZonesPoint:ButtonWithText;
    private var btnClearAll:ButtonWithText;

    public function EditDefenderZonesPanel(mc:MovieClip, uiController:UIController) {
        this.uiController = uiController;
        super(mc);

        uiController.addEventListener(SelectEditDefenderZonesModeEvent.SELECT_EDIT_DEFENDERS_ZONES_MODE, selectEditDefenderZonesModeListener);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements():void {
        super.initGraphicElements();

        chxAreaMode = CheckBox(getElement("chxAreaMode"));

        chxAreaMode.addEventListener(Event.CHANGE, changeListener_chxAreaMode);

        chxAreaMode.focusEnabled = false;

        //создание кнопок:
        btnAddDefenderZonesPoint = new ButtonWithText(mc["btnAddDefenderZonesPoint"]);
        btnRemoveDefenderZonesPoint = new ButtonWithText(mc["btnRemoveDefenderZonesPoint"]);
        btnClearAll = new ButtonWithText(mc["btnClearAll"]);

        btnAddDefenderZonesPoint.selected = (uiController.editPathMode == EditMode.ADD_POINTS);
        btnRemoveDefenderZonesPoint.selected = (uiController.editPathMode == EditMode.REMOVE_POINTS);

        btnAddDefenderZonesPoint.text = "Добавление";
        btnRemoveDefenderZonesPoint.text = "Удаление";
        btnClearAll.text = "Очистить";

        btnAddDefenderZonesPoint.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveDefenderZonesPoint.addEventListener(MouseEvent.CLICK, clickListener);
        btnClearAll.addEventListener(MouseEvent.CLICK, clickListener);

    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener(event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnAddDefenderZonesPoint):
                uiController.editDefenderZonesMode = EditMode.ADD_POINTS;
                break;
            case (btnRemoveDefenderZonesPoint):
                uiController.editDefenderZonesMode = EditMode.REMOVE_POINTS;
                break;
            case (btnClearAll):
                uiController.clearAllDefenderZonesPoint();
                break;
        }
    }

    private function selectEditDefenderZonesModeListener(event:SelectEditDefenderZonesModeEvent):void {
        if (event.mode == EditMode.ADD_POINTS) {
            btnAddDefenderZonesPoint.selected = true;
            btnRemoveDefenderZonesPoint.selected = false;
        }
        else if (event.mode == EditMode.REMOVE_POINTS) {
            btnAddDefenderZonesPoint.selected = false;
            btnRemoveDefenderZonesPoint.selected = true;
        }
    }

    private function changeListener_chxAreaMode(event:Event):void {
        uiController.editDefenderZonesAreaMode = chxAreaMode.selected;
    }

}
}
