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
import com.projectz.utils.json.JSONLoader;

import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.text.TextField;

import starling.events.Event;

public class SelectConfigPanel extends GraphicStorage {

    public var btnSelectPath:ButtonWithText;
    public var btnStart:ButtonWithText;
    public var btnSaveConfig:ButtonWithText;
    public var tfPath:TextField;

    private var config: JSONLoader;
    private var directory: File;

    public function SelectConfigPanel(config: JSONLoader, directory: File) {
        super (new mcSelectConfigPanel);
        this.config = config;
        this.directory = directory;
        addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);

        directory.addEventListener(Event.SELECT, handleSelect);
        directory.addEventListener(Event.CANCEL, handleCancel);

        selectPathStep ();
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    override protected function initGraphicElements ():void {
        super.initGraphicElements();

        btnSelectPath = new ButtonWithText (mc ["btnSelectPath"]);
        btnStart = new ButtonWithText (mc ["btnStart"]);
        btnSaveConfig = new ButtonWithText (mc ["btnSaveConfig"]);
        tfPath = TextField (getElement("tfPath"));

        btnSelectPath.text = "выбрать";
        btnSaveConfig.text = "сохранить";
        btnStart.text = "запуск";

        btnSelectPath.addEventListener(MouseEvent.CLICK, clickListener_selectPath);
        btnSaveConfig.addEventListener(MouseEvent.CLICK, clickListener_btnSaveConfig);
        btnStart.addEventListener(MouseEvent.CLICK, clickListener_btnStart);
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function selectPathStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "выбрать";
        btnSaveConfig.enable = false;
        btnStart.enable = false;
    }

    private function saveConfigStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.enable = false;
    }

    private function finalStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.enable = true;
    }

    private function showPath (text:String):void {
        tfPath.text = text;
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function addedToStageListener (event:*):void {
        var stageWidth:Number = stage.stageWidth;
        var stageHeight:Number = stage.stageHeight;
        mc.x = (stageWidth - mc.width) / 2;
        mc.y = (stageHeight - mc.height) / 2;
        graphics.beginFill(0x000000,.1);
        graphics.drawRect(0,0,stageWidth,stageHeight);
        graphics.endFill();
    }

    private function completeListener_saveConfigFile(event:Event):void {
        trace("completeListener_saveConfigFile");
        finalStep();
    }


    private function clickListener_selectPath (event:MouseEvent):void {
        trace("clickListener_selectPath");
        directory.browseForDirectory("Final");
    }

    private function clickListener_btnSaveConfig (event:MouseEvent):void {
        trace("clickListener_btnSaveConfig");
        config.addEventListener(Event.COMPLETE, completeListener_saveConfigFile);
        config.save(config.data);
    }

    private function clickListener_btnStart (event:MouseEvent):void {
        dispatchEvent(new flash.events.Event (Event.COMPLETE));
    }

    private function handleSelect(event:Object):void {
        trace("handleSelect");
        config.data.path = directory.nativePath;
        showPath(config.data.path);
        saveConfigStep();
    }

    private function handleCancel(event:Object):void {
        trace("handleCancel");
    }
}
}
