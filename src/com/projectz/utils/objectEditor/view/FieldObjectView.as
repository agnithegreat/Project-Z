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

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldObjectView extends Sprite {

    private var _assets: AssetManager;

    private var _object: ObjectData;
    public function get object():ObjectData {
        return _object;
    }

    private var _container: Sprite;
    private var _cells: Sprite;

    private var _objects: Sprite;

    private var _currentPart: ObjectView;

    public function FieldObjectView($object: ObjectData, $assets: AssetManager) {
        _object = $object;
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

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }


    private function init():void {
        var obj: ObjectView;
        while (_objects.numChildren>0) {
            obj = _objects.getChildAt(0) as ObjectView;
            obj.destroy();
            obj.removeFromParent(true);
        }

        var part: PartData;
        for each (part in _object.parts) {
            _objects.addChild(new ObjectView(part));
        }

        showField();
    }

    private function handleAddedToStage($event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        stage.addEventListener(TouchEvent.TOUCH, handleTouch);

        init();
    }

    private function showField():void {
        var cell: CellView;
        while (_cells.numChildren>0) {
            cell = _cells.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }

        for (var i:int = 0; i < _object.width; i++) {
            for (var j:int = 0; j < _object.height; j++) {
                cell = new CellView(new Point(i, j), _assets.getTexture("so-cell"));
                _cells.addChild(cell);
            }
        }

        updateField();
    }

    private function updateField():void {
        var cell: CellView;
        var len: int = _cells.numChildren;
        for (var i:int = 0; i < len; i++) {
            cell = _cells.getChildAt(i) as CellView;
            cell.alpha = _currentPart ? _currentPart.partData.mask[cell.position.x][cell.position.y] : _object.mask[cell.position.x][cell.position.y];
        }
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
        updateField();
    }

    public function addX():void {
        _object.size(_object.width+1, _object.height);
        showField();
    }
    public function subX():void {
        _object.size(Math.max(1, _object.width-1), _object.height);
        showField();
    }
    public function addY():void {
        _object.size(_object.width, _object.height+1);
        showField();
    }
    public function subY():void {
        _object.size(_object.width, Math.max(1, _object.height-1));
        showField();
    }
    public function save():void {
        _object.save();
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
                updateField();
            }
        }
    }

    public function moveParts($dx: int, $dy: int):void {
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
