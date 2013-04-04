/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.objects {
import com.projectz.game.event.GameEvent;
import com.projectz.game.view.*;
import com.projectz.game.model.objects.FieldObject;

import starling.core.Starling;

import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

public class ObjectView extends PositionView {

    protected var _object: FieldObject;
    private var _part: String;

    private var _animated:Boolean;

    public function get offsetX():int {
        return (_object.data.top.y-_object.data.top.x)*PositionView.cellWidth*0.5;
    }

    public function get offsetY():int {
        return (_object.data.top.y+_object.data.top.x)*PositionView.cellHeight*0.5;
    }

    override public function get depth():Number {
        return _object.cell.depth;
    }

    public function ObjectView($object: FieldObject, $part: String = "") {
        _object = $object;
        _object.addEventListener(GameEvent.DAMAGE, handleDamage);
        _part = $part;

        _cell = _object.cell;

        super();

        setView(_object.data.states[_part]);
    }

    protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.data.pivotX+offsetX;
        _bg.pivotY = _bg.height/2+_object.data.pivotY+offsetY;
        addChild(_bg);
    }

    private function handleDamage($event: Event):void {
        if (!_animated) {
            deformation();
        }
    }

    private function deformation():void {
        _animated = true;
        Starling.juggler.tween(this, 0.2, {
            skewY: -0.02,
            onComplete: formation
        });
    }
    private function formation():void {
        Starling.juggler.tween(this, 0.5, {
            skewY: 0,
            onComplete: endFormation
        });
    }

    private function endFormation():void {
        _animated = false;
    }

    override public function destroy():void {
        super.destroy();

        _object = null;
    }
}
}
