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
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.events.MouseEvent;
import flash.text.TextField;

import starling.events.Event;

public class LevelEditorUI extends GraphicStorage {

    private var uiController:UIController;
    private var objectStorage:ObjectsStorage;

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

    public function LevelEditorUI(uiController:UIController, objectStorage:ObjectsStorage) {
        this.uiController = uiController;
        this.objectStorage = objectStorage;

        super(new mcLevelEditorPanel);

        uiController.addEventListener(LevelEditorEvent.SELECT_EDITOR_MODE, selectModeListener);

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
        infoPanel = new InfoPanel (mc["mcInfoPanel"], uiController);
        editObjectsPanel = new EditObjectsPanel(mc["mcEditObjectsPanel"], uiController, objectStorage);
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
        switch (uiController.mode) {
            case (UIControllerMode.EDIT_OBJECTS):
                selectTab(btnTabEditObjects);
                showPanel(editObjectsPanel);
                outputInfo(
                        "Кнопки:" +
                        "\n" +
                        "SHIFT + клик по карте = многократная установка предмета." +
                        "\n" +
                        "ESC/DELETE + клик по карте = удаление объекта."
                );
                break;
            case (UIControllerMode.EDIT_PATHS):
                selectTab(btnTabEditPaths);
                showPanel(editPathsPanel);
                outputInfo("Редактирование путей времено не работает.");
                break;
            case (UIControllerMode.EDIT_ZONES):
                selectTab(btnTabEditDefenderZones);
                showPanel(null);
                outputInfo("Редактирование зон защитников времено не работает.");
                break;
            case (UIControllerMode.EDIT_LEVELS):
                selectTab(btnTabEditLevels);
                showPanel(null);
                outputInfo("Редактирование уровней времено не работает.");
                break;
        }
    }

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnTabEditObjects):
                uiController.mode = UIControllerMode.EDIT_OBJECTS;
                break;
            case (btnTabEditPaths):
                uiController.mode = UIControllerMode.EDIT_PATHS;
                break;
            case (btnTabEditDefenderZones):
                uiController.mode = UIControllerMode.EDIT_ZONES;
                break;
            case (btnTabEditLevels):
                uiController.mode = UIControllerMode.EDIT_LEVELS;
                break;
        }
    }

}
}
