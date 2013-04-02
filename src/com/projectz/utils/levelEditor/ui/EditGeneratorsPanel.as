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
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import fl.controls.ComboBox;

import fl.controls.List;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

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

    public function EditGeneratorsPanel(mc:MovieClip, model:Field, uiController:UIController, objectStorage:ObjectsStorage) {
        this.model = model;
        this.uiController = uiController;
        this.objectStorage = objectStorage;
        super (mc);
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
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case btnAddGenerator:
                //
                break;
            case btnRemoveGenerator:
                //
                break;
            case btnAddWave:
                //
                break;
            case btnRemoveWave:
                //
                break;
            case btnAddEnemy:
                //
                break;
            case btnRemoveEnemy:
                //
                break;
        }


    }
}
}
