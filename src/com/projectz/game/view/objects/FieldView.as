/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.objects {
import com.projectz.game.view.*;
import com.projectz.game.controller.UIController;
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Field;
import com.projectz.game.model.objects.Defender;
import com.projectz.game.model.objects.Enemy;
import com.projectz.game.model.objects.FieldObject;
import com.projectz.game.model.objects.Personage;
import com.projectz.game.view.effects.Effect;
import com.projectz.game.view.objects.DefenderView;
import com.projectz.game.view.objects.EnemyView;
import com.projectz.game.view.objects.ObjectView;
import com.projectz.game.view.objects.ShadowView;

import flash.geom.Point;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class FieldView extends Sprite {

    private var _uiController: UIController;

    private var _field: Field;

    private var _bg: Image;
    private var _container: Sprite;

    private var _cells: Sprite;
    private var _staticShadows: Sprite;
    private var _dynamicShadows: Sprite;
    private var _floorEffects: Sprite;
    private var _objects: Sprite;
    private var _overallEffects: Sprite;

    public function FieldView($field: Field, $uiController: UIController) {
        _uiController = $uiController;

        _field = $field;
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);
        _field.addEventListener(GameEvent.OBJECT_ADDED, handleAddObject);

        _bg = new Image(_uiController.assets.getTexture(_field.level.bg));
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
            cell = new CellView(_field.field[i], _uiController.assets.getTexture("ms-cell"));
            _cells.addChild(cell);
        }
        _cells.flatten();

        _container.x = (Constants.WIDTH+PositionView.cellWidth)*0.5;
        _container.y = (Constants.HEIGHT+(1-(_field.height+_field.height)*0.5)*PositionView.cellHeight)*0.5;

        _staticShadows = new Sprite();
        _staticShadows.touchable = false;
        _container.addChild(_staticShadows);
        _staticShadows.flatten();

        _dynamicShadows = new Sprite();
        _dynamicShadows.touchable = false;
        _container.addChild(_dynamicShadows);

        _floorEffects = new Sprite();
        _floorEffects.touchable = false;
        _container.addChild(_floorEffects);

        _objects = new Sprite();
        _objects.touchable = false;
        _container.addChild(_objects);

        _overallEffects = new Sprite();
        _overallEffects.touchable = false;
        _container.addChild(_overallEffects);

        addEventListener(GameEvent.SHOW_EFFECT, handleShowEffect);
        addEventListener(GameEvent.DESTROY, handleDestroy);

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage($event: Event):void {
        stage.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleAddObject($event: Event):void {
        var object: PositionView;
        var fieldObject: FieldObject = $event.data as FieldObject;
        if (fieldObject is Enemy) {
            object = new EnemyView(fieldObject as Personage);
        } else if (fieldObject is Defender) {
            object = new DefenderView(fieldObject as Personage);
            _uiController.currentDefenderData = null;
        } else {
            object = new ObjectView(fieldObject, fieldObject.data.name);
        }
        _objects.addChild(object);
        if (fieldObject.shadow) {
            var shadow: ShadowView = new ShadowView(fieldObject.shadow, object);

            if (object.animated) {
                _dynamicShadows.addChild(shadow);
            } else {
                _staticShadows.unflatten();
                _staticShadows.addChild(shadow);
                shadow.updatePosition();
                _staticShadows.flatten();
            }
        }
    }

    private function handleUpdate($event: Event):void {
        update();

        var len: int = _dynamicShadows.numChildren;
        for (var i:int = 0; i < len; i++) {
            (_dynamicShadows.getChildAt(i) as ShadowView).updatePosition();
        }
    }

    private function handleShowEffect($event: Event):void {
        var target: PositionView = $event.target as PositionView;
        var effect: Effect;
        if ($event.data == Effect.BLOOD) {
            effect = new Effect(target.positionX, target.positionY, _uiController.assets.getTextures("effect_brain"));
            effect.pivotY += 40;
            _overallEffects.addChild(effect);
            effect.hide(2, 1);
        } else if ($event.data == Effect.DIE) {
            var rand: int = Math.random()*2+1;
            effect = new Effect(target.positionX, target.positionY, _uiController.assets.getTextures("effect_blood_0"+rand));
            _floorEffects.addChild(effect);
            effect.hide(3, 1);
        }
    }

    private function handleTouch($event: TouchEvent):void {
        var touch: Touch = $event.getTouch(_cells, TouchPhase.BEGAN);
        if (touch) {
            var pos: Point = touch.getLocation(_cells).add(new Point(PositionView.cellWidth*0.5, PositionView.cellHeight*0.5));
            var tx: Number = pos.x/PositionView.cellWidth;
            var ty: Number = pos.y/PositionView.cellHeight;
            var cx: int = Math.round(ty-tx);
            var cy: int = Math.round(cx+tx*2);

            _uiController.addDefender(cx, cy);
        }
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
        if ($child1.y>$child2.y) {
            return 1;
        } else if ($child1.y<$child2.y) {
            return -1;
        }
        return 0;
    }

    public function destroy():void {
        _uiController = null;

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

        var object: ObjectView;
        while (_objects.numChildren>0) {
            object = _objects.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _objects.removeFromParent(true);
        _objects = null;

        while (_staticShadows.numChildren>0) {
            object = _staticShadows.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _staticShadows.removeFromParent(true);
        _staticShadows = null;

        while (_dynamicShadows.numChildren>0) {
            object = _dynamicShadows.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _dynamicShadows.removeFromParent(true);
        _dynamicShadows = null;

        _container.removeFromParent(true);
        _container = null;
    }
}
}
