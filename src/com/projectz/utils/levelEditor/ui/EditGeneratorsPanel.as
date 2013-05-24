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
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent;
import com.projectz.utils.objectEditor.ObjectDataManager;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.containers.ScrollPane;

import fl.controls.ComboBox;

import fl.controls.List;
import fl.controls.NumericStepper;
import fl.data.DataProvider;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Панель редактора уровней для редактирования генераторов.
 */
public class EditGeneratorsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var objectStorage:ObjectsStorage;//Хранилище всех игровых ассетов (для формирования списка врагов).
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    //элементы ui:
    private var mcAddEnemyPanel:Sprite;
    private var scpAddEnemies:ScrollPane;
    private var nstNumEnemies:NumericStepper;
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

    private var objectsContainer:Sprite = new Sprite ();//Контейнер для отображения списка врагов для добавления в стек.

    private static const NUM_ELEMENTS_IN_ROW:int = 3;
    private static const ELEMENTS_START_X:int = 1;
    private static const ELEMENTS_START_Y:int = 1;
    private static const ELEMENT_WIDTH:int = 120;
    private static const ELEMENT_HEIGHT:int = ELEMENT_WIDTH + 20;
    private static const ELEMENT_DISTANCE_X:int = ELEMENT_WIDTH + 1;
    private static const ELEMENT_DISTANCE_Y:int = ELEMENT_DISTANCE_X + 20;

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param objectStorage Хранилище всех игровых ассетов.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function EditGeneratorsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage, assetsManager:AssetManager) {
        this.model = model;
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        this.assetsManager = assetsManager;
        super(mc);

        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
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
//PROTECTED:
/////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //Инициализируем компоненты:
        mcAddEnemyPanel = Sprite(getElement("mcAddEnemyPanel"));
        scpAddEnemies = ScrollPane(getElement("scpAddEnemies", mcAddEnemyPanel));
        nstNumEnemies = NumericStepper(getElement("nstNumEnemies", mcAddEnemyPanel));
        listGenerators = List(getElement("listGenerators"));
        listWaves = List(getElement("listWaves"));
        listEnemies = List(getElement("listEnemies"));
        cbxPaths = ComboBox(getElement("cbxPaths"));
        tfX = TextField(getElement("tfX"));
        tfY = TextField(getElement("tfY"));
        nstTime = NumericStepper(getElement("nstTime"));
        nstDelay = NumericStepper(getElement("nstDelay"));
        nstTime.minimum = 0;
        nstTime.maximum = 1000;
        nstDelay.minimum = 0;
        nstDelay.maximum = 1000;

        //Отключаем фокус для компонентов:
        scpAddEnemies.focusEnabled = false;
        nstNumEnemies.focusEnabled = false;
        listGenerators.focusEnabled = false;
        listWaves.focusEnabled = false;
        listEnemies.focusEnabled = false;
        cbxPaths.focusEnabled = false;
        nstTime.focusEnabled = false;
        nstDelay.focusEnabled = false;

        //Добавляем слушателей для компонентов:
        listGenerators.addEventListener(Event.CHANGE, changeListener_listGenerators);
        listWaves.addEventListener(Event.CHANGE, changeListener_listWaves);
        cbxPaths.addEventListener(Event.CHANGE, changeListener_cbxPaths);
        nstTime.addEventListener(Event.CHANGE, changeListener_nstTime);
        nstDelay.addEventListener(Event.CHANGE, changeListener_nstDelay);

        //Создаём кнопки:
        btnAddGenerator = new ButtonWithText(mc ["btnAddGenerator"]);
        btnRemoveGenerator = new ButtonWithText(mc ["btnRemoveGenerator"]);
        btnAddWave = new ButtonWithText(mc ["btnAddWave"]);
        btnRemoveWave = new ButtonWithText(mc ["btnRemoveWave"]);
        btnAddEnemy = new ButtonWithText(mc ["btnAddEnemy"]);
        btnRemoveEnemy = new ButtonWithText(mc ["btnRemoveEnemy"]);

        //Устанавливаем тексты для кнопок:
        btnAddGenerator.text = "Добавить";
        btnRemoveGenerator.text = "Удалить";
        btnAddWave.text = "Добавить";
        btnRemoveWave.text = "Удалить";
        btnAddEnemy.text = "Добавить";
        btnRemoveEnemy.text = "Удалить";
        tfX.text = "";
        tfY.text = "";

        //Добавляем слушатели для кнопок:
        btnAddGenerator.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveGenerator.addEventListener(MouseEvent.CLICK, clickListener);
        btnAddWave.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveWave.addEventListener(MouseEvent.CLICK, clickListener);
        btnAddEnemy.addEventListener(MouseEvent.CLICK, clickListener);
        btnRemoveEnemy.addEventListener(MouseEvent.CLICK, clickListener);

        mcAddEnemyPanel.visible = false;//убираем видимость панели с врагами.
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function resetGeneratorsList():void {
        //Формируем список генераторов:
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

        //Устанавливаем текущий выбранный генератор в контроллере, как первый генератор в списке генераторов:
        var currentEditingGenerator:GeneratorData;
        if (listGenerators.dataProvider.length > 0) {
            listGenerators.selectedIndex = 0;
            currentEditingGenerator = GeneratorData(listGenerators.selectedItem.data);
        }
        uiController.currentEditingGenerator = currentEditingGenerator;
    }

    /**
     * Формирование списка всех врагов для добавления врагов в стек.
     */
    private function initAddEnemiesList ():void {
        //Очищаем список врагов:
        var objectPreview:ObjectPreview;
        while (objectsContainer.numChildren > 0) {
            var child:DisplayObject = objectsContainer.getChildAt(0);
            objectPreview = ObjectPreview (child);
            objectPreview.removeEventListener(MouseEvent.CLICK, clickListener_objectPreView);
            objectsContainer.removeChild(child);
        }

        //Формируем список врагов:
        var objects:Dictionary = objectStorage.getObjectsByType(ObjectType.ENEMY);
        var object: ObjectData;
        var objectsAsVector:Vector.<ObjectData> = new Vector.<ObjectData>();
        for each (object in objects) {
            objectsAsVector.push(ObjectData (object));
        }

        objectsAsVector.sort(ObjectDataManager.sortByName);

        var curColumn:int;
        var curRow:int;
        var numPreviewObjects:int = objectsAsVector.length;
        for (var i:int = 0; i < numPreviewObjects; i++) {
            objectPreview = new ObjectPreview (objectsAsVector [i], assetsManager);
            objectsContainer.addChild (objectPreview);
            curRow = Math.floor (i / NUM_ELEMENTS_IN_ROW);
            curColumn = i - curRow * NUM_ELEMENTS_IN_ROW;
            objectPreview.x = ELEMENTS_START_X + curColumn * ELEMENT_DISTANCE_X;
            objectPreview.y = ELEMENTS_START_Y + curRow * ELEMENT_DISTANCE_Y;
            objectPreview.containerWidth = ELEMENT_WIDTH;
            objectPreview.containerHeight = ELEMENT_HEIGHT;
            objectPreview.addEventListener(MouseEvent.CLICK, clickListener_objectPreView);
        }
        scpAddEnemies.source = objectsContainer;
    }

    /**
     * Формирование списка возможных путей для генераторов.
     * @param pathId Id'шник пути для выделения в списке путей.
     */
    //
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

    /**
     * Очистка списка путей для генераторов:
     */
    private function clearPathList():void {
        cbxPaths.dataProvider = new DataProvider();
    }

    /**
     * Формирование списка волн для выбранного генератора.
     * @param generatorData Генератор.
     */
    private function initWavesList(generatorData:GeneratorData):void {
        //Очишаем данные о волне:
        nstDelay.value = 0;
        nstTime.value = 0;

        //Запоминаем последнюю выбранную волну:
        var waveIndex:int = -1;
        if (listWaves.selectedItem) {
            waveIndex = listWaves.selectedIndex;
        }

        //Формируем список волн:
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

        //Устанавливаем список в позицию последней выбранной волны:
        if (waveIndex != -1) {
            if (listWaves.dataProvider.length > waveIndex) {
                selectWave(waveIndex);
            }
        }
    }

    /**
     * Формирование списка стека врагов в выбранной волне генератора.
     * @param generatorWaveData Волна генератора.
     */
    private function initEnemiesList(generatorWaveData:GeneratorWaveData):void {
        //Формируем список стека врагов:
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

        //Устанавливаем и прокручиваем список в позицию последненго элемента:
        if (dataProvider.length > 0) {
            listEnemies.selectedIndex = dataProvider.length - 1;
            listEnemies.scrollToIndex(dataProvider.length - 1);
        }
    }

    /**
     * Выбор волны.
     * @param id Id'шник выбранной волны в списке.
     */
    private function selectWave (id:int):void {
        listWaves.selectedIndex = id;
        if (listWaves.selectedItem) {
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData(listWaves.selectedItem.data);
            //Формирование списка стека врагов для волны:
            initEnemiesList(generatorWaveData);
            //Обновление данных о волне:
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

        //Устанавливаем позицию листа для выбранноо генератора:
        var dataProvider:DataProvider = listGenerators.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == generatorData) {
                listGenerators.selectedItem = dataProviderItem;
                break;
            }
        }

        //Выводим инфо:
        if (generatorData) {
            //выводим информацию о позиции генератора:
            tfX.text = String(generatorData.x);
            tfY.text = String(generatorData.y);
            initWavesList(listGenerators.selectedItem.data);
            initPathsList(generatorData.pathId);
        }
        else {
            //Очищаем данные:
            tfX.text = "";
            tfY.text = "";
            initWavesList(null);
            initEnemiesList(null);
            clearPathList();
        }
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_GENERATORS) {
            //Формируем новый список генераторов при переключении контроллера в режим редактирования генераторов.
            resetGeneratorsList();
            //Обновляем список возможных для добавления врагов:
            initAddEnemiesList();
        }
    }

    private function clickListener_objectPreView (event:MouseEvent):void {
        //Добавляем новых врагов в стек врагов.

        var objectPreView:ObjectPreview = ObjectPreview (event.currentTarget);
        var currentGeneratorWaveData:GeneratorWaveData = listWaves.selectedItem.data;
        if (currentGeneratorWaveData) {
            var positionId:int = currentGeneratorWaveData.sequence.length - 1;
            if (listEnemies.selectedItem) {
                positionId = listEnemies.selectedIndex + 1;
            }
            var count:int = nstNumEnemies.value;
            uiController.addEnemyToGeneratorWave(objectPreView.objectData.name, positionId, count, currentGeneratorWaveData);
        }
        //Скрываем панель добавления врагов:
        mcAddEnemyPanel.visible = false;
    }

    private function changeListener_listGenerators(event:Event):void {
        //Выбираем текущий редактируемый генератор в контроллере.
        uiController.currentEditingGenerator = GeneratorData(listGenerators.selectedItem.data);
    }

    private function changeListener_listWaves(event:Event):void {
        //Выбираем волну, обновляем инфу о волне:
        selectWave(listWaves.selectedIndex);
    }

    private function changeListener_cbxPaths(event:Event):void {
        if (cbxPaths.selectedItem) {
            //Выбираем путь для текущего редактируемого (выбранного в контроллере) генератора:
            uiController.setGeneratorPath (cbxPaths.selectedItem.data);
        }
    }

    private function changeListener_nstTime(event:Event):void {
        if (listWaves.selectedItem){
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData (listWaves.selectedItem.data);
            if (model.levelData) {
                var waveData:WaveData = model.levelData.getWaveDataById(generatorWaveData.id);
                if (waveData) {
                    //Устанавливаем время для волны:
                    uiController.setWaveTime(nstTime.value,waveData)
                }
            }
        }
    }

    private function changeListener_nstDelay(event:Event):void {
        if (listWaves.selectedItem){
            var generatorWaveData:GeneratorWaveData = GeneratorWaveData (listWaves.selectedItem.data);
            //Устанавливаем задержку для волны генератора:
            uiController.setDelayOfGeneratorWave(nstDelay.value,generatorWaveData)
        }
    }

    private function generatorWasAddedListener(event:EditGeneratorEvent):void {
        //Обрабатываем добавление нового генератора:
        resetGeneratorsList();//Формируем список генераторов.
        //Устанавливаем новый генератор в контроллере в качестве текущего редактируемого генератора.
        uiController.currentEditingGenerator = event.generatorData;
    }

    private function generatorWasRemovedListener(event:EditGeneratorEvent):void {
        //Обрабатываем удаление генератора:
        resetGeneratorsList();
    }

    private function generatorWasChangedListener(event:EditGeneratorEvent):void {
        //Обрабатываем изменение генератора.
        //Повторно устанавливаем новый генератор в контроллере в качестве текущего редактируемого генератора.
        //Т.о. мы инициализируем обновление данных.
        uiController.currentEditingGenerator = event.generatorData;
    }

    private function generatorWaveWasChangedListener(event:EditGeneratorWaveEvent):void {
        //Обрабатываем изменение волны генератора.
        //Обновление списка стека врагов.
        initEnemiesList (event.generatorWaveData);
    }

    private function waveWasAddedListener(event:EditWavesEvent):void {
        //Обновляем список волн с учётом добавленной волны.
        initWavesList (uiController.currentEditingGenerator);
        //Устанавливаем значение листа в конец, т.к. волна всегда добавляестя в конец:
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
