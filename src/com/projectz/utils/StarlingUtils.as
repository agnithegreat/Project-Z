/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 14:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils {
import com.projectz.utils.levelEditor.App;

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

        App.testSprite.addChild (sprite);
//        sprite = App.testSprite;
        if (sprite == null) return null;
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

        /*
        if (sprite == null) {
            return null;
        }

        var resultRect:Rectangle = new Rectangle();
        sprite.getBounds(sprite, resultRect);

        var context:Context3D = Starling.context;
        var scale:Number = Starling.contentScaleFactor;

        var nativeWidth:Number = Starling.current.stage.stageWidth;
        var nativeHeight:Number = Starling.current.stage.stageHeight;

        var support:RenderSupport = new RenderSupport();
        RenderSupport.clear();
        support.setOrthographicProjection(0, 0, nativeWidth, nativeHeight);
        support.applyBlendMode(true);

        if (sprite.parent){
            support.transformMatrix(sprite.parent);
        }

        support.translateMatrix(-resultRect.x, -resultRect.y);
//            support.translateMatrix( sprite.width / 2, sprite.height / 2 );

//            var result:BitmapData = new BitmapData(nativeWidth, nativeHeight, true, 0x00ffffff);
//        var result:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00ffffff);
        var result:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0);

        trace ("pivotX = " + sprite.pivotX + "; pivotY = " + sprite.pivotY);

        support.pushMatrix();

        support.blendMode = sprite.blendMode;
        support.transformMatrix(sprite);
        sprite.render(support, 1.0);
        support.popMatrix();

        support.finishQuadBatch();

        context.drawToBitmapData(result);

        var w:Number = sprite.width;
        var h:Number = sprite.height;

        if (w == 0 || h == 0) {
            return null;
        }

        var returnBMPD:BitmapData = new BitmapData(w, h, true, 0);
        var cropArea:Rectangle = new Rectangle(0, 0, sprite.width, sprite.height);

        returnBMPD.draw( result, null, null, null, cropArea, true );
        return returnBMPD;
        */
    }
}
}
