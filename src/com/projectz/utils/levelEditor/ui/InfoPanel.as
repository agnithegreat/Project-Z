/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 16:40
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.GraphicStorage;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.events.uiController.ShowCellInfoEvent;
import com.projectz.utils.levelEditor.model.Cell;

import flash.display.MovieClip;
import flash.text.TextField;

public class InfoPanel extends GraphicStorage {

    private var tfX:TextField;
    private var tfY:TextField;
    private var tfEnable:TextField;

    private var uiController:UIController;

    public function InfoPanel(mc:MovieClip, uiController:UIController) {
        this.uiController = uiController;
        super (mc);
        uiController.addEventListener (ShowCellInfoEvent.SHOW_CELL_INFO, showCellInfoListener);
    }

    private function showCellInfoListener (event:ShowCellInfoEvent):void {
        var cell:Cell = event.cell;
        tfX.text = String (cell.x);
        tfY.text = String (cell.y);
        tfEnable.text = cell.locked ? "да" : "нет";
    }

    override protected function initGraphicElements ():void {
        super.initGraphicElements();
        tfX = TextField (getElement("tfX"));
        tfY = TextField (getElement("tfY"));
        tfEnable = TextField (getElement("tfEnable"));
    }
}
}
