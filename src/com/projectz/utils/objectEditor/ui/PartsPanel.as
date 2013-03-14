/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import flash.utils.Dictionary;

import starling.display.Sprite;

import com.projectz.utils.data.PartData;

public class PartsPanel extends Sprite {

    private var _partsList: Sprite;

    private var _parts: Array;

    public function PartsPanel() {
        _partsList = new Sprite();
        addChild(_partsList);
    }

    public function showParts($parts: Dictionary):void {
        _parts = [];
        var part: PartData;
        for each (part in $parts) {
            _parts.push(new PartLine(part));
        }
        _parts.push(new PartLine(null));
        _parts.sortOn("name");

        showPage();
    }

    public function showPage():void {
        _partsList.removeChildren(0, -1, true);

        var line: PartLine;
        var len: int = _parts.length;
        for (var i:int = 0; i < len; i++) {
            line = _parts[i];
            line.y = i*25;
            _partsList.addChild(line);
        }
    }
}
}
