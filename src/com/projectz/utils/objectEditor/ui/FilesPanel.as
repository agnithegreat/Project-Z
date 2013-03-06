/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import flash.filesystem.File;

import starling.display.Quad;
import starling.display.Sprite;

public class FilesPanel extends Sprite {

    private var _bg: Quad;

    private var _filesList: Sprite;

    public function FilesPanel() {
        _bg = new Quad(200, Constants.HEIGHT, 0xCCCCCC);
        addChild(_bg);

        _filesList = new Sprite();
        addChild(_filesList);
    }

    public function showFiles($files: Vector.<File>):void {
        var len: int = $files.length;
        var line: FileLine;
        for (var i:int = 0; i < len; i++) {
            line = new FileLine($files[i]);
            line.y = i*20;
            _filesList.addChild(line);
        }
    }
}
}
