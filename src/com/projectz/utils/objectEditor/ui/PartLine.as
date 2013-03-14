/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.03.13
 * Time: 12:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import com.projectz.utils.data.PartData;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class PartLine extends Sprite {

    public static const SELECT_PART: String = "select_part_PartLine";

    private var _data: PartData;
    override public function get name():String {
        return _data ? (_data.name ? _data.name : "front") : "all";
    }

    private var _tf: TextField;

    public function PartLine($data: PartData) {
        _data = $data;

        _tf = new TextField(200, 20, name);
        addChild(_tf);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(this, TouchPhase.ENDED)) {
            dispatchEventWith(SELECT_PART, true, _data);
        }
    }
}
}
