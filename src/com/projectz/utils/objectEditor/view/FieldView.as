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
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
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
        _objects.touchable = false;
        _objects.alpha = 0.5;
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
                cell.x = (j-i)*PositionView.cellWidth*0.5;   // TODO: WTF? {x=0, y=0}
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
            _objects.addChild(new ObjectView(part));
        }

        showField();

        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    public function showPart($part: PartData):void {
        _currentPart = null;
        var len: int = _objects.numChildren;
        var child: ObjectView;
        for (var i:int = 0; i < len; i++) {
            child = _objects.getChildAt(i) as ObjectView;
            child.visible = $part==child.partData || !$part;
            if ($part==child.partData) {
                _currentPart = child;
            }
        }
        if (_currentPart) {
            _currentPart.update();
        }
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
                moveParts(-1, 0);
                break;
            case Keyboard.RIGHT:
                moveParts(1, 0);
                break;
            case Keyboard.UP:
                moveParts(0, -1);
                break;
            case Keyboard.DOWN:
                moveParts(0, 1);
                break;
        }
    }

    private function handleTouch($event: TouchEvent):void {
        var touch: Touch = $event.getTouch(_cells, TouchPhase.BEGAN);
        if (touch) {
            var pos: Point = touch.getLocation(_cells).add(new Point(PositionView.cellWidth*0.5, PositionView.cellHeight*0.5));
            if (_currentPart) {
                var tx: Number = pos.x/PositionView.cellWidth;
                var ty: Number = pos.y/PositionView.cellHeight;
                var cx: int = Math.round(ty-tx);
                var cy: int = Math.round(cx+tx*2);
                _currentPart.partData.invertCellState(cx, cy);
            }
        }
    }

    private function moveParts($dx: int, $dy: int):void {
        var len: int = _objects.numChildren;
        var child: ObjectView;
        for (var i:int = 0; i < len; i++) {
            child = _objects.getChildAt(i) as ObjectView;
            if (_currentPart==child || !_currentPart) {
                child.partData.place(child.partData.pivotX-$dx, child.partData.pivotY-$dy);
                child.update();
            }
        }
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
