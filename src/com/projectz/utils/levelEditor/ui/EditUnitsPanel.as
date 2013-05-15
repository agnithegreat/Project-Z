/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 11:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editUnits.SelectUnitsTypeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.ObjectDataManager;
import com.projectz.utils.objectEditor.data.DefenderData;
import com.projectz.utils.objectEditor.data.EnemyData;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.events.EditDefenderDataEvent;
import com.projectz.utils.objectEditor.data.events.EditEnemyDataEvent;

import fl.containers.ScrollPane;
import fl.controls.ComboBox;
import fl.controls.NumericStepper;
import fl.data.DataProvider;

import flash.display.DisplayObject;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Панель редактора уровней для редактирования юнитов.
 */
public class EditUnitsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var objectStorage:ObjectsStorage;//Хранилище всех игровых ассетов.
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    //Компоненты:
    private var cbxUnitsType:ComboBox;
    private var scpUnits:ScrollPane;
    private var mcEnemyPanel:Sprite;
    private var mcDefenderPanel:Sprite;

    //Параметры защитников:
    private var nstDefenderCost:NumericStepper;
    private var nstDefenderStrength:NumericStepper;
    private var nstDefenderRadius:NumericStepper;
    private var nstDefenderPower:NumericStepper;
    private var nstDefenderCooldown:NumericStepper;
    private var nstDefenderAmmo:NumericStepper;
    private var nstDefenderDefence:NumericStepper;

    //Параметры врагов:
    private var nstEnemyHP:NumericStepper;
    private var nstEnemySpeed:NumericStepper;
    private var nstEnemyStrength:NumericStepper;
    private var nstEnemyCooldown:NumericStepper;
    private var nstEnemyReward:NumericStepper;

    private var unitsContainer:Sprite = new Sprite ();//Контейнер для отображения списка юнитов.

    private static const NUM_ELEMENTS_IN_ROW:int = 3;
    private static const ELEMENTS_START_X:int = 1;
    private static const ELEMENTS_START_Y:int = 1;
    private static const ELEMENT_WIDTH:int = 122;
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
    public function EditUnitsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage, assetsManager:AssetManager) {
        this.model = model;
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        this.assetsManager = assetsManager;
        super(mc);

        uiController.addEventListener(SelectUnitEvent.SELECT_UNIT, selectUnitListener);
        uiController.addEventListener(SelectUnitsTypeEvent.SELECT_UNITS_TYPE, selectUnitsTypeListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(EditDefenderDataEvent.DEFENDER_DATA_WAS_CHANGED, defenderDataWasChangedListener);
        uiController.addEventListener(EditEnemyDataEvent.ENEMY_DATA_WAS_CHANGED, enemyDataWasChangedListener);
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
        cbxUnitsType = ComboBox (getElement("cbxUnitsType"));
        scpUnits = ScrollPane (getElement("scpUnits"));

        mcDefenderPanel = getElement("mcDefenderPanel");
        mcEnemyPanel = getElement("mcEnemyPanel");

        nstDefenderCost = getElement("nstDefenderCost", mcDefenderPanel);
        nstDefenderStrength = getElement("nstDefenderStrength", mcDefenderPanel);
        nstDefenderRadius = getElement("nstDefenderRadius", mcDefenderPanel);
        nstDefenderPower = getElement("nstDefenderPower", mcDefenderPanel);
        nstDefenderCooldown = getElement("nstDefenderCooldown", mcDefenderPanel);
        nstDefenderAmmo = getElement("nstDefenderAmmo", mcDefenderPanel);
        nstDefenderDefence = getElement("nstDefenderDefence", mcDefenderPanel);

        nstEnemyHP = getElement("nstEnemyHP", mcEnemyPanel);
        nstEnemySpeed = getElement("nstEnemySpeed", mcEnemyPanel);
        nstEnemyStrength = getElement("nstEnemyStrength", mcEnemyPanel);
        nstEnemyCooldown = getElement("nstEnemyCooldown", mcEnemyPanel);
        nstEnemyReward = getElement("nstEnemyReward", mcEnemyPanel);

        nstDefenderCost.minimum = 0;
        nstDefenderCost.maximum = 999;
        nstDefenderStrength.minimum = 0;
        nstDefenderStrength.maximum = 999;
        nstDefenderRadius.minimum = 0;
        nstDefenderRadius.maximum = 999;
        nstDefenderPower.minimum = 0;
        nstDefenderPower.maximum = 1;
        nstDefenderCooldown.minimum = 0;
        nstDefenderCooldown.maximum = 999;
        nstDefenderAmmo.minimum = 0;
        nstDefenderAmmo.maximum = 999;
        nstDefenderDefence.minimum = 0;
        nstDefenderDefence.maximum = 999;
        nstEnemyHP.minimum = 0;
        nstEnemyHP.maximum = 999;
        nstEnemySpeed.minimum = 0;
        nstEnemySpeed.maximum = 999;
        nstEnemyStrength.minimum = 0;
        nstEnemyStrength.maximum = 999;
        nstEnemyCooldown.minimum = 0;
        nstEnemyCooldown.maximum = 999;
        nstEnemyReward.minimum = 0;
        nstEnemyReward.maximum = 999;

        //Отключаем фокус для компонентов:
        cbxUnitsType.focusEnabled = false;
        scpUnits.focusEnabled = false;
        nstDefenderCost.focusEnabled = false;
        nstDefenderStrength.focusEnabled = false;
        nstDefenderRadius.focusEnabled = false;
        nstDefenderPower.focusEnabled = false;
        nstDefenderCooldown.focusEnabled = false;
        nstDefenderAmmo.focusEnabled = false;
        nstDefenderDefence.focusEnabled = false;
        nstEnemyHP.focusEnabled = false;
        nstEnemySpeed.focusEnabled = false;
        nstEnemyStrength.focusEnabled = false;
        nstEnemyCooldown.focusEnabled = false;
        nstEnemyReward.focusEnabled = false;

        //Формируем список типов объектов:
        var dataProvider:DataProvider = new DataProvider();
        dataProvider.addItem({label:"static object (" + ObjectType.ENEMY + ")",data:ObjectType.ENEMY});
        dataProvider.addItem({label:"target object (" + ObjectType.DEFENDER + ")",data:ObjectType.DEFENDER});
        cbxUnitsType.dataProvider = dataProvider;

        //Добавляем слушателей для компонентов:
        cbxUnitsType.addEventListener (Event.CHANGE, changeListener_cbxUnitsType);
        nstEnemyReward.focusEnabled = false;

        nstDefenderCost.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderStrength.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderRadius.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderPower.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderCooldown.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderAmmo.addEventListener (Event.CHANGE, changeListener_defender);
        nstDefenderDefence.addEventListener (Event.CHANGE, changeListener_defender);

        nstEnemyHP.addEventListener (Event.CHANGE, changeListener_enemy);
        nstEnemySpeed.addEventListener (Event.CHANGE, changeListener_enemy);
        nstEnemyStrength.addEventListener (Event.CHANGE, changeListener_enemy);
        nstEnemyCooldown.addEventListener (Event.CHANGE, changeListener_enemy);
        nstEnemyReward.addEventListener (Event.CHANGE, changeListener_enemy);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function setDefenderDataParams (defenderData:DefenderData):void {
        trace ("setDefenderDataParams");
        nstDefenderCost.value = defenderData.cost;
        nstDefenderStrength.value = defenderData.strength;
        nstDefenderRadius.value = defenderData.radius;
        nstDefenderPower.value = defenderData.power;
        nstDefenderCooldown.value = defenderData.cooldown;
        nstDefenderAmmo.value = defenderData.ammo;
        nstDefenderDefence.value = defenderData.defence;
    }

    private function setEnemyDataParams (enemyData:EnemyData):void {
        trace ("setEnemyDataParams");
        nstEnemyHP.value = enemyData.hp;
        nstEnemySpeed.value = enemyData.speed;
        nstEnemyStrength.value = enemyData.strength;
        nstEnemyCooldown.value = enemyData.cooldown;
        nstEnemyReward.value = enemyData.reward;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function selectUnitListener (event:SelectUnitEvent):void {
        //Выделяем текущего редактируемого юнита и снимаем выделения с остальных:
        var objectData:ObjectData = event.objectData;
        var numObjects:int = unitsContainer.numChildren;
        for (var i:int = 0; i < numObjects; i++) {
            var child:DisplayObject = unitsContainer.getChildAt(i);
            var objectPreView:ObjectPreview = ObjectPreview (child);
            objectPreView.select = (objectPreView.objectData == objectData);
        }

        //Отображаем необходимую панель для редактирования уровня и отображаем информацию о выбранном юните:
        mcDefenderPanel.visible = false;
        mcEnemyPanel.visible = false;
        if (objectData) {
            if (objectData is DefenderData) {
                mcDefenderPanel.visible = true;
                var defenderData:DefenderData = DefenderData (objectData);
                setDefenderDataParams (defenderData);
            }
            else if (objectData is EnemyData) {
                mcEnemyPanel.visible = true;
                var enemyData:EnemyData = EnemyData (objectData);
                nstEnemyHP.value = enemyData.hp;
                nstEnemySpeed.value = enemyData.speed;
                nstEnemyStrength.value = enemyData.strength;
                nstEnemyCooldown.value = enemyData.cooldown;
                nstEnemyReward.value = enemyData.reward;
            }
        }
    }

    private function selectUnitsTypeListener (event:SelectUnitsTypeEvent):void {
        //Устанавливаем позицию комбобокса типов объектов для выбранноо типа:
        var dataProvider:DataProvider = cbxUnitsType.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == event.objectsType) {
                cbxUnitsType.selectedItem = dataProviderItem;
//                trace ("select objectsType = " + event.objectsType);
                break;
            }
        }

        //Очищаем список объектов:
        var objectPreview:ObjectPreview;
        while (unitsContainer.numChildren > 0) {
            var child:DisplayObject = unitsContainer.getChildAt(0);
            objectPreview = ObjectPreview (child);
            objectPreview.removeEventListener(MouseEvent.CLICK, clickListener_objectPreView);
            unitsContainer.removeChild(child);
        }

        //Формируем список объектов выбранного типа:
        var object: ObjectData;
        var objects: Dictionary = objectStorage.getObjectsByType(event.objectsType);
        var objectsAsVector:Vector.<ObjectData> = new Vector.<ObjectData>();
        for each (object in objects) {
            objectsAsVector.push(ObjectData (object));
        }

        objectsAsVector.sort(ObjectDataManager.sortByName);

        var curColumn:int;
        var curRow:int;
        var numPreviewObjects:int = objectsAsVector.length;
        for (i = 0; i < numPreviewObjects; i++) {
            objectPreview = new ObjectPreview (objectsAsVector [i], assetsManager);
            unitsContainer.addChild (objectPreview);
            curRow = Math.floor (i / NUM_ELEMENTS_IN_ROW);
            curColumn = i - curRow * NUM_ELEMENTS_IN_ROW;
            objectPreview.x = ELEMENTS_START_X + curColumn * ELEMENT_DISTANCE_X;
            objectPreview.y = ELEMENTS_START_Y + curRow * ELEMENT_DISTANCE_Y;
            objectPreview.containerWidth = ELEMENT_WIDTH;
            objectPreview.containerHeight = ELEMENT_HEIGHT;
            objectPreview.addEventListener(MouseEvent.CLICK, clickListener_objectPreView);
        }
        scpUnits.source = unitsContainer;

        uiController.currentEditingUnit = null;
    }

    private function changeListener_cbxUnitsType (event:Event):void {
        //Устанавливаем тип юнитов для редактирования в контроллере:
        uiController.selectCurrentEditingUnitType(String (cbxUnitsType.selectedItem.data));
    }

    private function changeListener_defender (event:Event):void {
        var objectData:ObjectData = uiController.currentEditingUnit;
        if (objectData) {
            if (objectData is DefenderData) {
                var defenderData:DefenderData = DefenderData (objectData);
                switch (event.currentTarget) {
                    case (nstDefenderCost):
                        defenderData.cost = nstDefenderCost.value;
                        break;
                    case (nstDefenderStrength):
                        defenderData.strength = nstDefenderStrength.value;
                        break;
                    case (nstDefenderRadius):
                        defenderData.radius = nstDefenderRadius.value;
                        break;
                    case (nstDefenderPower):
                        defenderData.power = nstDefenderPower.value;
                        break;
                    case (nstDefenderCooldown):
                        defenderData.cooldown = nstDefenderCooldown.value;
                        break;
                    case (nstDefenderAmmo):
                        defenderData.ammo = nstDefenderAmmo.value;
                        break;
                    case (nstDefenderDefence):
                        defenderData.defence = nstDefenderDefence.value;
                        break;
                }
            }
        }
    }

    private function changeListener_enemy (event:Event):void {
        var objectData:ObjectData = uiController.currentEditingUnit;
        if (objectData) {
            if (objectData is EnemyData) {
                var enemyData:EnemyData = EnemyData (objectData);
                switch (event.currentTarget) {
                    case (nstEnemyHP):
                        enemyData.hp = nstEnemyHP.value;
                        break;
                    case (nstEnemySpeed):
                        enemyData.speed = nstEnemySpeed.value;
                        break;
                    case (nstEnemyStrength):
                        enemyData.strength = nstEnemyStrength.value;
                        break;
                    case (nstEnemyCooldown):
                        enemyData.cooldown = nstEnemyCooldown.value;
                        break;
                    case (nstEnemyReward):
                        enemyData.reward = nstEnemyReward.value;
                        break;
                }
            }
        }
    }

    private function defenderDataWasChangedListener (event:EditDefenderDataEvent):void {
        var defenderData:DefenderData = event.defenderData;
        setDefenderDataParams (defenderData);
    }

    private function enemyDataWasChangedListener (event:EditEnemyDataEvent):void {
        var enemyData:EnemyData = event.enemyData;
        setEnemyDataParams(enemyData);
    }

    private function clickListener_objectPreView (event:MouseEvent):void {
        var objectPreView:ObjectPreview = ObjectPreview (event.currentTarget);
        uiController.currentEditingUnit = objectPreView.objectData;
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_UNITS) {
            //Формируем новый список юнитов при переключении контроллера в режим редактирования юнитов.
            uiController.selectCurrentEditingUnitType(String (cbxUnitsType.getItemAt(0).data));
        }
    }

}
}
