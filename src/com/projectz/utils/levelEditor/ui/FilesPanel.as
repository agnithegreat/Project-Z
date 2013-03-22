/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.utils.Dictionary;

import starling.display.Button;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class FilesPanel extends Sprite {

    private var uiController:UIController;

    private var _storage: ObjectsStorage;
    private var _tab:String;

    private var _bg: Quad;

    private var _filesList: Sprite;

    private var _bgTab: Button;
    private var _staticTab: Button;
    private var _animatedTab: Button;
    private var _enemiesTab: Button;

    private var _files: Array;

    public function FilesPanel(uiController:UIController) {
        this.uiController = uiController;
        uiController.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);

        _bg = new Quad(200, Constants.HEIGHT, 0xCCCCCC);
        addChild(_bg);

        var texture: Texture = Texture.fromColor(40, 40, 0xCCCCCC);

        _bgTab = new Button(texture, "bg");
        _bgTab.addEventListener(Event.TRIGGERED, handleClick);
        addChild(_bgTab);

        _staticTab = new Button(texture, "so");
        _staticTab.addEventListener(Event.TRIGGERED, handleClick);
        _staticTab.x = 40;
        addChild(_staticTab);

        _animatedTab = new Button(texture, "ao");
        _animatedTab.addEventListener(Event.TRIGGERED, handleClick);
        _animatedTab.x = 80;
        addChild(_animatedTab);

        _enemiesTab = new Button(texture, "en");
        _enemiesTab.addEventListener(Event.TRIGGERED, handleClick);
        _enemiesTab.x = 120;
        addChild(_enemiesTab);

        _filesList = new Sprite();
        _filesList.y = 50;
        addChild(_filesList);
    }

    public function showFiles($names: ObjectsStorage):void {
        _storage = $names;
        showTab(ObjectData.STATIC_OBJECT);
    }

    private function showTab($tab: String):void {
        _tab = $tab;

        _files = [];
        var object: ObjectData;
        var objects: Dictionary = _storage.getType(_tab);
        for each (object in objects) {
            _files.push(new FileLine(object, uiController));
        }
        _files.sortOn("name");

        showPage();
    }

    private function showPage():void {
        _filesList.removeChildren();

        var len: int = _files.length;
        var line: FileLine;
        for (var i:int = 0; i < len; i++) {
            line = _files[i];
            line.y = i*25;
            _filesList.addChild(line);
        }
    }

    private function handleClick($event: Event):void {
        switch ($event.currentTarget) {
            case _bgTab:
                uiController.selectCurrentObjectType(ObjectData.BACKGROUND);
                break;
            case _staticTab:
                uiController.selectCurrentObjectType(ObjectData.STATIC_OBJECT);
                break;
            case _animatedTab:
                uiController.selectCurrentObjectType(ObjectData.ANIMATED_OBJECT);
                break;
            case _enemiesTab:
                uiController.selectCurrentObjectType(ObjectData.ENEMY);
                break;
        }
    }

    private function selectObjectsTypeListener (event:SelectObjectsTypeEvent):void {
        showTab(event.objectsType);
    }
}
}
