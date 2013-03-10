/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.App;
import com.projectz.event.GameEvent;
import com.projectz.model.Field;
import com.projectz.model.objects.Personage;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _bg: Image;
    private var _container: Sprite;

    private var _cells: Sprite;
    private var _shadows: Sprite;
    private var _objects: Sprite;

    public function FieldView($field: Field, $assets: AssetManager) {
        _field = $field;
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);

        _bg = new Image($assets.getTexture("bg-test"));
        _bg.touchable = false;
        addChild(_bg);

        _container = new Sprite();
        addChild(_container);

        _cells = new Sprite();
        _cells.alpha = 0.1;
        _container.addChild(_cells);

        var len: int = _field.field.length;
        var cell: CellView;
        for (var i:int = 0; i < len; i++) {
            cell = new CellView(_field.field[i], $assets.getTexture("so-cell"));
            _cells.addChild(cell);
        }
        _cells.flatten();

//        _container.x = (Constants.WIDTH+(1-(_field.width+_field.height)*0.5)*CellView.cellWidth)*0.5;
//        _container.y = (Constants.HEIGHT+CellView.cellHeight)*0.5;
        _container.x = (Constants.WIDTH+PositionView.cellWidth)*0.5;
        _container.y = (Constants.HEIGHT+(1-(_field.height+_field.height)*0.5)*PositionView.cellHeight)*0.5;

        _shadows = new Sprite();
        _shadows.touchable = false;
        _container.addChild(_shadows);

        _objects = new Sprite();
        _objects.touchable = false;
        _container.addChild(_objects);

        var object: PositionView;
        var shadow: ShadowView;
        for (i = 0; i < len; i++) {
            if (_field.field[i].object is Personage) {
                object = new ZombieView(_field.field[i].object as Personage);
                _objects.addChild(object);
            } else if (_field.field[i].object && _field.field[i].object.cell==_field.field[i]) {
                object = new ObjectView(_field.field[i].object);
                _objects.addChild(object);

                if (_field.field[i].object.data.getPart("shadow").textures.length>0) {
                    shadow = new ShadowView(_field.field[i].object);
                    _shadows.addChild(shadow);
                }
            }
        }

        _shadows.flatten();

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
        _objects.sortChildren(sortByDepth);
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
        while (_cells.numChildren>0) {
            cell = _cells.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }
        _cells.removeFromParent(true);
        _cells = null;

        var shadow: ShadowView;
        while (_shadows.numChildren>0) {
            shadow = _shadows.getChildAt(0) as ShadowView;
            shadow.destroy();
            shadow.removeFromParent(true);
        }
        _shadows.removeFromParent(true);
        _shadows = null;

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
