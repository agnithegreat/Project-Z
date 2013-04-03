/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.04.13
 * Time: 20:59
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.controls.ComboBox;

import fl.controls.List;
import fl.controls.NumericStepper;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.Dictionary;

public class EditGeneratorsPanel extends BasicPanel {

    private var model:Field;
    private var uiController:UIController;
    private var objectStorage:ObjectsStorage;

    private var mcAddEnemyPanel:Sprite;
    private var listAddEnemy:List;
    private var listGenerators:List;
    private var listWaves:List;
    private var listEnemies:List;
    private var cbxPaths:ComboBox;
    private var tfX:TextField;
    private var tfY:TextField;
    private var btnAddGenerator:ButtonWithText;
    private var btnRemoveGenerator:ButtonWithText;
    private var btnAddWave:ButtonWithText;
    private var btnRemoveWave:ButtonWithText;
    private var btnAddEnemy:ButtonWithText;
    private var btnRemoveEnemy:ButtonWithText;
    private var nstTime:NumericStepper;
    private var nstDelay:NumericStepper;

    public function EditGeneratorsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage) {
        this.model = model;
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        super (mc);

        uiController.addEventListener(SelectModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_ADDED, generatorWasAddedListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_REMOVED, generatorWasRemovedListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_CHANGED, generatorWasChangedListener);
        model.addEventListener(EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED, generatorWaveWasChangedListener);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    override public function show ():void {
        super.show ();
        resetGeneratorsList ();
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements ():void {
        super.initGraphicElements ();

        mcAddEnemyPanel = Sprite (getElement ("mcAddEnemyPanel"));
        listAddEnemy = List (getElement ("listAddEnemy", mcAddEnemyPanel));
        listGenerators = List (getElement ("listGenerators"));
        listWaves = List (getElement ("listWaves"));
        listEnemies = List (getElement ("listEnemies"));
        cbxPaths = ComboBox (getElement ("cbxPaths"));
        tfX = TextField (getElement ("tfX"));
        tfY = TextField (getElement ("tfY"));
        btnAddGenerator = new ButtonWithText (mc ["btnAddGenerator"]);
        btnRemoveGenerator = new ButtonWithText (mc ["btnRemoveGenerator"]);
        btnAddWave = new ButtonWithText (mc ["btnAddWave"]);
        btnRemoveWave = new ButtonWithText (mc ["btnRemoveWave"]);
        btnAddEnemy = new ButtonWithText (mc ["btnAddEnemy"]);
        btnRemoveEnemy = new ButtonWithText (mc ["btnRemoveEnemy"]);
        nstTime = NumericStepper (getElement ("nstTime"));
        nstDelay = NumericStepper (getElement ("nstDelay"));

        btnAddGenerator.text = "Добавить";
        btnRemoveGenerator.text = "Удалить";
        btnAddWave.text = "Добавить";
        btnRemoveWave.text = "Удалить";
        btnAddEnemy.text = "Добавить";
        btnRemoveEnemy.text = "Удалить";

        //добавляем слушатели:
        btnAddGenerator.addEventListener (MouseEvent.CLICK, clickListener);
        btnRemoveGenerator.addEventListener (MouseEvent.CLICK, clickListener);
        btnAddWave.addEventListener (MouseEvent.CLICK, clickListener);
        btnRemoveWave.addEventListener (MouseEvent.CLICK, clickListener);
        btnAddEnemy.addEventListener (MouseEvent.CLICK, clickListener);
        btnRemoveEnemy.addEventListener (MouseEvent.CLICK, clickListener);

        mcAddEnemyPanel.visible = false;

        //формируем список врагов:
        var dataProvider:DataProvider = new DataProvider ();
        var objects: Dictionary = objectStorage.getType(ObjectData.ENEMY);
        var object: ObjectData;
        for each (object in objects) {
            var objectData:ObjectData = ObjectData (object);
            dataProvider.addItem({label:objectData.name,data:objectData.name});
        }
        dataProvider.sortOn("name");
        listAddEnemy.dataProvider = dataProvider;

        listAddEnemy.addEventListener(Event.CHANGE, changeListener_listAddEnemy);
        listGenerators.addEventListener(Event.CHANGE, changeListener_listGenerators);
        listWaves.addEventListener(Event.CHANGE, changeListener_listWaves);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function resetGeneratorsList ():void {
        initWavesList (null);
        initEnemiesList (null);
        var dataProvider:DataProvider = new DataProvider();
        if (model.levelData) {
            var generators:Vector.<GeneratorData> = model.levelData.generators;
            var numGenerators:int = generators.length;
            for (var i:int = 0; i < numGenerators; i++) {
                var generatorData:GeneratorData = generators [i];
                dataProvider.addItem({label: ("generator " + i), data: generatorData});
            }
        }
        listGenerators.dataProvider = dataProvider;
    }

    private function initWavesList (generatorData:GeneratorData):void {
        var waveIndex:int = -1;
        if (listWaves.selectedItem) {
            waveIndex = listWaves.selectedIndex;
        }
        var dataProvider:DataProvider = new DataProvider();
        if (generatorData) {
            var waves:Vector.<GeneratorWaveData> = generatorData.waves;
            var numWaves:int = waves.length;
            for (var i:int = 0; i < numWaves; i++) {
                var generatorWaveData:GeneratorWaveData = waves [i];
                dataProvider.addItem({label: ("wave " + i), data: generatorWaveData});
            }
        }
        listWaves.dataProvider = dataProvider;
        if (waveIndex != -1) {
            if (listWaves.dataProvider.length > waveIndex) {
                listWaves.selectedIndex = waveIndex;
                changeListener_listWaves (null);
            }
        }
    }

    private function initEnemiesList (generatorWaveData:GeneratorWaveData):void {
        var dataProvider:DataProvider = new DataProvider();
        if (generatorWaveData) {
            var enemies:Array/*of Strings*/ = generatorWaveData.sequence;
            var numEnemies:int = enemies.length;
            for (var i:int = 0; i < numEnemies; i++) {
                var enemyId:String = enemies [i];
                dataProvider.addItem({label: enemyId, data: enemyId});
            }
        }
        listEnemies.dataProvider = dataProvider;
    }

    private function selectGeneratorData (generatorData:GeneratorData):void {
        //устанавливаем позицию листа для генератора:
        var dataProvider:DataProvider = listGenerators.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == generatorData) {
                listGenerators.selectedItem = dataProviderItem;
                changeListener_listGenerators(null);
                break;
            }
        }
    }

    private function selectGeneratorWaveData (generatorWaveData:GeneratorWaveData):void {
        //устанавливаем позицию листа для генератора:
        trace ("selectGeneratorWaveData");
        var dataProvider:DataProvider = listWaves.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == generatorWaveData) {
                listWaves.selectedItem = dataProviderItem;
                changeListener_listWaves (null);
                break;
            }
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case btnAddGenerator:
                uiController.addNewGenerator();
                break;
            case btnRemoveGenerator:
                if (listGenerators.selectedItem) {
                    var generatorData:GeneratorData = listGenerators.selectedItem.data;
                    uiController.removeGenerator(generatorData);
                }
                break;
            case btnAddWave:
                //
                break;
            case btnRemoveWave:
                //
                break;
            case btnAddEnemy:
                mcAddEnemyPanel.visible = true;
                break;
            case btnRemoveEnemy:
                if (listWaves.selectedItem) {
                    var currentGeneratorWaveData:GeneratorWaveData = listWaves.selectedItem.data;
                    if (currentGeneratorWaveData && listEnemies.selectedItem) {
                        uiController.removeEnemyFromGeneratorWave(listEnemies.selectedItem.data, currentGeneratorWaveData);
                    }
                }
                break;
        }
    }

    private function selectUIControllerModeListener (event:SelectModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_GENERATORS) {
            resetGeneratorsList ();
        }
    }

    private function changeListener_listAddEnemy (event:Event):void {
        if (listWaves.selectedItem) {
            var currentGeneratorWaveData:GeneratorWaveData = listWaves.selectedItem.data;
            if (currentGeneratorWaveData && listAddEnemy.selectedItem) {
                uiController.addEnemyToGeneratorWave(listAddEnemy.selectedItem.data, currentGeneratorWaveData);
            }
        }
        listAddEnemy.selectedItem = null;
        mcAddEnemyPanel.visible = false;
    }

    private function changeListener_listGenerators (event:Event):void {
        if (listGenerators.selectedItem) {
            initWavesList (listGenerators.selectedItem.data);
        }
    }

    private function changeListener_listWaves (event:Event):void {
        trace ("changeListener_listWaves");
        if (listWaves.selectedItem) {
            initEnemiesList (listWaves.selectedItem.data);
        }
    }

    private function generatorWasAddedListener (event:EditGeneratorEvent):void {
        resetGeneratorsList ();
        //устанавливаем позицию листа для нового добавленого генератора:
        selectGeneratorData (event.generatorData);
    }

    private function generatorWasRemovedListener (event:EditGeneratorEvent):void {
        resetGeneratorsList ();
        if (listGenerators.dataProvider.length > 0) {
            listGenerators.selectedIndex = 0;
            changeListener_listGenerators (null);
        }
    }

    private function generatorWasChangedListener (event:EditGeneratorEvent):void {
        resetGeneratorsList ();
        //устанавливаем позицию листа для нового добавленого генератора:
        selectGeneratorData (event.generatorData);
    }

    private function generatorWaveWasChangedListener (event:EditGeneratorWaveEvent):void {
        resetGeneratorsList ();
        //устанавливаем позицию листа для нового добавленого генератора:
        selectGeneratorWaveData (event.generatorWaveData);
    }
}
}
