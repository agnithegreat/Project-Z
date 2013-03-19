/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {
import com.projectz.event.GameEvent;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var _assets:AssetManager;

    private var _field:Field;

    private var _bg:Image;
    private var _container:Sprite;

    private var _cellsContainer:Sprite;
    private var _shadowsContainer:Sprite;
    private var _objectsContainer:Sprite;

    private var _currentObject: FieldObjectView;

    protected var _isPressed:Boolean;
    protected var _isRolledOver:Boolean;
    protected var _lastCellX:int;
    protected var _lastCellY:int;

    public function FieldView($field:Field, $assets:AssetManager) {
        _assets = $assets;

        _field = $field;
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);
        _field.addEventListener(GameEvent.OBJECT_ADDED, handleAddObject);
        _field.addEventListener(GameEvent.SHADOW_ADDED, handleAddShadow);

        _bg = new Image(_assets.getTexture(_field.level.bg));
        _bg.touchable = false;
        addChild(_bg);

        _container = new Sprite();
        addChild(_container);

        _cellsContainer = new Sprite();
//        _cellsContainer.alpha = 0.1;
        _container.addChild(_cellsContainer);

        var len:int = _field.field.length;
        var cell:CellView;
        for (var i:int = 0; i < len; i++) {
            cell = new CellView(_field.field[i], $assets.getTexture("so-cell-levelEditor"));
            _cellsContainer.addChild(cell);
        }
        _cellsContainer.flatten();

        _container.x = (Constants.WIDTH + PositionView.cellWidth) * 0.5;
        _container.y = (Constants.HEIGHT + (1 - (_field.height + _field.height) * 0.5) * PositionView.cellHeight) * 0.5;

        _shadowsContainer = new Sprite();
        _shadowsContainer.touchable = false;
        _container.addChild(_shadowsContainer);

        _objectsContainer = new Sprite();
        _objectsContainer.touchable = false;
        _container.addChild(_objectsContainer);

        addEventListener(GameEvent.DESTROY, handleDestroy);

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage($event:Event):void {
        stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
    }

    public function selectFile($file:ObjectData):void {
        if ($file.type == ObjectData.BACKGROUND) {
            _field.level.bg = $file.name;
            _bg.texture = _assets.getTexture(_field.level.bg);
        } else {
            addObject($file);
        }
    }

    public function addObject($data: ObjectData):void {
        if (_currentObject) {
            _currentObject.destroy();
            _currentObject.removeFromParent(true);
            _currentObject = null;
        }

        if ($data) {
            _currentObject = new FieldObjectView($data, _assets);
            _container.addChild(_currentObject);
        }
    }

    private function handleAddObject($event:Event):void {
        var fieldObject:FieldObject = $event.data as FieldObject;
        var object:ObjectView = new ObjectView(fieldObject, fieldObject.data.name);
        _objectsContainer.addChild(object);
    }

    private function handleAddShadow($event:Event):void {
        var fieldObject:FieldObject = $event.data as FieldObject;
        if (fieldObject.cell.shadow) {
            var object:PositionView = new ObjectView(fieldObject.cell.shadow, "shadow");
            _shadowsContainer.addChild(object);
        }
    }

    private function handleUpdate($event:Event):void {
        update();
    }

    protected function onTouchHandler(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this);
        if (touch) {
            var cell:CellView = getCellViewByPosition(getPositionByTouchEvent(touch));
            if (cell) {
                if ((cell.positionX != _lastCellX) || (cell.positionY != _lastCellY)) {
//                    trace("!!! " +
//                            "(cell.positionX (" + cell.positionX + ") != _lastCellX (" + _lastCellX + ")) = " +
//                            (cell.positionX != _lastCellX) +
//                            "; (cell.positionY (" + cell.positionY + ") != _lastCellY (" + _lastCellY + ")) = " +
//                            (cell.positionY != _lastCellY));
                    onCellRollOut(getCellViewByPosition(new Point (_lastCellX, _lastCellY)));
                    onCellRollOver(cell);
                }
                _lastCellX = cell.positionX;
                _lastCellY = cell.positionY;
                switch (touch.phase) {
                    case TouchPhase.BEGAN:                                      // press
                    {
                        if (_isPressed) {
                            return;
                        }
                        _isPressed = true;
                        onCellMouseDown(cell);
                        break;
                    }

                    case TouchPhase.ENDED:                                      // click
                    {
                        if (_currentObject) {
                            var place: PlaceData = new PlaceData();
                            place.place(cell.positionX, cell.positionY);
                            place.object = _currentObject.object.name;
                            place.realObject = _currentObject.object;

                            _field.addObject(place);

                            addObject(_currentObject.object);
                        } else {
//                            _field.selectObject();
                        }

                        _isPressed = false;
                        onCellClick(cell);
                        break;
                    }

                    default :
                    {
                        if (_currentObject) {
                            _currentObject.x = cell.x;
                            _currentObject.y = cell.y;
                        }
                    }
                }
            }
        } else {
            _isRolledOver = false;

            onCellRollOut(getCellViewByPosition(new Point(_lastCellX, _lastCellY)));
        }
    }

    private function onCellRollOver(cellView:CellView):void {
        if (cellView) {
            cellView.onRollOver();
        }
    }

    private function onCellRollOut(cellView:CellView):void {
        if (cellView) {
            cellView.onRollOut();
        }
    }

    private function onCellMouseDown(cellView:CellView):void {
        if (cellView) {
            cellView.onMouseDown();
        }
    }

    private function onCellClick(cellView:CellView):void {
        if (cellView) {
            cellView.onClick();
        }
    }

    private function rollOutAllCells ():void {
        for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
            var _cellView:CellView = CellView(_cellsContainer.getChildAt(i));
            _cellView.onRollOut();
        }
    }

    private function getCellViewByPosition(point:Point):CellView {
        var cellView:CellView;
        if (point) {
            for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
                var _cellView:CellView = CellView(_cellsContainer.getChildAt(i));
                if ((_cellView.positionX == point.x) && (_cellView.positionY == point.y)) {
                    cellView = _cellView;
                    break;
                }
            }
        }
        return cellView;
    }

    private function getPositionByTouchEvent(touch:Touch):Point {
        var point:Point;
        if (touch) {
            var pos:Point = touch.getLocation(_cellsContainer).add(new Point(PositionView.cellWidth * 0.5, PositionView.cellHeight * 0.5));
            var tx:Number = pos.x / PositionView.cellWidth;
            var ty:Number = pos.y / PositionView.cellHeight;
            var cx:int = Math.round(ty - tx);
            var cy:int = Math.round(cx + tx * 2);
            point = new Point(cx, cy);
        }
        return point;
    }

    public function update():void {
        _objectsContainer.sortChildren(sortByDepth);
    }

    private function sortByDepth($child1:PositionView, $child2:PositionView):int {
        if ($child1.depth > $child2.depth) {
            return 1;
        } else if ($child1.depth < $child2.depth) {
            return -1;
        }
        return 0;
    }

    private function handleDestroy($event:Event):void {
        var obj:PositionView = $event.target as PositionView;
        obj.destroy();
        obj.removeFromParent(true);
    }

    public function destroy():void {
        removeEventListeners();

        _field.removeEventListeners();
        _field = null;

        _bg.removeFromParent(true);
        _bg = null;

        var cell:CellView;
        while (_cellsContainer.numChildren > 0) {
            cell = _cellsContainer.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }
        _cellsContainer.removeFromParent(true);
        _cellsContainer = null;

        var object:ObjectView;
        while (_objectsContainer.numChildren > 0) {
            object = _objectsContainer.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _objectsContainer.removeFromParent(true);
        _objectsContainer = null;

        while (_shadowsContainer.numChildren > 0) {
            object = _shadowsContainer.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _shadowsContainer.removeFromParent(true);
        _shadowsContainer = null;

        _container.removeFromParent(true);
        _container = null;
    }
}
}
