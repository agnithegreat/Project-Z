/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.05.13
 * Time: 11:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editAssets {

import com.projectz.utils.objectEditor.data.ObjectData;

import starling.events.Event;

public class SelectAssetEvent extends Event {

    private var _objectData:ObjectData;

    public static const SELECT_ASSET:String = "select asset";

    public function SelectAssetEvent(objectData:ObjectData, type:String = SELECT_ASSET, bubbles:Boolean = false) {
        this.objectData = objectData;
        super (type, bubbles, objectData);
    }

    public function get objectData():ObjectData {
        return _objectData;
    }

    public function set objectData(value:ObjectData):void {
        _objectData = value;
    }
}
}
