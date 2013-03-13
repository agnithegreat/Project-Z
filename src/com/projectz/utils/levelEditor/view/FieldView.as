/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {

import com.projectz.utils.levelEditor.event.GameEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.objects.FieldObject;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
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
//        _cellsContainer.flatten();

        _container.x = (Constants.WIDTH+PositionView.CELL_WIDTH)*0.5;
        _container.y = (Constants.HEIGHT+(1-(_field.height+_field.height)*0.5)*PositionView.CELL_HEIGHT)*0.5;

        _shadowsContainer = new Sprite();
        _shadowsContainer.touchable = false;
        _container.addChild(_shadowsContainer);

        _objectsContainer = new Sprite();
        _objectsContainer.touchable = false;
        _container.addChild(_objectsContainer);

        var object: PositionView;
        var fieldObject: FieldObject;
        len = _field.objects.length;
        for (i = 0; i < len; i++) {
            fieldObject = _field.objects[i];
            if (fieldObject) {
                object = new ObjectView(fieldObject, fieldObject.data.name);
                _objectsContainer.addChild(object);
            }
            if (fieldObject.cell.shadow) {
                object = new ObjectView(fieldObject.cell.shadow, "shadow");
                _shadowsContainer.addChild(object);
            }
        }

        _shadowsContainer.flatten();

        addEventListener(GameEvent.DESTROY, handleDestroy);

        update();
    }

    private function handleUpdate($event: Event):void {
        update();
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