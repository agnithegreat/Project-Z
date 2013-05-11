/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 11:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {

import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.display.MovieClip;

/**
 * Панель редактора уровней для редактирования юнитов.
 */
public class EditUnitsPanel extends BasicPanel {

    private var model:Field;//Ссылка на модель (mvc).
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var objectStorage:ObjectsStorage;//Хранилище всех игровых ассетов.

    /**
     * @param mc Мувиклип с графикой для панели.
     * @param model Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param objectStorage Хранилище всех игровых ассетов.
     */
    public function EditUnitsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage) {
            this.model = model;
            this.uiController = uiController;
            this.objectStorage = objectStorage;
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
