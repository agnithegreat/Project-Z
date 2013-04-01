/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 12:40
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.events.MouseEvent;
import flash.text.TextField;

public class LevelEditorUI extends GraphicStorage {

    private var uiController:UIController;
    private var model:Field;
    private var objectStorage:ObjectsStorage;
    private var levelsStorage:LevelStorage;

    //панели:
    private var infoPanel:InfoPanel;
    private var editObjectsPanel:EditObjectsPanel;
    private var editPathsPanel:EditPathsPanel;

    private var panels:Vector.<IPanel> = new <IPanel>[];

    //табы:
    private var btnTabEditObjects:ButtonWithText;
    private var btnTabEditPaths:ButtonWithText;
    private var btnTabEditGenerators:ButtonWithText;
    private var btnTabEditDefenderZones:ButtonWithText;
    private var btnTabEditLevels:ButtonWithText;
    private var btnTabEditSettings:ButtonWithText;

    private var tabs:Vector.<ButtonWithText> = new <ButtonWithText>[];

    //информационные сообщения:
    private var tfInfo:TextField;

    public function LevelEditorUI(uiController:UIController, model:Field, objectStorage:ObjectsStorage, levelsStorage:LevelStorage) {
        this.uiController = uiController;
        this.model = model;
        this.objectStorage = objectStorage;
        this.levelsStorage = levelsStorage;

        super(new mcLevelEditorPanel);

        uiController.addEventListener(SelectModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);

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
        infoPanel = new InfoPanel(mc["mcInfoPanel"], uiController);
        editObjectsPanel = new EditObjectsPanel(mc["mcEditObjectsPanel"], uiController, objectStorage);
        editPathsPanel = new EditPathsPanel(mc["mcEditPathsPanel"], model, uiController);

        panels.push(editObjectsPanel);
        panels.push(editPathsPanel);

        //табы:
        btnTabEditObjects = new ButtonWithText(mc["mcBtnTab1"]);
        btnTabEditPaths = new ButtonWithText(mc["mcBtnTab2"]);
        btnTabEditGenerators = new ButtonWithText(mc["mcBtnTab3"]);
        btnTabEditDefenderZones = new ButtonWithText(mc["mcBtnTab4"]);
        btnTabEditLevels = new ButtonWithText(mc["mcBtnTab5"]);
        btnTabEditSettings = new ButtonWithText(mc["mcBtnTab6"]);
        var btn7:ButtonWithText = new ButtonWithText(mc["mcBtnTab7"]);
        var btn8:ButtonWithText = new ButtonWithText(mc["mcBtnTab8"]);

        btn7.enable = false;
        btn8.enable = false;

        btn7.text = "---";
        btn8.text = "---";
//        mc["mcBtnTab5"].visible = false;//убираем видимость неиспользованных (запасных) табов:

        tabs.push(btnTabEditObjects);
        tabs.push(btnTabEditPaths);
        tabs.push(btnTabEditGenerators);
        tabs.push(btnTabEditDefenderZones);
        tabs.push(btnTabEditLevels);
        tabs.push(btnTabEditSettings);

        //информационные сообщения:
        tfInfo = TextField(getElement("tfInfo"));

        //добавляем тексты:

        btnTabEditObjects.text = "редактор объектов";
        btnTabEditPaths.text = "редактор путей";
        btnTabEditGenerators.text = "редактор генераторов";
        btnTabEditDefenderZones.text = "редактор зон защитников";
        btnTabEditLevels.text = "редактор уровней";
        btnTabEditSettings.text = "настройки";

        //добавляем слушатели:
        btnTabEditObjects.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditPaths.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditGenerators.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditDefenderZones.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditLevels.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditSettings.addEventListener(MouseEvent.CLICK, clickListener);
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

    private function showPanel(panel:IPanel):void {
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

    private function outputInfo(value:String = null):void {
        if (value == null) {
            value = "";
        }
        tfInfo.text = value;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectUIControllerModeListener(event:SelectModeEvent):void {
        switch (event.mode) {
            case (UIControllerMode.EDIT_OBJECTS):
                selectTab(btnTabEditObjects);
                showPanel(editObjectsPanel);
                outputInfo(
                        "Кнопки:" +
                                "\n" +
                                "1. SHIFT + клик по карте = многократная установка предмета." +
                                "\n" +
                                "2. ESC/DELETE + клик по карте = удаление объекта."
                );
                break;
            case (UIControllerMode.EDIT_PATHS):
                selectTab(btnTabEditPaths);
                showPanel(editPathsPanel);
                outputInfo("Выберете путь из списка. Установите режим редактирования. Кликами по карте редактируйте выбранный путь.");
                break;
            case (UIControllerMode.EDIT_GENERATORS):
                selectTab(btnTabEditGenerators);
                showPanel(null);
                outputInfo("Редактирование генараторов времено не работает.");
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
            case (UIControllerMode.EDIT_SETTINGS):
                selectTab(btnTabEditSettings);
                showPanel(null);
                outputInfo("Редактирование настроек времено не работает.");
                break;
        }
    }

    private function clickListener(event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnTabEditObjects):
                uiController.mode = UIControllerMode.EDIT_OBJECTS;
                break;
            case (btnTabEditPaths):
                uiController.mode = UIControllerMode.EDIT_PATHS;
                break;
            case (btnTabEditGenerators):
                uiController.mode = UIControllerMode.EDIT_GENERATORS;
                break;
            case (btnTabEditDefenderZones):
                uiController.mode = UIControllerMode.EDIT_ZONES;
                break;
            case (btnTabEditLevels):
                uiController.mode = UIControllerMode.EDIT_LEVELS;
                break;
            case (btnTabEditSettings):
                uiController.mode = UIControllerMode.EDIT_SETTINGS;
                break;
        }
    }

}
}
