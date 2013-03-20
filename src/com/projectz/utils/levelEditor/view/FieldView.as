/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;
import com.projectz.utils.levelEditor.events.SelectBackGroundEvent;
import com.projectz.utils.levelEditor.events.SelectObjectEvent;
import com.projectz.utils.levelEditor.events.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var controller:LevelEditorController;

    private var _assets:AssetManager;

    private var _field:Field;

    private var _bg:Image;
    private var _container:Sprite;

    private var _cellsContainer:Sprite;
    private var _shadowsContainer:Sprite;
    private var _objectsContainer:Sprite;

    private var _currentObject: FieldObjectView;
    private var _currentCell: CellView;

    private var _shift: Boolean;

    protected var _isPressed:Boolean;
    protected var _isRolledOver:Boolean;
    protected var _lastCellX:int;
    protected var _lastCellY:int;

    public function FieldView($field:Field, $assets:AssetManager, $controller:LevelEditorController) {
        _assets = $assets;
        controller = $controller;
        controller.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        controller.addEventListener(SelectBackGroundEvent.SELECT_BACKGROUND, selectBackGroundListener);
        controller.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);
        _field = $field;
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);
        _field.addEventListener(LevelEditorEvent.OBJECT_ADDED, handleAddObject);
        _field.addEventListener(LevelEditorEvent.SHADOW_ADDED, handleAddShadow);
        _field.addEventListener(LevelEditorEvent.OBJECT_REMOVED, handleRemoveObject);
        _field.addEventListener(LevelEditorEvent.PLACE_ADDED, handleAddPlace);
        _field.addEventListener(LevelEditorEvent.ALL_OBJECTS_REMOVED, handleAllObjectRemoved);

        _bg = new Image(_assets.getTexture(_field.level.bg));
        _bg.touchable = false;
        addChild(_bg);

        _container = new Sprite();
        addChild(_container);

        _cellsContainer = new Sprite();
        _container.addChild(_cellsContainer);

        var len:int = _field.field.length;
        var cell:CellView;
        for (var i:int = 0; i < len; i++) {
            cell = new CellView(_field.field[i], $assets.getTexture("so-cell-levelEditor"));
            _cellsContainer.addChild(cell);
        }

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
        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
    }

    public function selectTab($tab: String):void {
        _objectsContainer.visible = _shadowsContainer.visible = $tab != ObjectData.ENEMY;
        addObject(null);
    }

    private function selectFile($file:ObjectData):void {
        if ($file) {
            if ($file.type != ObjectData.BACKGROUND) {
                addObject($file);
            }
        }
        else {
            addObject(null);
        }
    }

    private function selectBackground($file:ObjectData):void {
        if ($file.type == ObjectData.BACKGROUND) {
            _field.level.bg = $file.name;
            _bg.texture = _assets.getTexture(_field.level.bg);
        }
    }

    private function handleAddPlace($event: Event):void {
        addObject($event.data as ObjectData);
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

            if (_currentCell) {
                _currentObject.x = _currentCell.x;
                _currentObject.y = _currentCell.y;
            }
        }
    }

    private function handleAddObject($event:Event):void {
        var fieldObject:FieldObject = $event.data as FieldObject;
        var object:ObjectView = new ObjectView(fieldObject, fieldObject.data.name);
        _objectsContainer.addChild(object);

        for (var i:int = 0; i < fieldObject.data.width; i++) {
            for (var j:int = 0; j < fieldObject.data.height; j++) {
                if (fieldObject.data.mask[i][j]) {
                    getCellViewByPosition(fieldObject.cell.x-fieldObject.data.top.x+i, fieldObject.cell.y-fieldObject.data.top.y+j).color = 0;
                }
            }
        }
    }

    private function handleAddShadow($event:Event):void {
        var fieldObject:FieldObject = $event.data as FieldObject;
        if (fieldObject.cell.shadow) {
            var object:ObjectView = new ObjectView(fieldObject.cell.shadow, "shadow");
            _shadowsContainer.addChild(object);
        }
    }

    private function handleRemoveObject($event: Event):void {
        var object: FieldObject = $event.data as FieldObject;

        handleRemoveObjectByFieldObject (object);
    }

    private function handleRemoveObjectByFieldObject(object: FieldObject):void {

        for (i = 0; i < object.data.width; i++) {
            for (var j:int = 0; j < object.data.height; j++) {
                getCellViewByPosition(object.cell.x-object.data.top.x+i, object.cell.y-object.data.top.y+j).color = 0;
            }
        }

        var len: int = _objectsContainer.numChildren;
        for (var i:int = 0; i < len; i++) {
            var obj: ObjectView = _objectsContainer.getChildAt(i) as ObjectView;
            if (obj.object == object) {
                obj.destroy();
                obj.removeFromParent(true);
                i--;
                len--;
            }
        }

        len = _shadowsContainer.numChildren;
        for (i = 0; i < len; i++) {
            obj = _shadowsContainer.getChildAt(i) as ObjectView;
            if (obj.object == object.cell.shadow) {
                obj.destroy();
                obj.removeFromParent(true);
                i--;
                len--;
            }
        }
    }

    private function handleAllObjectRemoved($event: Event):void {
        while (_objectsContainer.numChildren > 0) {
            var objectView:ObjectView = ObjectView (_objectsContainer.getChildAt(0));
            _objectsContainer.removeChild(objectView);
            objectView.destroy();
        }
        while (_shadowsContainer.numChildren > 0) {
            var shadowView:ObjectView = ObjectView (_shadowsContainer.getChildAt(0));
            _shadowsContainer.removeChild(shadowView);
            shadowView.destroy();
        }
        for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
            var cellView:CellView = CellView(_cellsContainer.getChildAt(0));
            cellView.color = 0xffffff;
        }
    }

    private function handleUpdate($event:Event):void {
        update();
    }

    protected function onTouchHandler(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this);
        if (touch) {
            var pos: Point = getPositionByTouchEvent(touch);
            _currentCell = getCellViewByPosition(pos.x, pos.y);
            if (_currentCell) {
                if ((_currentCell.positionX != _lastCellX) || (_currentCell.positionY != _lastCellY)) {
//                    trace("!!! " +
//                            "(cell.positionX (" + cell.positionX + ") != _lastCellX (" + _lastCellX + ")) = " +
//                            (cell.positionX != _lastCellX) +
//                            "; (cell.positionY (" + cell.positionY + ") != _lastCellY (" + _lastCellY + ")) = " +
//                            (cell.positionY != _lastCellY));
                    onCellRollOut(getCellViewByPosition(_lastCellX, _lastCellY));
                    onCellRollOver(_currentCell);
                }
                _lastCellX = _currentCell.positionX;
                _lastCellY = _currentCell.positionY;
                switch (touch.phase) {
                    case TouchPhase.BEGAN:                                      // press
                    {
                        if (_isPressed) {
                            return;
                        }
                        _isPressed = true;
                        onCellMouseDown(_currentCell);
                        break;
                    }

                    case TouchPhase.ENDED:                                      // click
                    {
                        if (_currentObject) {
                            var place: PlaceData = new PlaceData();
                            place.place(_currentCell.positionX, _currentCell.positionY);
                            place.object = _currentObject.object.name;
                            place.realObject = _currentObject.object;

                            _field.addObject(place);

                            if (_shift) {
                                addObject(_currentObject.object);
                            } else {
                                addObject(null);
                            }
                        } else {
                            _field.selectObject(_currentCell.positionX, _currentCell.positionY);
                        }

                        _isPressed = false;
                        onCellClick(_currentCell);
                        break;
                    }

                    default :
                    {
                        if (_currentObject) {
                            _currentObject.x = _currentCell.x;
                            _currentObject.y = _currentCell.y;
                        }
                    }
                }
            }
        } else {
            _isRolledOver = false;

            onCellRollOut(getCellViewByPosition(_lastCellX, _lastCellY));
        }
    }

    private function onCellRollOver(cellView:CellView):void {
        if (cellView) {
            cellView.onRollOver();
            controller.showCellInfo(cellView.cell);
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

    private function getCellViewByPosition($x: int, $y: int):CellView {
        var cellView:CellView;
        for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
            var _cellView:CellView = CellView(_cellsContainer.getChildAt(i));
            if ((_cellView.positionX == $x) && (_cellView.positionY == $y)) {
                cellView = _cellView;
                break;
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

    private function handleKeyDown($event: KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.ESCAPE:
            case Keyboard.DELETE:
                addObject(null);
                break;
            case Keyboard.SHIFT:
                _shift = true;
                break;
        }
    }

    private function handleKeyUp($event: KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.SHIFT:
                _shift = false;
                break;
        }
    }

    private function handleDestroy($event:Event):void {
        var obj:PositionView = $event.target as PositionView;
        obj.destroy();
        obj.removeFromParent(true);
    }

    public function destroy():void {
        stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

        controller.removeEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        controller.removeEventListener(SelectBackGroundEvent.SELECT_BACKGROUND, selectBackGroundListener);
        controller.removeEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);

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

    private function selectObjectListener (event:SelectObjectEvent):void {
        selectFile (event.objectData);
    }

    private function selectBackGroundListener (event:SelectBackGroundEvent):void {
        selectFile (event.objectData);
    }

    private function selectObjectsTypeListener (event:SelectObjectsTypeEvent):void {
        selectTab (event.objectsType);
    }
}
}
