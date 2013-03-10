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

import flash.ui.Keyboard;

import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var _assets: AssetManager;

    private var _container: Sprite;

    private var _cells: Sprite;
    private var _objects: Sprite;

    private var _currentObject: ObjectData;
    private var _currentPart: ObjectView;

    public function FieldView($assets: AssetManager) {
        _assets = $assets;

        _container = new Sprite();
        addChild(_container);

        _cells = new Sprite();
        _cells.alpha = 0.3;
        _container.addChild(_cells);

        _objects = new Sprite();
        _objects.pivotY = PositionView.cellHeight;
        _objects.alpha = 0.7;
        _container.addChild(_objects);
    }

    private function showField():void {
        var cell: CellView;
        while (_cells.numChildren>0) {
            cell = _cells.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }

        for (var i:int = 0; i < _currentObject.width; i++) {
            for (var j:int = 0; j < _currentObject.height; j++) {
                cell = new CellView(_assets.getTexture("so-cell"));
                cell.x = (j-i)*PositionView.cellWidth*0.5;
                cell.y = (j+i)*PositionView.cellHeight*0.5;
                _cells.addChild(cell);
            }
        }

        _container.x = (Constants.WIDTH-200+PositionView.cellWidth)*0.5;
        _container.y = (Constants.HEIGHT+200+(1-(_currentObject.height+_currentObject.width)*0.5)*PositionView.cellHeight)*0.5;
    }

    public function addObject($object: ObjectData):void {
        var obj: ObjectView;
        while (_objects.numChildren>0) {
            obj = _objects.getChildAt(0) as ObjectView;
            obj.destroy();
            obj.removeFromParent(true);
        }

        _currentObject = $object;
        var part: PartData;
        for each (part in _currentObject.parts) {
            _currentPart = new ObjectView(part);
            _objects.addChild(_currentPart);
        }

        showField();

        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
    }

    public function addX():void {
        if (!_currentObject) {
            return;
        }
        _currentObject.size(_currentObject.width+1, _currentObject.height);
        showField();
    }
    public function subX():void {
        if (!_currentObject) {
            return;
        }
        _currentObject.size(Math.max(1, _currentObject.width-1), _currentObject.height);
        showField();
    }
    public function addY():void {
        if (!_currentObject) {
            return;
        }
        _currentObject.size(_currentObject.width, _currentObject.height+1);
        showField();
    }
    public function subY():void {
        if (!_currentObject) {
            return;
        }
        _currentObject.size(_currentObject.width, Math.max(1, _currentObject.height-1));
        showField();
    }
    public function save():void {
        if (!_currentObject) {
            return;
        }
        _currentObject.save();
    }

    private function handleKeyDown($event: KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.LEFT:
                _currentPart.partData.place(_currentPart.partData.pivotX+1, _currentPart.partData.pivotY);
                break;
            case Keyboard.RIGHT:
                _currentPart.partData.place(_currentPart.partData.pivotX-1, _currentPart.partData.pivotY);
                break;
            case Keyboard.UP:
                _currentPart.partData.place(_currentPart.partData.pivotX, _currentPart.partData.pivotY+1);
                break;
            case Keyboard.DOWN:
                _currentPart.partData.place(_currentPart.partData.pivotX, _currentPart.partData.pivotY-1);
                break;
            case Keyboard.TAB:
                _currentPart = _objects.getChildAt((_objects.getChildIndex(_currentPart)+1)%_objects.numChildren) as ObjectView;
                break;
        }
        _currentPart.update();
    }

    public function destroy():void {
        removeEventListeners();

        stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);

        var cell: CellView;
        while (_cells.numChildren>0) {
            cell = _cells.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }
        _cells.removeFromParent(true);
        _cells = null;

        var object: ObjectView;
        while (_objects.numChildren>0) {
            object = _objects.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _objects.removeFromParent(true);
        _objects = null;

        _container.removeFromParent(true);
        _container = null;
    }
}
}
