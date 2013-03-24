/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 24.03.13
 * Time: 12:39
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.PartData;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class ShadowView extends Sprite {

    protected var _object: FieldObject;
    private var _bg: Image;

    public function get offsetX():int {
        return (_object.data.top.y-_object.data.top.x)*PositionView.cellWidth*0.5;
    }

    public function get offsetY():int {
        return (_object.data.top.y+_object.data.top.x)*PositionView.cellHeight*0.5;
    }

    public function ShadowView($object: FieldObject, $shadow: PartData) {
        _object = $object;

        pivotX = PositionView.cellWidth/2;
        pivotY = PositionView.cellHeight/2;

        if ($shadow.states[PartData.SHADOW]) {
            setView($shadow.states[PartData.SHADOW]);
        }
    }

    public function updatePosition():void {
        x = (_object.positionY-_object.positionX)*PositionView.cellWidth*0.5;
        y = (_object.positionY+_object.positionX)*PositionView.cellHeight*0.5;
    }

    protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _object.data.pivotX+offsetX;
        _bg.pivotY = _object.data.pivotY+offsetY;
        addChild(_bg);
    }

    public function destroy():void {
        _object = null;
        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
