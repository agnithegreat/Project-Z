/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.05.13
 * Time: 12:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.events.editAssets {

import com.projectz.utils.levelEditor.model.objects.FieldObject;

import starling.events.Event;

public class EditAssetEvent extends Event {

    private var _fieldObject:FieldObject;

    public static const ASSET_WAS_CHANGED:String = "asset was changed";

    public function EditAssetEvent (objectData:FieldObject, type:String, bubbles:Boolean = false):void {
        this.fieldObject = objectData;
        super (type, bubbles, objectData);
    }

    public function get fieldObject():FieldObject {
        return _fieldObject;
    }

    public function set fieldObject(value:FieldObject):void {
        _fieldObject = value;
    }



}
}
