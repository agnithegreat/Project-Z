/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:51
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.display.Quad;
import starling.display.Sprite;

public class FilesPanel extends Sprite {

    private var _bg: Quad;

    private var _filesList: Sprite;

    private var _files: Array;

    public function FilesPanel() {
        _bg = new Quad(200, Constants.HEIGHT, 0xCCCCCC);
        addChild(_bg);

        _files = [];

        _filesList = new Sprite();
        addChild(_filesList);
    }

    public function showFiles($names: ObjectsStorage):void {
        var object: ObjectData;
        for each (object in $names.getFolder("level_elements")) {
            _files.push(new FileLine(object));
        }
        _files.sortOn("name");

        showPage();
    }

    public function showPage():void {
        var len: int = _files.length;
        var line: FileLine;
        for (var i:int = 0; i < len; i++) {
            line = _files[i];
            line.y = i*25;
            _filesList.addChild(line);
        }
    }
}
}
