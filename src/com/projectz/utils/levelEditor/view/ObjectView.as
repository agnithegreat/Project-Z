/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {

import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;

import starling.display.Image;
import starling.events.Event;
import starling.textures.Texture;

public class ObjectView extends CellView {

    protected var _object: FieldObject;
    public function get object():FieldObject {
        return _object;
    }

    private var _part: String;

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
        _part = $part;

        _object.addEventListener(GameEvent.DESTROY, handleDestroy);

        super(_object.cell, _object.data.states[_part]);
    }

    override protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2+_object.data.pivotX+offsetX;
        _bg.pivotY = _bg.height/2+_object.data.pivotY+offsetY;
        addChild(_bg);
    }

    private function handleDestroy($event: Event):void {
        dispatchDestroy();
    }

    override public function destroy():void {
        super.destroy();

        _object.removeEventListeners();
        _object = null;
    }
}
}
