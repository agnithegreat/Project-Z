/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.objectEditor.ui.FileLine;
import com.projectz.utils.objectEditor.ui.PartLine;
import com.projectz.utils.objectEditor.ui.UI;
import com.projectz.utils.objectEditor.view.FieldView;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import flash.filesystem.File;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.formatString;

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
            _objectsStorage.parseDirectory(formatString("textures/{0}x/level_elements", _assets.scaleFactor), _assets);

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
                _view.currentObject.showPart(part);
                break;
            case UI.ADD_X:
                _view.currentObject.addX();
                break;
            case UI.SUB_X:
                _view.currentObject.subX();
                break;
            case UI.ADD_Y:
                _view.currentObject.addY();
                break;
            case UI.SUB_Y:
                _view.currentObject.subY();
                break;
            case UI.SAVE:
                _view.currentObject.save();
                break;
            case UI.EXPORT:
                saveObjectsList(_objectsStorage.objectsList);
                break;
        }
    }
}
}
