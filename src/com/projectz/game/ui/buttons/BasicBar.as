/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.05.13
 * Time: 15:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {

import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.filters.GlowFilter;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.display.graphics.NGon;
import starling.display.materials.StandardMaterial;
import starling.display.shaders.fragment.TextureFragmentShader;
import starling.display.shaders.vertex.StandardVertexShader;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.AssetManager;
import starling.utils.HAlign;

public class BasicBar extends Sprite {

    private var _imgGlow: Image;//Картинка свечения бара.
    private var _imgBack: Image;//Картинка заднего фона.
    private var _iconContainer:Sprite;//Контейнер для отображения иконок.
    private var _tf:TextField;//Текстовоне поле.
    private var _nGonProgress:NGon;//Радиальный прогресс-бар.

    private var _assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    private var _glow:Boolean = false;

    private static const PROGRESS_BAR_X:int = 52;
    private static const PROGRESS_BAR_Y:int = 52;
    private static const TF_WIDTH:int = 104;
    private static const TF_Y:int = 56;
    private static const TF_FONT_SIZE:int = 30;
    private static const ICON_X:int = 70;
    private static const ICON_Y:int = 90;

    /**
     * @param $assetsManager Менеджер ресурсов старлинга.
     */
    public function BasicBar($assetsManager: AssetManager) {
        this._assetsManager = $assetsManager;
        _imgGlow = new Image($assetsManager.getTexture("bar_radial-glow"));
        addChild(_imgGlow);

        _imgBack = new Image($assetsManager.getTexture("bar_radial-back"));
        addChild(_imgBack);

        var progressTexture:Texture = $assetsManager.getTexture("bar_radial-progress_2");

        var textureWidth:int = progressTexture.width;
        _nGonProgress = new NGon(textureWidth / 2, 50, 0, 0, 0);
        _nGonProgress.x = PROGRESS_BAR_X;
        _nGonProgress.y = PROGRESS_BAR_Y;
        _nGonProgress.material = new StandardMaterial( new StandardVertexShader(), new TextureFragmentShader() );
        _nGonProgress.material.textures[0] = progressTexture;
        addChild(_nGonProgress);

        _iconContainer = new Sprite();
        addChild(_iconContainer);

        /*
        PoplarStd
        a_Concepto
        MyriadPro

        */
        _tf = new TextField(TF_WIDTH, TF_FONT_SIZE + 5, "", "MyriadPro", TF_FONT_SIZE, 0xffffff);
        _tf.hAlign = HAlign.CENTER;
//        _tf.filter = BlurFilter.createGlow(0, 1, 2, 1);
        var glowFilter:GlowFilter = new GlowFilter();
        glowFilter.color = 0x000000;
        glowFilter.blurX = 5;
        glowFilter.blurY = 5;
        glowFilter.strength = 4;
//        glowFilter.inner = true;
        _tf.nativeFilters = [glowFilter];
        _tf.y = TF_Y;
        addChild(_tf);

        glow = glow;

        setPercent(0);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /**
     * Свечение бара.
     */
    public function get glow():Boolean {
        return _glow;
    }

    public function set glow(value:Boolean):void {
        _glow = value;
        _imgGlow.visible = value;
    }

    /**
     * Установка значения в процентах для отображения прогресса в радиальном прогресс баре.
     * @param percent Значение в процентах от 1 до 100.
     */
    public function setPercent (percent:int):void {
        percent = Math.max(0, Math.min (100, percent));
        glow = (percent == 100);
        _nGonProgress.startAngle = 0;
        _nGonProgress.endAngle = Math.max (1, percent / 100 * 360);
    }

    /**
     * Установка текста.
     * @param text Текст.
     */
    public function setText (text:String):void {
        _tf.text = text;

    }

    /**
     * Создание и отображение иконки по объекту ObjectData.
     * @param objectData Объект для создания иконки.
     */
    public function createIconByObjectData (objectData:ObjectData):void {
        _iconContainer.removeChildren();
        if (objectData) {
            var fieldObjectView:FieldObjectView = new FieldObjectView(objectData, _assetsManager);
            fieldObjectView.asIcon();
            placeIcon (fieldObjectView);
            _iconContainer.addChild(fieldObjectView);
        }
    }

    /**
     * Деактивация.
     */
    public function destroy ():void {
        _nGonProgress.dispose();
        _iconContainer.removeChildren();
        removeFromParent();
    }

    /**
     * Нормальное отображение бара, используется для выделения бара с текущем выбранным предметом.
     */
    public function show ():void {
        alpha = 1;
    }

    /**
     * Затетённое отображение бара, используется для затенения бара с не текущем выбранным предметом.
     */
    public function hide ():void {
        alpha = .3;
    }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

    /**
     * Позиционирование иконки.
     * @param icon Иконка для позиционирования.
     */
    protected function placeIcon (icon:DisplayObject):void {
        icon.x = ICON_X;
        icon.y = ICON_Y;
    }



}
}
