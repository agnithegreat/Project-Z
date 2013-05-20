/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import flash.geom.Point;

import starling.display.Image;
import starling.textures.Texture;

public class CellView extends PositionView {

    private var _bg: Image;
    private var _shotableImage: Image;

    private var _unwalkable:Boolean = false;
    private var _unshotable:Boolean = false;

    public function CellView($position: Point, $texture: Texture, $shotableTexture: Texture = null) {
        super($position);

        _bg = new Image($texture);
        _bg.alpha = .3;
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        addChild(_bg);

        if ($shotableTexture) {
            _shotableImage = new Image($shotableTexture);
            _shotableImage.pivotX = _shotableImage.width/2;
            _shotableImage.pivotY = _shotableImage.height/2;
            _shotableImage.alpha = .8;
            addChild(_shotableImage);
        }

        unwalkable = unwalkable;
        unshotable = unshotable;
    }

    public function get unwalkable():Boolean {
        return _unwalkable;
    }

    public function set unwalkable(value:Boolean):void {
        _unwalkable = value;
        if (_bg) {
            _bg.visible = value;
        }
    }

    public function get unshotable():Boolean {
        return _unshotable;
    }

    public function set unshotable(value:Boolean):void {
        _unshotable = value;
        if (_shotableImage) {
            _shotableImage.visible = value;
        }
    }

    override public function destroy():void {
        super.destroy();

        if (_bg) {
            _bg.removeFromParent(true);
        }
        if (_shotableImage) {
            _shotableImage.removeFromParent(true);
        }
        _bg = null;
        _shotableImage = null;
    }
}
}
