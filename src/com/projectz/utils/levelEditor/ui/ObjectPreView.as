/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.05.13
 * Time: 13:36
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.IResizableContainer;
import com.hogargames.utils.ResizeUtilities;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import starling.utils.AssetManager;

/**
 * Превью объекта для отображения в панелях редактора уровней.
 */
public class ObjectPreView extends Sprite implements IResizableContainer {

    private var _objectData:ObjectData;

    private var bitmap:Bitmap;
    private var tf:TextField;
    private var border:Shape;
    private var selectBorder:Shape;
    private var _select:Boolean = false;

    private var _containerWidth:Number = MIN_WIDTH;
    private var _containerHeight:Number = MIN_HEIGHT;

    private static const MIN_WIDTH:int = 10;
    private static const MIN_HEIGHT:int = 10;

    private static const TEXT_HEIGHT:int = 20;
    private static const TEXT_SIZE:int = 14;
    private static const TEXT_COLOR:uint = 0x333333;
    private static const TEXT_BACKGROUND_COLOR:uint = 0xcccccc;
    private static const BORDER_SIZE:int = 2;
    private static const BORDER_COLOR:uint = 0x666666;
    private static const BORDER_ELLIPSE_SIZE:int = 6;
    private static const SELECT_BORDER_SIZE:int = 3;
    private static const SELECT_BORDER_ALPHA:Number = .4;
    private static const SELECT_BORDER_COLOR:uint = 0xff6666;
    private static const BACKGROUND_COLOR:uint = 0xffffff;

    /**
     * @param objectData
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function ObjectPreView (objectData:ObjectData, assetsManager:AssetManager) {
        this._objectData = objectData;

        //Создаём картинку:
        var fieldObjectView:FieldObjectView = new FieldObjectView(objectData, assetsManager);
        var bitmapData:BitmapData = fieldObjectView.convertToBitmapData(BACKGROUND_COLOR);
        bitmap = new Bitmap(bitmapData);
        bitmap.smoothing = true;
        addChild(bitmap);

        //Создаём текстовое поле:
        tf = new TextField();
        var textFormat:TextFormat = tf.getTextFormat();
        textFormat.font = "Arial";
        textFormat.size = TEXT_SIZE;
        textFormat.color = TEXT_COLOR;
        textFormat.align = TextFormatAlign.CENTER;
        textFormat.bold = true;
        tf.setTextFormat(textFormat);
        tf.defaultTextFormat = textFormat;
        tf.text = objectData.name;
        tf.background = true;
        tf.backgroundColor = TEXT_BACKGROUND_COLOR;
        tf.height = TEXT_HEIGHT;
        tf.mouseEnabled = false;
        addChild(tf);

        //Добавляем обводку:
        border = new Shape;
        addChild(border);

        //Добавляем обводку выделения:
        selectBorder = new Shape;
        addChild(selectBorder);

        //Убираем выделение:
        select = false;
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get objectData():ObjectData {
        return _objectData;
    }

    /**
     * Ширина содержимого контейнера.
     */
    public function get containerWidth ():Number {
        return _containerWidth;
    }

    public function set containerWidth (value:Number):void {
        _containerWidth = Math.max(MIN_WIDTH, value);
        position();
    }

    /**
     * Высота содержимого контейнера.
     */
    public function get containerHeight ():Number {
        return _containerHeight;
    }

    public function set containerHeight (value:Number):void {
        _containerHeight = Math.max(value, TEXT_HEIGHT + MIN_HEIGHT);
        position();
    }

    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
        selectBorder.visible = value;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    /**
     * Перерисовка элементов контейнера. Вызывается при изменении размеров.
     */
    protected function position ():void {
        tf.width = _containerWidth;
        tf.y = _containerHeight - tf.height;

        //Масштабируем картинку, если она большая:
        if ((bitmap.bitmapData.width > _containerWidth) || (bitmap.bitmapData.height > _containerHeight)) {
            ResizeUtilities.resizeObj(bitmap, _containerWidth, _containerHeight - TEXT_HEIGHT, ResizeUtilities.MODE_SCALING);
        }
        //Позиционируем картинку:
        bitmap.x = (_containerWidth - bitmap.width) / 2;
        bitmap.y = ((_containerHeight- TEXT_HEIGHT) - bitmap.height) / 2;

        //Рисуем бордер:
        border.graphics.clear();
        border.graphics.beginFill(BORDER_COLOR, 1);
        border.graphics.drawRoundRect(0, 0, _containerWidth, _containerHeight, BORDER_ELLIPSE_SIZE, BORDER_ELLIPSE_SIZE);
        border.graphics.drawRoundRect(
                BORDER_SIZE,
                BORDER_SIZE,
                _containerWidth - BORDER_SIZE * 2,
                _containerHeight - BORDER_SIZE * 2 - TEXT_HEIGHT,
                BORDER_ELLIPSE_SIZE,
                BORDER_ELLIPSE_SIZE
        );
        border.graphics.drawRoundRect(
                BORDER_SIZE,
                _containerHeight - TEXT_HEIGHT,
                _containerWidth - BORDER_SIZE * 2,
                TEXT_HEIGHT  - BORDER_SIZE,
                BORDER_ELLIPSE_SIZE,
                BORDER_ELLIPSE_SIZE
        );
        border.graphics.endFill();

        //Рисуем бордер для выделения:
        selectBorder.graphics.clear ();
        selectBorder.graphics.beginFill(SELECT_BORDER_COLOR, SELECT_BORDER_ALPHA);
        selectBorder.graphics.drawRoundRect(0, 0, _containerWidth, _containerHeight, SELECT_BORDER_SIZE, BORDER_ELLIPSE_SIZE);
        selectBorder.graphics.drawRoundRect(
                SELECT_BORDER_SIZE,
                SELECT_BORDER_SIZE,
                _containerWidth - SELECT_BORDER_SIZE * 2,
                _containerHeight - SELECT_BORDER_SIZE * 2,
                SELECT_BORDER_SIZE,
                BORDER_ELLIPSE_SIZE
        );
        selectBorder.graphics.endFill ();

        //Рисуем подложку:
        graphics.clear ();
        graphics.beginFill(BACKGROUND_COLOR, 1);
        graphics.drawRoundRect(0, 0, _containerWidth, _containerHeight, BORDER_ELLIPSE_SIZE, BORDER_ELLIPSE_SIZE);
        graphics.endFill ();
    }

}
}
