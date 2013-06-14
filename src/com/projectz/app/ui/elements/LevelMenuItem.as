/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 13.06.13
 * Time: 13:59
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.elements {
import com.projectz.AppSettings;
import com.projectz.app.ui.TextFieldManager;
import com.projectz.utils.levelEditor.data.LevelData;

import starling.display.Image;

import starling.display.Sprite;

import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.AssetManager;
import starling.utils.HAlign;

public class LevelMenuItem extends Sprite {

    private var assetManager:AssetManager;//Менеджер ресурсов старлинга.

    private var _tf:TextField;
    private var _levelData:LevelData;

    private var levelMenuItemImage:Image;
    private var levelPreviewContainer:Sprite;

    private static const LEVEL_PREVIEW_CONTAINER_X:int = 5;
    private static const LEVEL_PREVIEW_CONTAINER_Y:int = 5;
    private static const LEVEL_PREVIEW_WIDTH:int = 256;
    private static const LEVEL_PREVIEW_HEIGHT:int = 192;

    private static const TX_X:int = 5;
    private static const TF_Y:int = 202;
    private static const TF_WIDTH:int = 256;
    private static const TF_HEIGHT:int = 51;

    /**
     * @param assetManager Менеджер ресурсов старлинга.
     */
    public function LevelMenuItem (assetManager:AssetManager) {

        var scaleFactor:int =  AppSettings.scaleFactor;

        levelPreviewContainer = new Sprite();
        levelPreviewContainer.x = LEVEL_PREVIEW_CONTAINER_X * scaleFactor;
        levelPreviewContainer.y = LEVEL_PREVIEW_CONTAINER_Y * scaleFactor;
        addChild(levelPreviewContainer);

        this.assetManager = assetManager;

        var levelMenuItemTexture:Texture = assetManager.getTexture("level_list_item");
        levelMenuItemImage = new Image(levelMenuItemTexture);
        addChild(levelMenuItemImage);

        _tf = new TextField(TF_WIDTH * scaleFactor, TF_HEIGHT * scaleFactor, "", "PoplarStd", 40 * scaleFactor, 0xFFFFFF);
        _tf.hAlign = HAlign.CENTER;
        _tf.x = TX_X;
        _tf.y = TF_Y;
        TextFieldManager.setAppDefaultStyle(_tf);
        _tf.fontSize = 40 * scaleFactor;
        addChild(_tf);
    }

    public function get levelData():LevelData {
        return _levelData;
    }

    public function set levelData(value:LevelData):void {
        _levelData = value;

        if (_levelData) {
            _tf.text = "Level " + _levelData.id;

            levelPreviewContainer.removeChildren();
            var levelPreviewImage:Image = new Image (assetManager.getTexture("level_preview_" + _levelData.id));
            levelPreviewImage.width = LEVEL_PREVIEW_WIDTH * AppSettings.scaleFactor;
            levelPreviewImage.height = LEVEL_PREVIEW_HEIGHT * AppSettings.scaleFactor;
            levelPreviewContainer.addChild(levelPreviewImage);
        }
    }

    public function destroy ():void {
        levelMenuItemImage.dispose();
        levelPreviewContainer.removeChildren();
        levelPreviewContainer.dispose();
        _tf.dispose();
        dispose();
    }
}
}
