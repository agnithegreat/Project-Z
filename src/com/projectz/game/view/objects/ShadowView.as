/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 24.03.13
 * Time: 12:39
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.objects {
import com.projectz.game.view.*;
import com.projectz.utils.objectEditor.data.PartData;

import starling.core.Starling;
import starling.events.Event;
import starling.display.Image;
import starling.textures.Texture;

public class ShadowView extends PositionView {

    protected var _object: PartData;
    protected var _parent: PositionView

    override public function get positionX():Number {
        return _parent.x;
    }
    override public function get positionY():Number {
        return _parent.y;
    }

    public function ShadowView($shadow: PartData, $parent: PositionView) {
        _object = $shadow;
        _parent = $parent;
        _parent.addEventListener(Event.COMPLETE, handleDestroy);

        super();

        if ($shadow.states[PartData.SHADOW]) {
            setView($shadow.states[PartData.SHADOW]);
        }
    }

    public function updatePosition():void {
        x = positionX;
        y = positionY;
    }

    protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.pivotX;
        _bg.pivotY = _bg.height/2+_object.pivotY;
        addChild(_bg);
    }

    private function handleDestroy():void {
        Starling.juggler.tween(this, 1, {
            alpha: 0,
            onComplete: dispatchDestroy
        });
    }

    override public function destroy():void {
        super.destroy();

        _object = null;

        _parent.removeEventListeners();
        _parent = null;

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
