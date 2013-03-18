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
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;

import flash.display.Sprite;
import flash.events.Event;

public class LevelEditorUI extends GraphicStorage {

    private var mcInfoPanel:Sprite;

    private var btnTabEditObjects:ButtonWithText;
    private var btnTabEditPaths:ButtonWithText;
    private var btnTabEditDefenderZones:ButtonWithText;
    private var btnTabEditLevels:ButtonWithText;

    private var tabs:Vector.<ButtonWithText> = new <ButtonWithText>[];

    public function LevelEditorUI() {
        super(new mcLevelEditorPanel);

        LevelEditorController.getInstance().addEventListener(LevelEditorEvent.SELECT_MODE, selectModeListener);
    }

    override protected function initGraphicElements():void {
        super.initGraphicElements();

        //инициализируем графические элементы (парсим графику):
        btnTabEditObjects = new ButtonWithText(mc["mcBtnTab1"]);
        btnTabEditPaths = new ButtonWithText(mc["mcBtnTab2"]);
        btnTabEditDefenderZones = new ButtonWithText(mc["mcBtnTab3"]);
        btnTabEditLevels = new ButtonWithText(mc["mcBtnTab4"]);

        mc["mcBtnTab5"].visible = false;//убираем видимость неиспользованных табов

        tabs.push(btnTabEditObjects);
        tabs.push(btnTabEditPaths);
        tabs.push(btnTabEditDefenderZones);
        tabs.push(btnTabEditLevels);

        mcInfoPanel = Sprite (getElement("mcInfoPanel"));

        //добавляем тексты:
        btnTabEditObjects.text = "редактор объектов";
        btnTabEditPaths.text = "редактор путей";
        btnTabEditDefenderZones.text = "редактор зон защитников";
        btnTabEditLevels.text = "редактор уровней";
    }


    private function selectModeListener (event:Event):void {

    }

}
}
