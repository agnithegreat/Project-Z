/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {
import com.projectz.utils.levelEditor.model.objects.FieldObject;

import starling.display.Image;
import starling.textures.Texture;

public class ShadowView extends CellView {

    protected var _object: FieldObject;

    public function ShadowView($object: FieldObject) {
        _object = $object;

        super(_object.cell, _object.data.getPart("shadow").textures[0]);
    }

    override protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.data.getPart("shadow").pivotX;
        _bg.pivotY = _bg.height/2+_object.data.getPart("shadow").pivotY;
        addChild(_bg);
    }
}
}
