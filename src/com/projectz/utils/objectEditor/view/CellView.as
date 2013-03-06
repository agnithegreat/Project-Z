/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import starling.display.Image;
import starling.textures.Texture;

public class CellView extends PositionView {

    private var _bg: Image;

    public function CellView($texture: Texture) {
        super();

        if ($texture) {
            _bg = new Image($texture);
            _bg.pivotX = _bg.width/2;
            _bg.pivotY = _bg.height;
            addChild(_bg);
        }
    }

    override public function destroy():void {
        super.destroy();

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
