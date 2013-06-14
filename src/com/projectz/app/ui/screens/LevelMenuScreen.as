/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.06.13
 * Time: 11:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {
import com.projectz.game.App;
import com.projectz.app.ui.popups.PopUpManager;
import com.projectz.app.ui.screens.AppScreens;
import com.projectz.game.controller.UIController;
import com.projectz.utils.levelEditor.data.LevelStorage;

import flash.display.BitmapData;
import flash.geom.Matrix;

import starling.display.Button;
import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class LevelMenuScreen extends Sprite implements IScreen {

    private var levelsStorage:LevelStorage;//Хранилище данных об уровнях игры.
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    private var btnMenu:Button;

    /**
     * @param uiController Ссылка на контроллер (mvc).
     * @param levelsStorage Хранилище данных об уровнях игры.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function LevelMenuScreen(uiController:UIController, levelsStorage:LevelStorage, assetsManager: AssetManager) {
        this.uiController = uiController;
        this.levelsStorage = levelsStorage;
        this.assetsManager = assetsManager;

        var bitmapData:BitmapData = new BitmapData (Constants.WIDTH, Constants.HEIGHT, false, 0x000000);
        const INDENT:int = 5;
        var bitmapData2:BitmapData = new BitmapData (Constants.WIDTH - INDENT * 2, Constants.HEIGHT - INDENT * 2, false, 0x00ff00);
        var matrix:Matrix = new Matrix();
        matrix.translate (INDENT, INDENT);
        bitmapData.draw (bitmapData2, matrix);
        var texture:Texture = Texture.fromBitmapData (bitmapData);
        var image:Image = new Image (texture);
        addChild (image);

        var tf:TextField = new TextField (100, 60, "Level menu");
        addChild (tf);

        btnMenu = new Button (assetsManager.getTexture("btn-temp-02"));
        btnMenu.x = Constants.WIDTH - (btnMenu.width + 10);
        btnMenu.y = 10;
        btnMenu.addEventListener (TouchEvent.TOUCH, touchListener);
        addChild(btnMenu);
    }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

    /**
     * @inheritDoc
     */
    public function onOpen ():void {

    }

    /**
     * @inheritDoc
     */
    public function onClose ():void {

    }

    private function touchListener (event:TouchEvent):void {
        var touch:Touch = event.getTouch(stage);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.BEGAN:                                      // press
                    switch (event.currentTarget) {
                        case (btnMenu):
                            PopUpManager.getInstance().openScreen(AppScreens.GAME_SCREEN);
                            break;
                    }
                    break;
//                case TouchPhase.ENDED:                                      // click
//                    //
//                    break;
//                default :
            }
        }
    }
}
}
