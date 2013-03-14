/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import com.projectz.utils.data.ObjectData;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class FileLine extends Sprite {

    public static const SELECT_FILE: String = "select_file_FileLine";

    private var _data: ObjectData;
    override public function get name():String {
        return _data.name;
    }

    private var _tf: TextField;

    public function FileLine($data: ObjectData) {
        _data = $data;

        _tf = new TextField(200, 20, _data.name);
        _tf.color = _data.exists ? 0x009900 : 0x990000;
        addChild(_tf);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(this, TouchPhase.ENDED)) {
            dispatchEventWith(SELECT_FILE, true, _data);
        }
    }
}
}
