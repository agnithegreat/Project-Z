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
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.ui.EditSettingsPanel;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.events.MouseEvent;
import flash.text.TextField;

import starling.utils.AssetManager;

/**
 * UI для редактора уровней.
 */
public class LevelEditorUI extends GraphicStorage {

    private var uiController:UIController;//Ссылка на контроллер.
    private var model:Field;//Ссылка на модель.
    private var objectStorage:ObjectsStorage;//Хранилище ассетов.
    private var levelsStorage:LevelStorage;//Хранилище всех уровней игры.
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    //панели:
    private var infoPanel:InfoPanel;
    private var editObjectsPanel:EditObjectsPanel;
    private var editPathsPanel:EditPathsPanel;
    private var editGeneratorsPanel:EditGeneratorsPanel;
    private var editDefenderPositionsPanel:EditDefenderPositionsPanel;
    private var editAssetsPanel:EditAssetsPanel;
    private var editUnitsPanel:EditUnitsPanel;
    private var editLevelsPanel:EditLevelsPanel;
    private var editSettingsPanel:EditSettingsPanel;

    private var panels:Vector.<IPanel> = new <IPanel>[];

    //табы:
    private var btnTabEditObjects:ButtonWithText;
    private var btnTabEditPaths:ButtonWithText;
    private var btnTabEditGenerators:ButtonWithText;
    private var btnTabEditDefenderZones:ButtonWithText;
    private var btnTabEditAssets:ButtonWithText;
    private var btnTabEditUnits:ButtonWithText;
    private var btnTabEditLevels:ButtonWithText;
    private var btnTabEditSettings:ButtonWithText;
    private var btnSave:ButtonWithText;

    private var tabs:Vector.<ButtonWithText> = new <ButtonWithText>[];

    //информационные сообщения:
    private var tfInfo:TextField;

    /**
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param objectStorage Хранилище всех игровых ассетов.
     * @param levelsStorage Хранилище всех уровней игры.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function LevelEditorUI(uiController:UIController, model:Field, objectStorage:ObjectsStorage, levelsStorage:LevelStorage, assetsManager:AssetManager) {
        this.uiController = uiController;
        this.model = model;
        this.objectStorage = objectStorage;
        this.levelsStorage = levelsStorage;
        this.assetsManager = assetsManager;

        super(new mcLevelEditorPanel);

        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);

        outputInfo("Добро пожаловать в редактор уровней! Выберите одну из вкладок сверху, чтобы задать режим работы редактора.");
        showPanel(null);
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //инициализируем графические элементы:

        //панели:
        infoPanel = new InfoPanel(mc["mcInfoPanel"], uiController);
        editObjectsPanel = new EditObjectsPanel(mc["mcEditObjectsPanel"], uiController, objectStorage, assetsManager);
        editPathsPanel = new EditPathsPanel(mc["mcEditPathsPanel"], model, uiController);
        editGeneratorsPanel = new EditGeneratorsPanel(mc["mcEditGeneratorsPanel"], model, uiController, objectStorage, assetsManager);
        editDefenderPositionsPanel = new EditDefenderPositionsPanel(mc["mcEditDefenderPositionsPanel"], model, uiController);
        editAssetsPanel = new EditAssetsPanel(mc["mcEditAssetsPanel"], model, uiController, objectStorage, assetsManager);
        editUnitsPanel = new EditUnitsPanel(mc["mcEditUnitsPanel"], model, uiController, objectStorage, assetsManager);

        panels.push(editObjectsPanel);
        panels.push(editPathsPanel);
        panels.push(editGeneratorsPanel);
        panels.push(editDefenderPositionsPanel);
        panels.push(editAssetsPanel);
        panels.push(editUnitsPanel);

        //табы:
        btnTabEditObjects = new ButtonWithText(mc["mcBtnTab1"]);
        btnTabEditPaths = new ButtonWithText(mc["mcBtnTab2"]);
        btnTabEditGenerators = new ButtonWithText(mc["mcBtnTab3"]);
        btnTabEditDefenderZones = new ButtonWithText(mc["mcBtnTab4"]);
        btnTabEditAssets = new ButtonWithText(mc["mcBtnTab5"]);
        btnTabEditUnits = new ButtonWithText(mc["mcBtnTab6"]);
        btnTabEditLevels = new ButtonWithText(mc["mcBtnTab7"]);
        btnTabEditSettings = new ButtonWithText(mc["mcBtnTab8"]);
        btnSave = new ButtonWithText(mc["btnSave"]);

        tabs.push(btnTabEditObjects);
        tabs.push(btnTabEditPaths);
        tabs.push(btnTabEditGenerators);
        tabs.push(btnTabEditDefenderZones);
        tabs.push(btnTabEditAssets);
        tabs.push(btnTabEditSettings);
        tabs.push(btnTabEditLevels);
        tabs.push(btnTabEditSettings);

        //информационные сообщения:
        tfInfo = TextField(getElement("tfInfo"));

        //добавляем тексты:

        btnTabEditObjects.text = "редактор объектов";
        btnTabEditPaths.text = "редактор путей";
        btnTabEditGenerators.text = "редактор генераторов";
        btnTabEditDefenderZones.text = "редактор зон защитников";
        btnTabEditAssets.text = "редактор ресурсов";
        btnTabEditUnits.text = "редактор юнитов";
        btnTabEditLevels.text = "редактор уровней";
        btnTabEditSettings.text = "настройки";
        btnSave.text = "сохранить";

        //добавляем слушатели:
        btnTabEditObjects.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditPaths.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditGenerators.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditDefenderZones.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditAssets.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditUnits.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditLevels.addEventListener(MouseEvent.CLICK, clickListener);
        btnTabEditSettings.addEventListener(MouseEvent.CLICK, clickListener);
        btnSave.addEventListener(MouseEvent.CLICK, clickListener);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////                                                                                                                             s

    /**
     * Выделение таба и снятие выделения с остальных табов.
     * @param tab Таб для выделения.
     */
    private function selectTab(tab:ButtonWithText):void {
        for (var i:int = 0; i < tabs.length; i++) {
            tabs [i].selected = (tabs [i] == tab);
//            trace ("tabs [i].selected = " + tabs [i].selected);
        }
    }

