/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {

import com.projectz.event.GameEvent;
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.objects.FieldObject;

import flash.geom.Point;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _bg: Image;
    private var _container: Sprite;

    private var _cellsContainer: Sprite;
    private var _shadowsContainer: Sprite;
    private var _objectsContainer: Sprite;

    public function FieldView($field: Field, $assets: AssetManager) {
        _field = $field;
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);
        _field.addEventListener(GameEvent.OBJECT_ADDED, handleAddObject);

        _bg = new Image($assets.getTexture("bg-test"));
        _bg.touchable = false;
        addChild(_bg);

        _container = new Sprite();
        addChild(_container);

        _cellsContainer = new Sprite();
//        _cellsContainer.alpha = 0.1;
        _container.addChild(_cellsContainer);

        var len: int = _field.field.length;
        var cell: CellView;
        for (var i:int = 0; i < len; i++) {
            cell = new CellView(_field.field[i], $assets.getTexture("so-cell"));
            _cellsContainer.addChild(cell);
        }
        _cellsContainer.flatten();

        _container.x = (Constants.WIDTH+PositionView.cellWidth)*0.5;
        _container.y = (Constants.HEIGHT+(1-(_field.height+_field.height)*0.5)*PositionView.cellHeight)*0.5;

        _shadowsContainer = new Sprite();
        _shadowsContainer.touchable = false;
        _container.addChild(_shadowsContainer);

        _objectsContainer = new Sprite();
        _objectsContainer.touchable = false;
        _container.addChild(_objectsContainer);

        addEventListener(GameEvent.DESTROY, handleDestroy);

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function getCell(cx:int, cy:int):CellView {
        var numCells:int = _cellsContainer.numChildren;
        for (var i:int = 0; i < numCells; i++) {
            var $cellView:CellView = CellView(_cellsContainer.getChildAt(i));
            if (($cellView.positionX == cx) && ($cellView.positionY == cy)) {
                return $cellView;
            }
        }
        return null;
    }

    private function handleAddedToStage($event: Event):void {
        stage.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleAddObject($event: Event):void {
        var object: PositionView;
        var fieldObject: FieldObject = $event.data as FieldObject;
        object = new ObjectView(fieldObject, fieldObject.data.name);
        _objectsContainer.addChild(object);
        if (fieldObject.cell.shadow) {
            object = new ObjectView(fieldObject.cell.shadow, "shadow");
            _shadowsContainer.addChild(object);
        }
    }

    private function handleUpdate($event: Event):void {
        update();
    }

    private function handleTouch($event: TouchEvent):void {
        var touch: Touch = $event.getTouch(_cellsContainer, TouchPhase.BEGAN);
        if (touch) {
            var pos: Point = touch.getLocation(_cellsContainer).add(new Point(PositionView.cellWidth*0.5, PositionView.cellHeight*0.5));
            var tx: Number = pos.x/PositionView.cellWidth;
            var ty: Number = pos.y/PositionView.cellHeight;
            var cx: int = Math.round(ty-tx);
            var cy: int = Math.round(cx+tx*2);

            // TODO: через контроллер
            var cell:CellView = getCell(cx, cy);
            trace ("cell = " + cell);
            if (cell) {
                cell.alpha = .1;
            }
        }
    }

    private function handleDestroy($event: Event):void {
        var obj: PositionView = $event.target as PositionView;
        obj.destroy();
        obj.removeFromParent(true);
    }

    public function update():void {
        _objectsContainer.sortChildren(sortByDepth);
    }

    private function sortByDepth($child1: PositionView, $child2: PositionView):int {
        if ($child1.depth>$child2.depth) {
            return 1;
        } else if ($child1.depth<$child2.depth) {
            return -1;
        }
        return 0;
    }

    public function destroy():void {
        removeEventListeners();

        _field.removeEventListeners();
        _field = null;

        _bg.removeFromParent(true);
        _bg = null;

        var cell: CellView;
        while (_cellsContainer.numChildren>0) {
            cell = _cellsContainer.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }
        _cellsContainer.removeFromParent(true);
        _cellsContainer = null;

        var object: ObjectView;
        while (_objectsContainer.numChildren>0) {
            object = _objectsContainer.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _objectsContainer.removeFromParent(true);
        _objectsContainer = null;

        while (_shadowsContainer.numChildren>0) {
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
