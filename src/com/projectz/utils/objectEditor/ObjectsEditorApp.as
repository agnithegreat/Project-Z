/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
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

        var description: File = File.applicationDirectory.resolvePath("textures");
        var listing: Vector.<File> = getFilesRecursive(description);

        _ui.filesPanel.showFiles(listing);
    }

    private function handleSelectObject($event: Event):void {
        _model.addObject(($event.data as File).name.replace(".png", ""));
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
