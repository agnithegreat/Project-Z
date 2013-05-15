/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 11:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent;
import com.projectz.utils.levelEditor.model.Field;

import fl.controls.List;
import fl.data.DataProvider;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

/**
 * Панель редактора уровней для редактирования уровней.
 */
public class EditLevelsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var levelsStorage:LevelStorage;//Хранилище уровней.

    private var listLevels:List;
    private var btnNew:ButtonWithText;
    private var btnDelete:ButtonWithText;

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param levelsStorage Хранилище уровней.
     */
    public function EditLevelsPanel(mc:MovieClip, model:Field, uiController:UIController, levelsStorage:LevelStorage) {
        this.model = model;
        this.uiController = uiController;
        this.levelsStorage = levelsStorage;
        super(mc);

        levelsStorage.addEventListener(EditLevelsEvent.LEVEL_WAS_ADDED, levelWasAddedListener);
        levelsStorage.addEventListener(EditLevelsEvent.LEVEL_WAS_REMOVED, levelWasRemovedListener);
        model.addEventListener(EditLevelsEvent.SET_LEVEL, setLevelListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
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
        listLevels = List(getElement("listLevels"));

        //Отключаем фокус для компонентов:
        listLevels.focusEnabled = false;

        //Добавляем слушателей для компонентов:
        listLevels.addEventListener(Event.CHANGE, changeListener_listLevels);

        //Создаём кнопки:
        btnNew = new ButtonWithText(mc["btnNew"]);
        btnDelete = new ButtonWithText(mc["btnDelete"]);

        //Устанавливаем тексты на кнопках:
        btnDelete.text = "Удалить";
        btnNew.text = "Создать";

        //Добавляем слушателей для кнопок:
        btnNew.addEventListener(MouseEvent.CLICK, clickListener);
        btnDelete.addEventListener(MouseEvent.CLICK, clickListener);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function reInitLevelsList():void {
        //Формируем список всех уровней:
        var levels:Dictionary = levelsStorage.levels;
        var dataProvider:DataProvider = new DataProvider();
        var currentLevelData:LevelData;
        trace("------------");
        for each (currentLevelData in levels) {
            if (currentLevelData) {
                trace ("currentLevelData.fileName = " + currentLevelData.fileName);
                dataProvider.addItem({label: (currentLevelData.fileName), data: currentLevelData});
            }
            else {
                trace("AHA!!!!");
            }
        }
        trace ("dataProvider.length = " + dataProvider.length);
        dataProvider.sortOn("label");
        listLevels.dataProvider = dataProvider;
    }

    private function setCurrentLevelAsSelected ():void {
        //Устанавливаем позицию листа уровней для текущего выбранного уровня:
        var dataProvider:DataProvider = listLevels.dataProvider;
        for (var i:int = 0; i < dataProvider.length; i++) {
            var dataProviderItem:Object = dataProvider.getItemAt(i);
            if (dataProviderItem.data == model.levelData) {
                listLevels.selectedItem = dataProviderItem;
                break;
            }
        }
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener(event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnNew):
                levelsStorage.addNewLevel();
                break;
            case (btnDelete):
                levelsStorage.removeLevel(model.levelData);
                break;
        }
    }

    private function levelWasAddedListener (event:EditLevelsEvent):void {
        reInitLevelsList();
        uiController.setCurrentLevel(event.levelData);
    }

    private function levelWasRemovedListener (event:EditLevelsEvent):void {
        reInitLevelsList();
        var dataProvider:DataProvider = listLevels.dataProvider;
        if (dataProvider.length > 0) {
            uiController.setCurrentLevel(LevelData(listLevels.getItemAt(0).data));
        }
    }

    private function setLevelListener (event:EditLevelsEvent):void {
        setCurrentLevelAsSelected();
    }

    private function changeListener_listLevels(event:Event):void {
        //Выбираем текущуую редактируемый уровень.
        uiController.setCurrentLevel(LevelData(listLevels.selectedItem.data));
    }

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        if (event.mode == UIControllerMode.EDIT_LEVELS) {
            //Формируем новый список зон при переключении контроллера в режим редактирования зон защитников.
            reInitLevelsList();
            setCurrentLevelAsSelected();
        }
    }

}
}
