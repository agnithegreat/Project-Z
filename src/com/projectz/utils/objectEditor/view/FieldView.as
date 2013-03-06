/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 21:22
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.objectEditor.ObjectsEditorApp;
import com.projectz.utils.objectEditor.model.Field;
import com.projectz.utils.objectEditor.model.FieldObject;

import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _container: Sprite;

    private var _cells: Sprite;
    private var _objects: Sprite;

    public function FieldView($field: Field) {
        _field = $field;
        _field.addEventListener(Field.ADD_OBJECT, handleAddObject);

        _container = new Sprite();
        addChild(_container);

        _cells = new Sprite();
        _cells.alpha = 0.1;
        _container.addChild(_cells);

        var len: int = _field.field.length;
        var cell: CellView;
        for (var i:int = 0; i < len; i++) {
            cell = new CellView(ObjectsEditorApp.assets.getTexture("so-cell"));
            _cells.addChild(cell);
        }
        _cells.flatten();

        _container.x = (Constants.WIDTH-200+PositionView.cellWidth)*0.5;
        _container.y = (Constants.HEIGHT+(1-(_field.height+_field.height)*0.5)*PositionView.cellHeight)*0.5;

        _objects = new Sprite();
        _objects.touchable = false;
        _container.addChild(_objects);
    }

    private function handleAddObject(event: Event):void {
        var obj: ObjectView;
        while (_objects.numChildren>0) {
            obj = _objects.getChildAt(0) as ObjectView;
            obj.destroy();
            obj.removeFromParent(true);
        }

        var textures: Vector.<Texture> = ObjectsEditorApp.assets.getTextures(_field.object.data.name);

        var len: int = textures.length;
        for (var i:int = 0; i < len; i++) {
            _objects.addChild(new ObjectView(textures[i]));
        }
    }

    public function destroy():void {
        removeEventListeners();

        _field.removeEventListeners();
        _field = null;

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
