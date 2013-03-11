/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.objects.FieldObject;

import starling.display.Image;
import starling.textures.Texture;

public class ObjectView extends CellView {

    protected var _object: FieldObject;
    private var _part: String;

    override public function get depth():Number {
        return _object.depth;
    }

    public function ObjectView($object: FieldObject, $part: String = "") {
        _object = $object;
        _part = $part;

        super(_object.cell, _object.data.states[$part]);
    }

    override protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.data.pivotX;
        _bg.pivotY = _bg.height/2+_object.data.pivotY;
        addChild(_bg);
    }

    override public function destroy():void {
        super.destroy();

        _object = null;
    }
}
}
