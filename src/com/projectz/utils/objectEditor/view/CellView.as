/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.objectEditor.ObjectsEditorApp;
import com.projectz.utils.objectEditor.model.Cell;

import starling.display.Image;

public class CellView extends PositionView {

    protected var _cell: Cell;
    override public function get positionX():Number {
        return _cell.x;
    }
    override public function get positionY():Number {
        return _cell.y;
    }

    private var _bg: Image;

    public function CellView($cell: Cell, $texture: String = null) {
        _cell = $cell;

        super();

        if ($texture) {
            _bg = new Image(ObjectsEditorApp.assets.getTexture($texture));
            _bg.pivotX = _bg.width/2;
            _bg.pivotY = _bg.height-cellHeight;
            addChild(_bg);
        }
    }

    override public function destroy():void {
        super.destroy();

        _cell = null;

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
