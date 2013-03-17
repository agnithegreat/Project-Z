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

    private static const ROLL_OUT_ALPHA:Number = .3;
    private static const ROLL_OVER_ALPHA:Number = .5;
    private static const ROLL_MOUSE_DOWN:Number = .6;
    private static const ROLL_CLICK:Number = .7;

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
        return _bg.color;
    }

    public function set color(value:uint):void {
        _bg.color = value;
    }

    public function onRollOver ():void {
        _bg.alpha = ROLL_OVER_ALPHA;
    }

    public function onRollOut ():void {
        _bg.alpha = ROLL_OUT_ALPHA;
    }

    public function onMouseDown ():void {
        _bg.alpha = ROLL_MOUSE_DOWN;
    }

    public function onClick ():void {
        _bg.alpha = ROLL_CLICK;
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    protected function setView($texture:Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width / 2;
        _bg.pivotY = _bg.height / 2;
        _bg.alpha = ROLL_OUT_ALPHA;
        addChild(_bg);
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
