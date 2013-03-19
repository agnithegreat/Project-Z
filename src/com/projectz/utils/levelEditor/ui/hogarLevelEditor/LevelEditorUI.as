/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 12:40
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.hogarLevelEditor {

import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.controller.LevelEditorMode;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class LevelEditorUI extends GraphicStorage {

    private var controller:LevelEditorController;

    //панели:
    private var infoPanel:InfoPanel;
    private var editObjectsPanel:EditObjectsPanel;
    private var editPathsPanel:EditPathsPanel;

    private var panels:Vector.<IPanel> = new <IPanel>[];

    //табы:
    private var btnTabEditObjects:ButtonWithText;
    private var btnTabEditPaths:ButtonWithText;
    private var btnTabEditDefenderZones:ButtonWithText;
    private var btnTabEditLevels:ButtonWithText;

    private var tabs:Vector.<ButtonWithText> = new <ButtonWithText>[];

    //информационные сообщения:
    private var tfInfo:TextField;

    public function LevelEditorUI() {
        controller = LevelEditorController.getInstance();

        super(new mcLevelEditorPanel);

        LevelEditorController.getInstance().addEventListener(LevelEditorEvent.SELECT_EDITOR_MODE, selectModeListener);

        outputInfo("Добро пожаловать в редактор уровней! Выберите одну из вкладок сверху, чтобы задать режим работы редактора.");
        showPanel(null);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //инициализируем графические элементы (парсим графику):

        //панели:
        infoPanel = new InfoPanel (mc["mcInfoPanel"]);
        editObjectsPanel = new EditObjectsPanel(mc["mcEditObjectsPanel"], controller);
        editPathsPanel = new EditPathsPanel(mc["mcEditPathsPanel"]);

        panels.push(editObjectsPanel);
        panels.push(editPathsPanel);

        //табы:
        btnTabEditObjects = new ButtonWithText(mc["mcBtnTab1"]);
        btnTabEditPaths = new ButtonWithText(mc["mcBtnTab2"]);
        btnTabEditDefenderZones = new ButtonWithText(mc["mcBtnTab3"]);
        btnTabEditLevels = new ButtonWithText(mc["mcBtnTab4"]);
        mc["mcBtnTab5"].visible = false;//убираем видимость неиспользованных (запасных) табов:

        tabs.push(btnTabEditObjects);
        tabs.push(btnTabEditPaths);
        tabs.push(btnTabEditDefenderZones);
        tabs.push(btnTabEditLevels);

        //информационные сообщения:
        tfInfo = TextField (getElement("tfInfo"));

        //добавляем тексты:

        btnTabEditObjects.text = "редактор объектов";
        btnTabEditPaths.text = "редактор путей";
        btnTabEditDefenderZones.text = "редактор зон защитников";
        btnTabEditLevels.text = "редактор уровней";

        //добавляем слушатели:
        btnTabEditObjects.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditPaths.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditDefenderZones.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditLevels.addEventListener(MouseEvent.CLICK, clickListener);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////                                                                                                                             s

    private function selectTab(tab:ButtonWithText):void {
        for (var i:int = 0; i < tabs.length; i++) {
            tabs [i].selected = (tabs [i] == tab);
//            trace ("tabs [i].selected = " + tabs [i].selected);
        }
    }

    private function showPanel (panel:IPanel):void {
        for (var i:int; i < panels.length; i++) {
            var _panel:IPanel = panels [i];
            if (_panel == panel) {
                _panel.show();
            }
            else {
                _panel.hide();
            }
        }
    }

    private function outputInfo (value:String = null):void {
        if (value == null) {
            value = "";
        }
        tfInfo.text = value;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectModeListener (event:Event):void {
        switch (controller.mode) {
            case (LevelEditorMode.EDIT_OBJECTS):
                selectTab(btnTabEditObjects);
                showPanel(editObjectsPanel);
                outputInfo(
                        "1. Добавление объектов: Нажмите кнопку 'добавление'. Выберите объект в списке объектов. Нажмите на клекту поля." +
                        "\n" +
                        "2. Удаление обекта: Нажмите кнопку 'удаление'. Нажмите на клекту поля."
                );
                break;
            case (LevelEditorMode.EDIT_PATHS):
                selectTab(btnTabEditPaths);
                showPanel(editPathsPanel);
                break;
            case (LevelEditorMode.EDIT_ZONES):
                selectTab(btnTabEditDefenderZones);
                showPanel(null);
                break;
            case (LevelEditorMode.EDIT_LEVELS):
                selectTab(btnTabEditLevels);
                showPanel(null);
                break;
        }
    }

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnTabEditObjects):
                controller.mode = LevelEditorMode.EDIT_OBJECTS;
                break;
            case (btnTabEditPaths):
                controller.mode = LevelEditorMode.EDIT_PATHS;
                break;
            case (btnTabEditDefenderZones):
                controller.mode = LevelEditorMode.EDIT_ZONES;
                break;
            case (btnTabEditLevels):
                controller.mode = LevelEditorMode.EDIT_LEVELS;
                break;
        }
    }

}
}
