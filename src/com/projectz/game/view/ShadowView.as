/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 24.03.13
 * Time: 12:39
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.utils.objectEditor.data.PartData;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class ShadowView extends Sprite {

    protected var _object: PartData;
    protected var _parent: PositionView
    private var _bg: Image;

    public function ShadowView($shadow: PartData, $parent: PositionView) {
        _object = $shadow;
        _parent = $parent;

        pivotX = PositionView.cellWidth/2;
        pivotY = PositionView.cellHeight/2;

        if ($shadow.states[PartData.SHADOW]) {
            setView($shadow.states[PartData.SHADOW]);
        }
    }

    public function updatePosition():void {
        x = _parent.x;
        y = _parent.y;
    }

    protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.pivotX;
        _bg.pivotY = _bg.height/2+_object.pivotY;
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
