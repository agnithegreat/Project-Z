/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.06.13
 * Time: 19:20
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.elements {
import com.projectz.AppSettings;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.textures.Texture;

public class BasicButtonWithIcon extends BasicButton {

    private var _icon:Image;

    private static const INDENT:int = 10;

    public function BasicButtonWithIcon (scale:Number, text:String = "", iconTexture:Texture = null, content:Texture = null) {
        super (scale, text, content);
        if (iconTexture) {
            icon = new Image (iconTexture);
        }
    }

    public function get icon():Image {
        return _icon;
    }

    public function set icon(value:Image):void {
        if (_icon) {
            _icon.removeFromParent();
        }
        _icon = value;
        addChild (_icon);
        var rect:Rectangle = textBounds;
        var indent:int = _icon.width - INDENT * AppSettings.scaleFactor;
        rect.x += indent;
        rect.width -= indent;
        textBounds = rect;
    }
}
}
