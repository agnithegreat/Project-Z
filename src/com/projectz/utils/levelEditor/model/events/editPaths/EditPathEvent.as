/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.03.13
 * Time: 15:14
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editPaths {
import com.projectz.utils.levelEditor.data.PathData;

import starling.events.Event;

public class EditPathEvent extends Event {

    private var _pathData:PathData;

    public static const PATH_WAS_CHANGED:String = "path was changed";

    public function EditPathEvent(pathData:PathData, type:String = PATH_WAS_CHANGED, bubbles:Boolean = false) {
        this.pathData = pathData;
        super(type, bubbles, pathData);
    }

    public function get pathData():PathData {
        return _pathData;
    }

    public function set pathData(value:PathData):void {
        _pathData = value;
    }
}
}
