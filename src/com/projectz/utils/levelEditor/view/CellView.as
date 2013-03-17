/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {
import com.projectz.utils.levelEditor.model.Cell;

import flash.display.Shape;
import flash.events.MouseEvent;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;

public class CellView extends PositionView {

    private var _color:uint;

    protected var _cell:Cell;

    override public function get positionX():Number {
        return _cell.x;
    }

    override public function get positionY():Number {
        return _cell.y;
    }

    protected var _bg:Image;

    public function CellView($cell:Cell, $texture:Texture) {
        _cell = $cell;

        super();

        if ($texture) {
            setView($texture);
        }

//        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        _color = value;
    }

    public function setAlpha(value:Number):void {
        _bg.alpha = value;
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    protected function setView($texture:Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width / 2;
        _bg.pivotY = _bg.height / 2;
        _bg.alpha = .1;
        addChild(_bg);
    }

    private function handleTouch(event:TouchEvent):void {
//        var touch: Touch = event.getTouch(event.target as DisplayObject, TouchPhase.MOVED);
//        trace ("CELL (" + positionX + ":" + positionY + ") INFO: x = " + x + "; y = " + y);
//        _bg.color = touch ? 0x00FF00 : 0x000000;
//        _bg.alpha = .3;

        if (event.getTouch(this, TouchPhase.HOVER)) {
            // rollover code goes here
            _bg.alpha = .3;
        }
        else {
            // rollout code goes here
            _bg.alpha = .1;
        }

        if (event.getTouch(this, TouchPhase.ENDED)) {
            // click code goes here
            _bg.alpha = .5;
        }
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
