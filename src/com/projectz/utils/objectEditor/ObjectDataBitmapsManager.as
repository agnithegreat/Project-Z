/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 14.05.13
 * Time: 17:41
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {

import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Класс, предназначенный для преобразования данных ObjectData в картинку и хранения этих картинок.
 */
public class ObjectDataBitmapsManager {

    private static var _bitmapsData:Dictionary = new Dictionary();//Объект дл\ хранени

    private static const BACKGROUND_COLOR:uint = 0xffffff;

    public function ObjectDataBitmapsManager () {

    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /**
     * Получение превьюшки объекта ObjectData.
     * @param objectData Объект для первьюшки.
     * @return Превьюшка.
     */
    public static function getBitmap (objectData:ObjectData, assetsManager:AssetManager):Bitmap {
        var bitmapData:BitmapData = _bitmapsData [objectData];
        if (!bitmapData) {
            //Создаём картинку:
            var fieldObjectView:FieldObjectView = new FieldObjectView(objectData, assetsManager);
            bitmapData = fieldObjectView.convertToBitmapData(BACKGROUND_COLOR);
            _bitmapsData [objectData] = bitmapData;
        }
        var bitmap:Bitmap = new Bitmap(bitmapData);
        bitmap.smoothing = true;
        return bitmap;
    }
}
}
