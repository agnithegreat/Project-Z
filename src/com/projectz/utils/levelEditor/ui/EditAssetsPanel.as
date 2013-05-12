/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 0:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.containers.ScrollPane;

import fl.controls.ComboBox;

import flash.display.MovieClip;

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
//        mcAddEnemyPanel = Sprite(getElement("mcAddEnemyPanel"));
//        listAddEnemy = List(getElement("listAddEnemy", mcAddEnemyPanel));
//        nstNumEnemies = NumericStepper(getElement("nstNumEnemies", mcAddEnemyPanel));
//        listGenerators = List(getElement("listGenerators"));
//        listWaves = List(getElement("listWaves"));
//        listEnemies = List(getElement("listEnemies"));
//        cbxPaths = ComboBox(getElement("cbxPaths"));
//        tfX = TextField(getElement("tfX"));
//        tfY = TextField(getElement("tfY"));
//        btnAddGenerator = new ButtonWithText(mc ["btnAddGenerator"]);
//        btnRemoveGenerator = new ButtonWithText(mc ["btnRemoveGenerator"]);
//        btnAddWave = new ButtonWithText(mc ["btnAddWave"]);
//        btnRemoveWave = new ButtonWithText(mc ["btnRemoveWave"]);
//        btnAddEnemy = new ButtonWithText(mc ["btnAddEnemy"]);
//        btnRemoveEnemy = new ButtonWithText(mc ["btnRemoveEnemy"]);
//        nstTime = NumericStepper(getElement("nstTime"));
//        nstDelay = NumericStepper(getElement("nstDelay"));
//        nstTime.minimum = 0;
//        nstTime.maximum = 1000;
//        nstDelay.minimum = 0;
//        nstDelay.maximum = 1000;

        //Отключаем фокус для компонентов:
//        listAddEnemy.focusEnabled = false;
//        nstNumEnemies.focusEnabled = false;
//        listGenerators.focusEnabled = false;
//        listWaves.focusEnabled = false;
//        listEnemies.focusEnabled = false;
//        cbxPaths.focusEnabled = false;
//        nstTime.focusEnabled = false;
//        nstDelay.focusEnabled = false;

        //Устанавливаем тексты:
//        btnAddGenerator.text = "Добавить";
//        btnRemoveGenerator.text = "Удалить";
//        btnAddWave.text = "Добавить";
//        btnRemoveWave.text = "Удалить";
//        btnAddEnemy.text = "Добавить";
//        btnRemoveEnemy.text = "Удалить";
//        tfX.text = "";
//        tfY.text = "";

        //Добавляем слушатели для кнопок:
//        btnAddGenerator.addEventListener(MouseEvent.CLICK, clickListener);
//        btnRemoveGenerator.addEventListener(MouseEvent.CLICK, clickListener);
//        btnAddWave.addEventListener(MouseEvent.CLICK, clickListener);
//        btnRemoveWave.addEventListener(MouseEvent.CLICK, clickListener);
//        btnAddEnemy.addEventListener(MouseEvent.CLICK, clickListener);
//        btnRemoveEnemy.addEventListener(MouseEvent.CLICK, clickListener);

//        mcAddEnemyPanel.visible = false;//убираем видимость панели с врагами.

        //Формируем список врагов:
//        var dataProvider:DataProvider = new DataProvider();
//        var objects:Dictionary = objectStorage.getType(ObjectType.ENEMY);
//        var object:ObjectData;
//        for each (object in objects) {
//            var objectData:ObjectData = ObjectData(object);
//            dataProvider.addItem({label: objectData.name, data: objectData.name});
//        }
//        dataProvider.sortOn("name");
//        listAddEnemy.dataProvider = dataProvider;

        //Добавляем слушателей для компонентов:
//        listAddEnemy.addEventListener(Event.CHANGE, changeListener_listAddEnemy);
//        listGenerators.addEventListener(Event.CHANGE, changeListener_listGenerators);
//        listWaves.addEventListener(Event.CHANGE, changeListener_listWaves);
//        cbxPaths.addEventListener(Event.CHANGE, changeListener_cbxPaths);
//        nstTime.addEventListener(Event.CHANGE, changeListener_nstTime);
//        nstDelay.addEventListener(Event.CHANGE, changeListener_nstDelay);
    }
}
}