    /**
     * Отображение выбранной панели и скрытие остальных панелей.
     * @param panel Панель для отображения.
     */
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

    /**
     * Отображение текстового сообщения в инормационном текстовом поле.
     * @param value Текст сообщения.
     */
    private function outputInfo(value:String = null):void {
        if (value == null) {
            value = "";
        }
        tfInfo.text = value;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        switch (event.mode) {
            case (UIControllerMode.EDIT_OBJECTS):
                selectTab(btnTabEditObjects);
                showPanel(editObjectsPanel);
                outputInfo(
                        "1. ДОБАВЛЕНИЕ: Выберете тип объекта. " +
                        "Выберите объект из списка. " +
                        "Укажите место на карте, куда его следует поместить. " +
                        "SHIFT + клик по карте = многократная установка объекта." +
                        "\n" +
                        "2. ПЕРЕМЕЩЕНИЕ: Кликните по объекту на карте. Укажите место, куда его следует поместить." +
                        "\n" +
                        "3. УДАЛЕНИЕ: ESC/DELETE + клик по карте = удаление объекта."
                );
                break;
            case (UIControllerMode.EDIT_PATHS):
                selectTab(btnTabEditPaths);
                showPanel(editPathsPanel);
                outputInfo(
                        "Выберете путь из списка. " +
                        "Установите режим редактирования (добавление или удаление). " +
                        "Кликами по карте редактируйте выбранный путь." +
                        "\n" +
                        "Если включена опция 'редактирование областей', " +
                        "то редактируются прямоугольные участки между двумя указанными точками."
                );
                break;
            case (UIControllerMode.EDIT_GENERATORS):
                selectTab(btnTabEditGenerators);
                showPanel(editGeneratorsPanel);
                outputInfo(
                        "Редактирование генараторов, волн и стека каждой волны. " +
                        "Для указания позиции генератора выберите путь и кликните по карте в пределах этого пути."
                );
                break;
            case (UIControllerMode.EDIT_DEFENDER_POSITIONS):
                selectTab(btnTabEditDefenderZones);
                showPanel(editDefenderPositionsPanel);
                outputInfo(
                        "Выберете позицию защитника из списка. " +
                        "Установите режим редактирования (добавление, удаление, указание позиции). " +
                        "Кликами по карте редактируйте зону позиции защитника." +
                        "\n" +
                        "Если включена опция 'редактирование областей', " +
                        "то редактируются прямоугольные участки между двумя указанными точками."
                );
                break;
            case (UIControllerMode.EDIT_ASSETS):
                selectTab(btnTabEditAssets);
                showPanel(editAssetsPanel);
                outputInfo("Редактирование ресурсов времено не работает.");
                break;
            case (UIControllerMode.EDIT_UNITS):
                selectTab(btnTabEditUnits);
                showPanel(editUnitsPanel);
                outputInfo("Редактирование юнитов времено не работает.");
                break;
            case (UIControllerMode.EDIT_LEVELS):
                selectTab(btnTabEditLevels);
                showPanel(editLevelsPanel);
                outputInfo("Редактирование уровней времено не работает.");
                break;
            case (UIControllerMode.EDIT_SETTINGS):
                selectTab(btnTabEditSettings);
                showPanel(editSettingsPanel);
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
                uiController.mode = UIControllerMode.EDIT_DEFENDER_POSITIONS;
                break;
            case (btnTabEditAssets):
                uiController.mode = UIControllerMode.EDIT_ASSETS;
                break;
            case (btnTabEditUnits):
                uiController.mode = UIControllerMode.EDIT_UNITS;
                break;
            case (btnTabEditLevels):
                uiController.mode = UIControllerMode.EDIT_LEVELS;
                break;
            case (btnTabEditSettings):
                uiController.mode = UIControllerMode.EDIT_SETTINGS;
                break;
            case (btnSave):
                uiController.save();
                break;
        }
    }

}
}
