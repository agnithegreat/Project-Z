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

    private var _cell:Cell;
    public function get cell():Cell {
        return _cell;
    }

    override public function get positionX():Number {
        return _cell.x;
    }

    override public function get positionY():Number {
        return _cell.y;
    }

    private var _showLock:Boolean = false;

    protected var _bg:Image;
    protected var _lockBg:Image;

    private static const ROLL_OUT_ALPHA:Number = .3;
    private static const ROLL_OVER_ALPHA:Number = .5;
    private static const ROLL_MOUSE_DOWN:Number = .6;
    private static const ROLL_CLICK:Number = .7;

    public function CellView($cell:Cell, $texture:Texture, $lockTexture:Texture = null) {
        _cell = $cell;

        super();

        if ($texture) {
            setView($texture);
        }
        if ($lockTexture) {
            setLockView($lockTexture);
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

    public function get showLock():Boolean {
        return _showLock;
    }

    public function set showLock(value:Boolean):void {
        _showLock = value;
        if (_lockBg) {
            _lockBg.visible = _showLock;
        }
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

    protected function setLockView($lockTexture:Texture):void {
        _lockBg = new Image($lockTexture);
        _lockBg.pivotX = _bg.width / 2;
        _lockBg.pivotY = _bg.height / 2;
        _lockBg.alpha = .7;
        _lockBg.visible = false;
        addChild(_lockBg);
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
