/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.hogarLevelEditor {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;
import com.projectz.utils.levelEditor.controller.LevelEditorController;

import flash.display.MovieClip;
import flash.events.MouseEvent;

public class EditObjectsPanel extends GraphicStorage implements IPanel{

    private var controller:LevelEditorController;

    private var btnAdd:ButtonWithText;
    private var btnRemove:ButtonWithText;
    private var btnSave:ButtonWithText;
    private var btnClear:ButtonWithText;

    public function EditObjectsPanel(mc:MovieClip, controller:LevelEditorController) {
        this.controller = controller;
        super (mc);
    }

    public function show():void {
        visible = true;
    }

    public function hide():void {
        visible = false;
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        //создание кнопок:
        btnAdd = new ButtonWithText (mc["btnAdd"]);
        btnRemove = new ButtonWithText (mc["btnRemove"]);
        btnSave = new ButtonWithText (mc["btnSave"]);
        btnClear = new ButtonWithText (mc["btnClear"]);

        btnAdd.text = "добавление";
        btnRemove.text = "удаление";
        btnSave.text = "сохранить";
        btnClear.text = "очистить";

    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function clickListener (event:MouseEvent):void {
        switch (event.currentTarget) {
            case (btnAdd):
                //действие
                break;
            case (btnRemove):
                //действие
                break;
            case (btnSave):
                //действие
                break;
            case (btnClear):
                //действие
                break;
        }
    }

}
}
