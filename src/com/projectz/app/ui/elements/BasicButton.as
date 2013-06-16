/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.elements {
import com.projectz.AppSettings;
import com.projectz.app.ui.TextFieldManager;

import flash.geom.Matrix;
import flash.geom.Rectangle;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class BasicButton extends Button {

    private static var left: Image;
    private static var center: Image;
    private static var right: Image;

    protected var mTextField:TextField;//Текстовое поле кнопки. Сохранено оригинальное название приватной переменной из классов старлинга.

    private static const INDENT:int = 1;
    private static const TF_Y_INDENT:int = 3;

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
            base.draw(center, new Matrix($scale,0,0,1,left.width - INDENT,0));
        }
        var indent:int = INDENT * 2;
        if (centerWidth == 0) {
            indent = INDENT;
        }
        base.draw(right, new Matrix(1,0,0,1,left.width+centerWidth - indent));
        if ($content) {
            var content: Image = new Image($content);
            base.draw(content, new Matrix(1,0,0,1,(base.width-content.width)/2,(base.height-content.height)/2));
        }
        return base;
    }

    /**
     * @param $scale Множитель размера кнопки (например, 1 или 2).
     * @param text
     * @param $content
     */
    public function BasicButton($scale: Number, text:String = "", $content: Texture = null) {
        super(getBase($scale, $content), text);
        var mContent:Sprite = Sprite (getChildAt(0));

        if (mContent) {
            for (var i:int = 0; i < mContent.numChildren; i++) {
                var child:DisplayObject = mContent.getChildAt(i);
                if (child is TextField) {
                    mTextField = TextField (child);
                    break;
                }
            }
        }
        if (mTextField) {
            TextFieldManager.setButtonDefaultStyle(mTextField);
            var rect:Rectangle = textBounds;
            rect.y = TF_Y_INDENT * AppSettings.scaleFactor;
            textBounds = rect;
        }
    }
}
}
