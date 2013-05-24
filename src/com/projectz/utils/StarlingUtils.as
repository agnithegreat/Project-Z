/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 14:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils {

import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.geom.Rectangle;

import starling.core.RenderSupport;

import starling.core.Starling;

import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.textures.Texture;

public class StarlingUtils {

    public static function asBitmapData(sprite:DisplayObjectContainer, backgroundColor:uint = 0xffffff):BitmapData {
        if (sprite == null) {
            return null;
        }
       	var resultRect:Rectangle = new Rectangle();
       	sprite.getBounds(sprite, resultRect);

        //Добавляем белый фон к картинке:
        var whiteBitmapData:BitmapData = new BitmapData(resultRect.width, resultRect.height, false, backgroundColor);
        var texture:Texture = Texture.fromBitmapData(whiteBitmapData);
        var backgroundImage:Image = new Image(texture);
        backgroundImage.x = resultRect.x;
        backgroundImage.y = resultRect.y;
        sprite.addChildAt(backgroundImage,0);

       	var context:Context3D = Starling.context;
       	var support:RenderSupport = new RenderSupport();
       	RenderSupport.clear();
       	support.setOrthographicProjection(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
//       	support.transformMatrix(sprite.root);
        if (sprite.parent){
            support.transformMatrix(sprite.parent);
        }
       	support.translateMatrix( -resultRect.x, -resultRect.y);
       	var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
       	support.pushMatrix();
       	support.transformMatrix(sprite);
       	sprite.render(support, 1.0);
       	support.popMatrix();
       	support.finishQuadBatch();
       	context.drawToBitmapData(result);
       	return result;

    }
}
}
