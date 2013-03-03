/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Field;

import starling.display.Sprite;

public class FieldView extends Sprite {

    private var _field: Field;

    private var _cells: Sprite;
    private var _objects: Sprite;

    public function FieldView($field: Field) {
        _field = $field;

        _cells = new Sprite();
        addChild(_cells);

        var len: int = _field.field.length;
        for (var i:int = 0; i < len; i++) {
            var cell: CellView = new CellView(_field.field[i]);
            addChild(cell);
        }

        _objects = new Sprite();
        addChild(_objects);
    }
}
}
