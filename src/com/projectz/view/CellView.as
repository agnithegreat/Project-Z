/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Cell;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CellView extends PositionView {

    protected var _cell: Cell;
    override public function get positionX():Number {
        return _cell.x;
    }
    override public function get positionY():Number {
        return _cell.y;
    }

    private var _bg: Image;

    public function CellView($cell: Cell, $texture: String = null) {
        _cell = $cell;

        super();

        if ($texture) {
            _bg = new Image(App.assets.getTexture($texture));
            _bg.pivotX = _bg.width/2;
            _bg.pivotY = _bg.height-cellHeight;
            addChild(_bg);
        }

//        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(event:TouchEvent):void {
        var touch: Touch = event.getTouch(event.target as DisplayObject, TouchPhase.MOVED);
        _bg.color = touch ? 0x00FF00 : 0x000000;
    }

    override public function destroy():void {
        super.destroy();

        _cell = null;

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
