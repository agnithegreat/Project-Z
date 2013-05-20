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

import flash.display.Sprite;

import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.text.TextField;

import starling.events.Event;

/**
 * Стартовая панель редактора уровней для настройки работы редактора.
 * В этой панели создаётся и сохраняется файлик с конфигом редактора.
 * В файле конфига содержиться ссылка на папку с файлами в dropbox.
 */
public class ConfigPanel extends GraphicStorage {

    private var mcStep1:Sprite;
    private var mcStep2:Sprite;
    private var btnSelectPath:ButtonWithText;
    private var btnStart:ButtonWithText;
    private var btnSaveConfig:ButtonWithText;
    private var tfDropBoxPath:TextField;
    private var tfConfigPath:TextField;

    private var config: JSONLoader;
    private var directory: File;

    public function ConfigPanel(config: JSONLoader, directory: File) {
        super (new mcConfigPanel);
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

        mcStep1 = getElement ("mcStep1");
        mcStep2 = getElement ("mcStep2");
        btnSelectPath = new ButtonWithText (mcStep1 ["btnSelectPath"]);
        tfDropBoxPath = TextField (getElement("tfDropBoxPath", mcStep1));
        btnStart = new ButtonWithText (mc ["btnStart"]);
        btnSaveConfig = new ButtonWithText (mcStep2 ["btnSaveConfig"]);
        tfConfigPath = TextField (getElement("tfConfigPath", mcStep2));


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
        mcStep2.visible = false;
        btnSelectPath.enable = true;
        btnSelectPath.text = "выбрать";
        btnSaveConfig.enable = false;
        btnStart.visible = false;
    }

    private function saveConfigStep ():void {
        mcStep2.visible = true;
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.visible = false;
    }

    private function finalStep ():void {
        btnSelectPath.enable = true;
        btnSelectPath.text = "изменить";
        btnSaveConfig.enable = true;
        btnStart.visible = true;
    }

    private function showDropBoxPath (text:String):void {
        tfDropBoxPath.text = "Путь указан: \n" + text;
    }

    private function showConfigPath (text:String):void {
        tfConfigPath.text = "Путь указан: \n" + text;
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
        showConfigPath(config.path);
        finalStep();
    }


    private function clickListener_selectPath (event:MouseEvent):void {
        trace("clickListener_selectPath");
        directory.browseForDirectory("Final");
    }

    private function clickListener_btnSaveConfig (event:MouseEvent):void {
        trace("clickListener_btnSaveConfig");
        config.addEventListener(Event.COMPLETE, completeListener_saveConfigFile);
        config.saveAs(config.data);
    }

    private function clickListener_btnStart (event:MouseEvent):void {
        dispatchEvent(new flash.events.Event (Event.COMPLETE));
    }

    private function handleSelect(event:Object):void {
        trace("handleSelect");
        config.data.path = directory.nativePath;
        showDropBoxPath(config.data.path);
        saveConfigStep();
    }

    private function handleCancel(event:Object):void {
        trace("handleCancel");
    }
}
}
