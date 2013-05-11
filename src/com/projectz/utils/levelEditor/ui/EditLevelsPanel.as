/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 11:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.model.Field;

import flash.display.MovieClip;

/**
 * Панель редактора уровней для редактирования уровней.
 */
public class EditLevelsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var levelsStorage:LevelStorage;//Хранилище уровней.

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
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    override protected function initGraphicElements():void {
        super.initGraphicElements();
    }
}
}
