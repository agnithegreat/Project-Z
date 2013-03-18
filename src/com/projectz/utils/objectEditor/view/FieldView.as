/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 21:22
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;

import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var _assets: AssetManager;

    private var _currentObject: FieldObjectView;
    public function get currentObject():FieldObjectView {
        return _currentObject;
    }

    public function FieldView($assets: AssetManager) {
        _assets = $assets;

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage($event: Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
    }

    public function addObject($object: ObjectData):void {
        if (_currentObject) {
            _currentObject.destroy();
            _currentObject.removeFromParent(true);
            _currentObject = null;
        }

        _currentObject = new FieldObjectView($object, _assets);
        _currentObject.x = (Constants.WIDTH-200+PositionView.cellWidth)*0.5;
        _currentObject.y = (Constants.HEIGHT+200+(1-($object.height+$object.width)*0.5)*PositionView.cellHeight)*0.5;
        addChild(_currentObject);
    }

    private function handleKeyDown($event: KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.LEFT:
                _currentObject.moveParts(-1, 0);
                break;
            case Keyboard.RIGHT:
                _currentObject.moveParts(1, 0);
                break;
            case Keyboard.UP:
                _currentObject.moveParts(0, -1);
                break;
            case Keyboard.DOWN:
                _currentObject.moveParts(0, 1);
                break;
        }
    }

    public function destroy():void {
        removeEventListeners();

        stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
    }
}
}
