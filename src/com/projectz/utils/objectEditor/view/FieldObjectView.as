/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 21:22
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.StarlingUtils;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;

import flash.display.BitmapData;

import flash.geom.Point;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldObjectView extends Sprite {

    private var _editWalkableMode:Boolean = true;
    private var _editShotableMode:Boolean = false;

    private var _assets: AssetManager;

    private var _object: ObjectData;
    public function get object():ObjectData {
        return _object;
    }

    private var _container: Sprite;
    private var _cells: Sprite;

    private var _objects: Sprite;

    private var _currentPart: ObjectView;

    private var _selectMode: int = -1;

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

    public function addX():void {
        _object.setSize(_object.width+1, _object.height);
        showField();
    }
    public function subX():void {
        _object.setSize(Math.max(1, _object.width-1), _object.height);
        showField();
    }
    public function addY():void {
        _object.setSize(_object.width, _object.height+1);
        showField();
    }
    public function subY():void {
        _object.setSize(_object.width, Math.max(1, _object.height-1));
        showField();
    }
    public function save():void {
        _object.saveAs(_object.export());
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

    public function convertToBitmapData (backgroundColor:uint = 0xffffff):BitmapData {
        init ();
        _objects.alpha = 1;
        var bitmapData:BitmapData = StarlingUtils.asBitmapData(this, backgroundColor);
        return bitmapData;
    }

    public function get editWalkableMode():Boolean {
        return _editWalkableMode;
    }

    public function set editWalkableMode(value:Boolean):void {
        _editWalkableMode = value;
    }

    public function get editShotableMode():Boolean {
        return _editShotableMode;
    }

    public function set editShotableMode(value:Boolean):void {
        _editShotableMode = value;
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
        if (_object.shadow) {
            _objects.addChild(new ObjectView(_object.shadow));
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
                cell = new CellView(new Point(i, j), _assets.getTexture("ms-cell"));
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
            if (
                    _currentPart &&
                    _currentPart.partData.name!=PartData.SHADOW
            ) {
                //используем для отрисовки данные части (currentPart):
                cell.alpha = _currentPart.partData.mask[cell.position.x][cell.position.y];
            }
            else {
                //используем для отрисовки данные объекта (_object):
                cell.alpha = _object.mask[cell.position.x][cell.position.y];
            }
        }
    }

    private function handleTouch($event: TouchEvent):void {
        var touch: Touch = $event.getTouch(_cells);
        if (touch) {
            var pos: Point = touch.getLocation(_cells).add(new Point(PositionView.cellWidth*0.5, PositionView.cellHeight*0.5));
            if (_currentPart) {
                var tx: Number = pos.x/PositionView.cellWidth;
                var ty: Number = pos.y/PositionView.cellHeight;
                var cx: int = Math.round(ty-tx);
                var cy: int = Math.round(cx+tx*2);
                if ((cx < _currentPart.width) && (cy < _currentPart.height)) {
                    if (touch.phase == TouchPhase.BEGAN) {
                        if (_currentPart.partData.name!=PartData.SHADOW) {
                            _selectMode = 1-_currentPart.partData.getWalkable(cx, cy);
                        }
                    } else if (touch.phase == TouchPhase.ENDED) {
                        _selectMode = -1;
                    }
                    if (_selectMode >= 0) {
                        // TODO: вынести в панель редактора
                        _currentPart.partData.setWalkable(cx, cy, _selectMode);
                        updateField();
                    }
                }

            }
        }
    }

}
}
