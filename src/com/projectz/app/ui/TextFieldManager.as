/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.06.13
 * Time: 21:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui {
import com.projectz.AppSettings;

import flash.filters.GlowFilter;

import starling.text.TextField;

public class TextFieldManager {

    private static var appGlowFilter:GlowFilter = new GlowFilter(APP_FILTER_COLOR, 1, BLUR, BLUR, 4);
    private static var buttonGlowFilter:GlowFilter = new GlowFilter(BUTTON_FILTER_COLOR, 1, BLUR, BLUR, 4);
    private static const FONT_NAME:String = "PoplarStd";
    private static const FONT_SIZE:int = 30;
    private static const FONT_COLOR:uint = 0xffffff;
    private static const APP_FILTER_COLOR:uint = 0x000000;
    private static const BUTTON_FILTER_COLOR:uint = 0x045465;
    private static const BLUR:int = 5;

    /**
     * Устанавлваем стандартное форматирование текстового поля:
     */
    public static function setAppDefaultStyle (textField:TextField):void {
        setStyle (textField, appGlowFilter);
    }

    /**
     * Устанавлваем стандартное форматирование текстового поля для кнопок приложения:
     */
    public static function setButtonDefaultStyle (textField:TextField):void {
        setStyle (textField, buttonGlowFilter);
    }

    private static function setStyle (textField:TextField, glowFilter:GlowFilter) {
        var scaleFactor:int = AppSettings.scaleFactor;
        textField.fontName = FONT_NAME;
        textField.fontSize = FONT_SIZE * scaleFactor;
        textField.color = FONT_COLOR;
        glowFilter.blurX = BLUR * scaleFactor;
        glowFilter.blurY = BLUR * scaleFactor;
        textField.nativeFilters = [glowFilter];
    }
}
}
