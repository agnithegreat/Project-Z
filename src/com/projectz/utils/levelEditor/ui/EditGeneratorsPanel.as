/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.04.13
 * Time: 20:59
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent;
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
        super(mc);

        uiController.addEventListener(SelectModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(SelectGeneratorEvent.SELECT_GENERATOR, selectGeneratorListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_ADDED, generatorWasAddedListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_REMOVED, generatorWasRemovedListener);
        model.addEventListener(EditGeneratorEvent.GENERATOR_WAS_CHANGED, generatorWasChangedListener);
        model.addEventListener(EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED, generatorWaveWasChangedListener);
        model.addEventListener(EditWavesEvent.WAVE_WAS_ADDED, waveWasAddedListener);
        model.addEventListener(EditWavesEvent.WAVE_WAS_CHANGED, waveWasChangedListener);
        model.addEventListener(EditWavesEvent.WAVE_WAS_REMOVED, waveWasRemovedListener);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    override public function show():void {
        super.show();
        resetGeneratorsList();
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements():void {
        super.initGraphicElements();

        mcAddEnemyPanel = Sprite(getElement("mcAddEnemyPanel"));
        listAddEnemy = List(getElement("listAddEnemy", mcAddEnemyPanel));
        listGenerators = List(getElement("listGenerators"));
        listWaves = List(getElement("listWaves"));
        listEnemies = List(getElement("listEnemies"));
        cbxPaths = ComboBox(getElement("cbxPaths"));
        tfX = TextField(getElement("tfX"));
        tfY = TextField(getElement("tfY"));
        btnAddGenerator = new ButtonWithText(mc ["btnAddGenerator"]);
        btnRemoveGenerator = new ButtonWithText(mc ["btnRemoveGenerator"]);
        btnAddWave = new ButtonWithText(mc ["btnAddWave"]);
        btnRemoveWave = new ButtonWithText(mc ["btnRemoveWave"]);
        btnAddEnemy = new ButtonWithText(mc ["btnAddEnemy"]);
        btnRemoveEnemy = new ButtonWithText(mc ["btnRemoveEnemy"]);
        nstTime = NumericStepper(getElement("nstTime"));
        nstDelay = NumericStepper(getElement("nstDelay"));
        nstTime.minimum = 0;
        nstTime.maximum = 1000;
        nstDelay.minimum = 0;
        nstDelay.maximum = 1000;

        btnAddGenerator.text = "Добавить";
        btnRemoveGenerator.text = "Удалить";
        btnAddWave.text = "Добавить";
        btnRemoveWave.text = "Удалить";
        btnAddEnemy.text = "Добавить";
        btnRemoveEnemy.text = "Удалить";
        tfX.text = "";
        tfY.text = "";

        //добавляем слушатели:
        btnAddGenerator.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveGenerator.addEventListener(MouseEvent.CLICK, clickListener);
        btnAddWave.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveWave.addEventListener(MouseEvent.CLICK, clickListener);
        btnAddEnemy.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveEnemy.addEventListener(MouseEvent.CLICK, clickListener);

        mcAddEnemyPanel.visible = false;

        //формируем список врагов:
        var dataProvider:DataProvider = new DataProvider();
        var objects:Dictionary = objectStorage.getType(ObjectData.ENEMY);
        var object:ObjectData;
        for each (object in objects) {
            var objectData:ObjectData = ObjectData(object);
            dataProvider.addItem({label: objectData.name, data: objectData.name});
        }
        dataProvider.sortOn("name");
        listAddEnemy.dataProvider = dataProvider;

        listAddEnemy.addEventListener(Event.CHANGE, changeListener_listAddEnemy);
        listGenerators.addEventListener(Event.CHANGE, changeListener_listGenerators);
        listWaves.addEventListener(Event.CHANGE, changeListener_listWaves);
        cbxPaths.addEventListener(Event.CHANGE, changeListener_cbxPaths);
        nstTime.addEventListener(Event.CHANGE, changeListener_nstTime);
        nstDelay.addEventListener(Event.CHANGE, changeListener_nstDelay);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function resetGeneratorsList():void {
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
        if (listGenerators.dataProvider.length > 0) {
            listGenerators.selectedIndex = 0;
            uiController.currentEditingGenerator = GeneratorData(listGenerators.selectedItem.data);
        }
        else {
            uiController.currentEditingGenerator = null;
        }
    }

    private function initPathsList(pathId:int):void {
        var dataProvider:DataProvider = new DataProvider();
        var pathIndex:int = -1;
        if (model.levelData) {
            var paths:Vector.<PathData> = model.levelData.paths;
            var numPaths:int = paths.length;
            for (var i:int = 0; i < numPaths; i++) {
                var pathData:PathData = paths [i];
                dataProvider.addItem({label: ("path " + pathData.id), data: pathData.id});
                if (pathId == pathData.id) {
                    pathIndex = i;
                }
            }
        }
        cbxPaths.dataProvider = dataProvider;
        if (pathIndex != -1) {
            cbxPaths.selectedIndex = pathIndex;
        }
    }

    private function clearPathList():void {
        cbxPaths.dataProvider = new DataProvider();
    }

    private function initWavesList(generatorData:GeneratorData):void {
        //очишаем данные о волне:
        nstDelay.value = 0;
        nstTime.value = 0;
        var waveIndex:int = -1;//запоминаем последнюю выбранную волну
        if (listWaves.selectedItem) {
            waveIndex = listWaves.selectedIndex;
        }
        var dataProvider:DataProvider = new DataProvider();
        if (generatorData) {
            var waves:Vector.<GeneratorWaveData> = generatorData.waves;
            var numWaves:int = waves.length;
            for (var i:int = 0; i < numWaves; i++) {
                var generatorWaveData:GeneratorWaveData = waves [i];
                dataProvider.addItem({label: ("wave " + generatorWaveData.id), data: generatorWaveData});
            }
        }
        listWaves.dataProvider = dataProvider;
        if (waveIndex != -1) {
            if (listWaves.dataProvider.length > waveIndex) {
                selectWave(waveIndex);
            }
        }
    }

    private function initEnemiesList(generatorWaveData:GeneratorWaveData):void {
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
        if (dataProvider.length > 0) {
            listEnemies.selectedIndex = 0;
        }
    }

    private function selectWave (id:int):void {
        listWaves.selectedIndex = id;
        if (listWaves.selectedItem) {
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData(listWaves.selectedItem.data);
            initEnemiesList(generatorWaveData);
            nstDelay.value = generatorWaveData.delay;
            if (model.levelData) {
                var waveData:WaveData = model.levelData.getWaveDataById(generatorWaveData.id);
                if (waveData) {
                    nstTime.value = waveData.time;
                }
            }
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener(event:MouseEvent):void {
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
                uiController.addNewWave();
                break;
            case btnRemoveWave:
                if (listWaves.selectedItem) {
                    var generatorWaveData:GeneratorWaveData = GeneratorWaveData (listWaves.selectedItem.data);
                    uiController.removeWave(generatorWaveData.id);
                }
                break;
            case btnAddEnemy:
                if (listWaves.selectedItem) {
                    mcAddEnemyPanel.visible = true;
                }
                break;
            case btnRemoveEnemy:
                if (listWaves.selectedItem) {
                    var currentGeneratorWaveData:GeneratorWaveData = listWaves.selectedItem.data;
                    if (currentGeneratorWaveData && listEnemies.selectedItem) {
                        uiController.removeEnemyFromGeneratorWave(listEnemies.selectedIndex, currentGeneratorWaveData);
                    }
                }
                break;
        }
    }

    private function selectGeneratorListener(event:SelectGeneratorEvent):void {
        var generatorData:GeneratorData = event.generatorData;
        //устанавливаем позицию листа для выбранноо генератора:
        var dataProvider:DataProvider = listGenerators.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == generatorData) {
                listGenerators.selectedItem = dataProviderItem;
//                trace ("select path = " + event.pathData.id);
                break;
            }
        }

        if (generatorData) {
            //выводим информацию о позиции генератора:
            tfX.text = String(generatorData.x);
            tfY.text = String(generatorData.y);
            initWavesList(listGenerators.selectedItem.data);
            initPathsList(generatorData.pathId);
        }
        else {
            tfX.text = "";
            tfY.text = "";
            initWavesList(null);
            initEnemiesList(null);
            clearPathList();
        }
    }

    private function selectUIControllerModeListener(event:SelectModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_GENERATORS) {
            resetGeneratorsList();
        }
    }

    private function changeListener_listAddEnemy(event:Event):void {
        if (listWaves.selectedItem) {
            var currentGeneratorWaveData:GeneratorWaveData = listWaves.selectedItem.data;
            if (currentGeneratorWaveData && listAddEnemy.selectedItem) {
                var positionId:int = currentGeneratorWaveData.sequence.length - 1;
                if (listEnemies.selectedItem) {
                    positionId = listEnemies.selectedIndex + 1;
                }
                uiController.addEnemyToGeneratorWave(listAddEnemy.selectedItem.data, positionId, currentGeneratorWaveData);
            }
        }
        listAddEnemy.selectedItem = null;
        mcAddEnemyPanel.visible = false;
    }

    private function changeListener_listGenerators(event:Event):void {
        uiController.currentEditingGenerator = GeneratorData(listGenerators.selectedItem.data);
    }

    private function changeListener_listWaves(event:Event):void {
        selectWave(listWaves.selectedIndex);
    }

    private function changeListener_cbxPaths(event:Event):void {
        if (cbxPaths.selectedItem) {
            uiController.setGeneratorPath (cbxPaths.selectedItem.data);
        }
    }

    private function changeListener_nstTime(event:Event):void {
        if (listWaves.selectedItem){
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData (listWaves.selectedItem.data);
            if (model.levelData) {
                var waveData:WaveData = model.levelData.getWaveDataById(generatorWaveData.id);
                if (waveData) {
                    uiController.setWaveTime(nstTime.value,waveData)
                }
            }
        }
    }

    private function changeListener_nstDelay(event:Event):void {
        if (listWaves.selectedItem){
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData (listWaves.selectedItem.data);
            uiController.setDelayOfGeneratorWave(nstDelay.value,generatorWaveData)
        }
    }

    private function generatorWasAddedListener(event:EditGeneratorEvent):void {
        resetGeneratorsList();
        uiController.currentEditingGenerator = event.generatorData;
    }

    private function generatorWasRemovedListener(event:EditGeneratorEvent):void {
        resetGeneratorsList();
    }

    private function generatorWasChangedListener(event:EditGeneratorEvent):void {
        uiController.currentEditingGenerator = event.generatorData;
    }

    private function generatorWaveWasChangedListener(event:EditGeneratorWaveEvent):void {
        initEnemiesList (event.generatorWaveData);
    }

    private function waveWasAddedListener(event:EditWavesEvent):void {
        initWavesList (uiController.currentEditingGenerator);
        //устанавливаем значение листа в конец, т.к. волна всегда добавляестя в конец:
        selectWave (listWaves.dataProvider.length - 1);
    }

    private function waveWasChangedListener(event:EditWavesEvent):void {
        if (event.waveData) {
            nstTime.value = event.waveData.time;
        }
    }

    private function waveWasRemovedListener(event:EditWavesEvent):void {
        initWavesList (uiController.currentEditingGenerator);
        if (listWaves.dataProvider.length > 0) {
            selectWave(0);
        }
        else {
            initEnemiesList(null);
        }
    }


}
}
