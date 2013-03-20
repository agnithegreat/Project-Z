/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class FileLine extends Sprite {

    private var controller:LevelEditorController;

    private var _data: ObjectData;
    override public function get name():String {
        return _data.name;
    }

    private var _tf: TextField;

    public function FileLine($data: ObjectData, $controller: LevelEditorController) {
        _data = $data;
        controller = $controller;

        _tf = new TextField(200, 20, _data.name);
        _tf.color = _data.exists ? 0x009900 : 0x990000;
        addChild(_tf);

        useHandCursor = true;

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(this, TouchPhase.ENDED)) {
            if (_data.type == ObjectData.BACKGROUND) {
                controller.selectBackground(_data);
            }
            else {
                controller.selectObject(_data);
            }
        }
    }
}
}
