/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import flash.filesystem.File;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class FileLine extends Sprite {

    public static const SELECT_FILE: String = "select_file_FileLine";

    private var _file: File;

    private var _tf: TextField;

    public function FileLine($file: File) {
        _file = $file;

        _tf = new TextField(200, 20, _file.name);
        addChild(_tf);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(this, TouchPhase.ENDED)) {
            dispatchEventWith(SELECT_FILE, true, _file);
        }
    }
}
}
