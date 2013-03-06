/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.model {
import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.EventDispatcher;

public class FieldObject extends EventDispatcher {

    protected var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    public function get positionX():Number {
        return _cell.x;
    }
    public function get positionY():Number {
        return _cell.y;
    }

    private var _data: ObjectData;
    public function get data():ObjectData {
        return _data;
    }

    public function FieldObject($data: ObjectData) {
        _data = $data;

        if (!_data.exists) {
            _data.save();
        }
    }

    public function place($cell: Cell):void {
        _cell = $cell;
    }

    public function destroy():void {
        _cell = null;
    }
}
}
