/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 05.04.13
 * Time: 12:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.GraphicStorage;
import com.hogargames.display.buttons.ButtonWithText;

import flash.events.Event;
import flash.text.TextField;

public class SelectConfigPanel extends GraphicStorage {

    public var btnSelectPath:ButtonWithText;
    public var btnStart:ButtonWithText;
    public var btnSaveConfig:ButtonWithText;
    public var tfPath:TextField;

    public function SelectConfigPanel() {
        super (new mcSelectConfigPanel);

        addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
    }

    public function selectPathStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "выбрать";
        btnSaveConfig.enable = false;
        btnStart.enable = false;
    }

    public function saveConfigStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.enable = false;
    }

    public function finalStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.enable = true;
    }

    public function showPath (text:String):void {
        tfPath.text = text;
    }

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        btnSelectPath = new ButtonWithText (mc ["btnSelectPath"]);
        btnStart = new ButtonWithText (mc ["btnStart"]);
        btnSaveConfig = new ButtonWithText (mc ["btnSaveConfig"]);
        tfPath = TextField (getElement("tfPath"));

        btnSelectPath.text = "выбрать";
        btnSaveConfig.text = "сохранить";
        btnStart.text = "запуск";
    }

    private function addedToStageListener (event:Event):void {
        var stageWidth:Number = stage.stageWidth;
        var stageHeight:Number = stage.stageHeight;
        mc.x = (stageWidth - mc.width) / 2;
        mc.y = (stageHeight - mc.height) / 2;
        graphics.beginFill(0x000000,.1);
        graphics.drawRect(0,0,stageWidth,stageHeight);
        graphics.endFill();
    }
}
}
