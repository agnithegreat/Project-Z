/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 22.05.13
 * Time: 15:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {

import flash.filters.GlowFilter;

import starling.core.Starling;
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

    private var _glow:Boolean = false;

    //FOR TEST+++
    private var currentPercent:int = 0;
    //FOR TEST---

    public function BasicBar($assets: AssetManager) {
        _imgGlow = new Image($assets.getTexture("bar_radial-glow"));
        addChild(_imgGlow);

        _imgBack = new Image($assets.getTexture("bar_radial-back"));
        addChild(_imgBack);

        var progressTexture:Texture = $assets.getTexture("bar_radial-progress_2");

        var textureWidth:int = progressTexture.width;
        _nGonProgress = new NGon(textureWidth / 2, 50, textureWidth / 4, 0, 0);
        _nGonProgress.x = 52;
        _nGonProgress.y = 52;
        _nGonProgress.material = new StandardMaterial( new StandardVertexShader(), new TextureFragmentShader() );
        _nGonProgress.material.textures[0] = progressTexture;
        addChild(_nGonProgress);

        _iconContainer = new Sprite();
        addChild(_iconContainer);

        _tf = new TextField(104, 40, "", "Poplar Std", 30, 0xffffff);
        _tf.hAlign = HAlign.CENTER;
//        _tf.filter = BlurFilter.createGlow(0, 1, 2, 1);
        var glowFilter:GlowFilter = new GlowFilter();
        glowFilter.color = 0x000000;
        glowFilter.blurX = 5;
        glowFilter.blurY = 5;
        glowFilter.strength = 4;
//        glowFilter.inner = true;
        _tf.nativeFilters = [glowFilter];
        addChild(_tf);
        _tf.y = 56;

        glow = glow;

        //FOR TEST+++
        setTestPercent();
        var str:String = String(Math.round(Math.random() * 999));
        var newStr:String = "";
        for (var i:int = 0; i < str.length; i++) {
            newStr += str.charAt(i) + " ";
        }
        newStr = newStr.substr (0, newStr.length - 2);
//        setText(newStr);
        setText(str);
        //FOR TEST---
    }

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
        _nGonProgress.startAngle = 0;
        _nGonProgress.endAngle = percent / 100 * 360;
    }

    public function setText (text:String):void {
        _tf.text = text;
    }


    //FOR TEST+++
    private function setTestPercent ():void {

        var randomPercent:int = Math.random() * 100;
        setPercent (currentPercent);
//        setPercent (randomPercent);
        currentPercent += 5;
        if (currentPercent == 100) {
            currentPercent = 0;
        }
        Starling.juggler.delayCall(setTestPercent, .5);
    }
    //FOR TEST---
}
}
