/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.model.Field;
import com.projectz.utils.objectEditor.ui.FileLine;
import com.projectz.utils.objectEditor.ui.UI;
import com.projectz.utils.objectEditor.view.FieldView;

import flash.filesystem.File;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class ObjectsEditorApp extends Sprite {

    public static var assets: AssetManager;

    private var _model: Field;
    private var _view: FieldView;
    private var _ui: UI;

    public function ObjectsEditorApp() {
    }

    public function start($assets: AssetManager):void {
        assets = $assets;
        assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            Starling.juggler.delayCall(edit, 0.15);
        }
    }

    private function edit():void {
        _model = new Field(1, 1);
        _model.init();

        _view = new FieldView(_model);
        addChild(_view);

        _ui = new UI();
        _ui.addEventListener(FileLine.SELECT_FILE, handleSelectObject);
        addChild(_ui);

        var staticObjects: File = File.applicationDirectory.resolvePath("textures/1x/level_elements/static_objects");
        var listing: Vector.<File> = getFilesRecursive(staticObjects);
        var files: Array = filterFiles(staticObjects, listing);

        _ui.filesPanel.showFiles(files);
    }

    private function filterFiles($parent: File, $files: Vector.<File>):Array {
        var names: Object = {};
        var fileNames: Object = {};

        var len: int = $files.length;
        var name: String;
        var fileName: String;
        for (var i:int = 0; i < len; i++) {
            fileName = $files[i].name;
            fileNames[fileName] = $files[i];
            name = getFileName(fileName);
            names[name] = name;
        }

        var files: Array = [];
        for (name in names) {
            files.push(new ObjectData(name, $parent.resolvePath(name+".json")));
        }
        files.sortOn("name");
        return files;
    }

    private function handleSelectObject($event: Event):void {
        var data: ObjectData = $event.data as ObjectData;
        _model.addObject(data);
    }

    private function getFileName($name: String):String {
        $name = $name.split(".")[0];
        $name = $name.replace("_front");
        $name = $name.replace("_back");
        $name = $name.replace("_shadow");
        return $name;
    }

    private function getFilesRecursive($file: File):Vector.<File> {
        var fileList: Vector.<File> = new <File>[];
        var files: Array = $file.getDirectoryListing();
        var len: int = files.length;
        var file: File;
        for (var i:int = 0; i < len; i++) {
            file = $file.resolvePath(files[i].name);
            if (files[i].isDirectory) {
                if (files[i].name !="." && files[i].name !="..") {
                    fileList = fileList.concat(getFilesRecursive(file));
                }
            } else {
                fileList.push(file);
            }
        }
        return fileList;
    }
}
}
