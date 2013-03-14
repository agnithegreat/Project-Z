/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
import com.projectz.utils.data.ObjectData;
import com.projectz.utils.data.PartData;
import com.projectz.utils.objectEditor.ui.FileLine;
import com.projectz.utils.objectEditor.ui.PartLine;
import com.projectz.utils.objectEditor.ui.UI;
import com.projectz.utils.objectEditor.view.FieldView;
import com.projectz.utils.data.ObjectsStorage;

import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;

    private var _view: FieldView;
    private var _ui: UI;

    public function App() {
        _objectsStorage = new ObjectsStorage();
    }

    public function start($assets: AssetManager):void {
        _assets = $assets;
        _assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            _objectsStorage.parseDirectory("textures/{0}x/level_elements", _assets);

            Starling.juggler.delayCall(edit, 0.15);
        }
    }

    private function edit():void {
        _view = new FieldView(_assets);
        addChild(_view);

        _ui = new UI(_assets);
        _ui.addEventListener(FileLine.SELECT_FILE, handleOperation);
        _ui.addEventListener(PartLine.SELECT_PART, handleOperation);
        _ui.addEventListener(UI.ADD_X, handleOperation);
        _ui.addEventListener(UI.SUB_X, handleOperation);
        _ui.addEventListener(UI.ADD_Y, handleOperation);
        _ui.addEventListener(UI.SUB_Y, handleOperation);
        _ui.addEventListener(UI.SAVE, handleOperation);
        _ui.addEventListener(UI.EXPORT, handleOperation);
        addChild(_ui);

        _ui.filesPanel.showFiles(_objectsStorage);
    }

    private function parseObjects($objects: Dictionary, $animated: Boolean):void {
        var name: String;
        var obj: ObjectData;
        var part: PartData;
        for (name in $objects) {
            obj = $objects[name] as ObjectData;
            for each (part in obj.parts) {
                if ($animated) {
                    part.addTextures(part.name, _assets.getTextures(part.name));
                } else {
                    part.addTextures(part.name, _assets.getTexture(part.name ? name+"_"+part.name : name));
                }
            }
        }
    }

    private function saveObjectsList($list: Object):void {
        var data: String = JSON.stringify($list);

        var file: File = File.applicationDirectory.resolvePath("textures");
        file.save(data, "filesList.json");
    }

    private function handleOperation($event: Event):void {
        switch ($event.type) {
            case FileLine.SELECT_FILE:
                var data: ObjectData = $event.data as ObjectData;
                _view.addObject(data);
                _ui.partsPanel.showParts(data.parts);
                break;
            case PartLine.SELECT_PART:
                var part: PartData = $event.data as PartData;
                _view.showPart(part);
                break;
            case UI.ADD_X:
                _view.addX();
                break;
            case UI.SUB_X:
                _view.subX();
                break;
            case UI.ADD_Y:
                _view.addY()
                break;
            case UI.SUB_Y:
                _view.subY();
                break;
            case UI.SAVE:
                _view.save();
                break;
            case UI.EXPORT:
                saveObjectsList(_objectsStorage.objectsList);
                break;
        }
    }
}
}
