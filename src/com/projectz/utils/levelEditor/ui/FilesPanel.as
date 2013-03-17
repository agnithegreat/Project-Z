/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.utils.Dictionary;

import starling.display.Button;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class FilesPanel extends Sprite {

    private var _storage: ObjectsStorage;
    private var _tab:String;

    private var _bg: Quad;

    private var _filesList: Sprite;

    private var _bgTab: Button;
    private var _staticTab: Button;
    private var _animatedTab: Button;
    private var _defendersTab: Button;
    private var _enemiesTab: Button;

    private var _files: Array;

    public function FilesPanel() {
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

        _defendersTab = new Button(texture, "de");
        _defendersTab.addEventListener(Event.TRIGGERED, handleClick);
        _defendersTab.x = 120;
        addChild(_defendersTab);

        _enemiesTab = new Button(texture, "en");
        _enemiesTab.addEventListener(Event.TRIGGERED, handleClick);
        _enemiesTab.x = 160;
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
            _files.push(new FileLine(object));
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
                showTab(ObjectData.BACKGROUND);
                break;
            case _staticTab:
                showTab(ObjectData.STATIC_OBJECT);
                break;
            case _animatedTab:
                showTab(ObjectData.ANIMATED_OBJECT);
                break;
            case _defendersTab:
                showTab(ObjectData.DEFENDER);
                break;
            case _enemiesTab:
                showTab(ObjectData.ENEMY);
                break;
        }
    }
}
}
