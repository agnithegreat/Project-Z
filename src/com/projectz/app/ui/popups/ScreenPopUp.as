/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups {
import flash.display.BitmapData;
import flash.geom.Matrix;

import starling.display.Image;

import starling.textures.Texture;

public class ScreenPopUp extends BasicPopUp {

    public function ScreenPopUp() {
        var bitmapData:BitmapData = new BitmapData (Constants.WIDTH, Constants.HEIGHT, false, 0x000000);
        const INDENT:int = 5;
        var bitmapData2:BitmapData = new BitmapData (Constants.WIDTH - INDENT * 2, Constants.HEIGHT - INDENT * 2, false, 0x00ff00);
        var matrix:Matrix = new Matrix();
        matrix.translate (INDENT, INDENT);
        bitmapData.draw (bitmapData2, matrix);
        var texture:Texture = Texture.fromBitmapData (bitmapData);
        var image:Image = new Image (texture);
        addChild (image);
    }
}
}
