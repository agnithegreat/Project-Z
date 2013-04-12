/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {
import flash.geom.Matrix;

import starling.display.Button;
import starling.display.Image;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class ButtonBase extends Button {

    private static var left: Image;
    private static var center: Image;
    private static var right: Image;
    public static function init($assets: AssetManager):void {
        left = new Image($assets.getTexture("btn_blue_01"));
        center = new Image($assets.getTexture("btn_blue_02"));
        right = new Image($assets.getTexture("btn_blue_03"));
    }

    public static function getBase($scale: Number, $content: Texture = null):Texture {
        var centerWidth: int = center.width*$scale;

        var base: RenderTexture = new RenderTexture(left.width + right.width + centerWidth, center.height);
        base.draw(left);
        if (centerWidth) {
            base.draw(center, new Matrix($scale,0,0,1,left.width,0));
        }
        base.draw(right, new Matrix(1,0,0,1,left.width+centerWidth));
        if ($content) {
            var content: Image = new Image($content);
            base.draw(content, new Matrix(1,0,0,1,(base.width-content.width)/2,(base.height-content.height)/2));
        }
        return base;
    }

    public function ButtonBase($size: Number, text:String = "", $content: Texture = null) {
        super(getBase($size, $content), text);
    }
}
}
