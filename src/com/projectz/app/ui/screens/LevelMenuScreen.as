/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.06.13
 * Time: 11:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {
import com.projectz.AppSettings;
import com.projectz.app.ui.elements.LevelMenuItem;
import com.projectz.app.ui.popups.PopUpManager;
import com.projectz.game.controller.UIController;
import com.projectz.game.model.Game;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.LevelStorage;

import feathers.controls.ScrollContainer;

import feathers.layout.TiledRowsLayout;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.utils.Dictionary;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class LevelMenuScreen extends Sprite implements IScreen {

    private var game:Game;//Хранилище данных об уровнях игры.
    private var levelsStorage:LevelStorage;//Хранилище данных об уровнях игры.
    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var assetsManager:AssetManager;//Менеджер ресурсов старлинга.

    private var scrollContainer:ScrollContainer;
    private var levelMenuItems:Vector.<LevelMenuItem> = new Vector.<LevelMenuItem> ();

    private static const SCROLL_CONTAINER_Y:int = 56;
    private static const SCROLL_CONTAINER_INDENT:int = 12;

    /**
     * @$game game Ссылка на модель (mvc).
     * @param uiController Ссылка на контроллер (mvc).
     * @param levelsStorage Хранилище данных об уровнях игры.
     * @param assetsManager Менеджер ресурсов старлинга.
     */
    public function LevelMenuScreen(game:Game, uiController:UIController, levelsStorage:LevelStorage, assetsManager: AssetManager) {
        this.game = game;
        this.uiController = uiController;
        this.levelsStorage = levelsStorage;
        this.assetsManager = assetsManager;

        //Рисуем тестовый бекграунд:
        var bitmapData:BitmapData = new BitmapData (AppSettings.appWidth, AppSettings.appHeight, false, 0x000000);
        const INDENT:int = 5;
        var bitmapData2:BitmapData = new BitmapData (AppSettings.appWidth - INDENT * 2, AppSettings.appHeight - INDENT * 2, false, 0x999999);
        var matrix:Matrix = new Matrix();
        matrix.translate (INDENT, INDENT);
        bitmapData.draw (bitmapData2, matrix);
        var texture:Texture = Texture.fromBitmapData (bitmapData);
        var image:Image = new Image (texture);
        addChild (image);

        //Настариваем отображение уровней в виде списка:
        var layout:TiledRowsLayout = new TiledRowsLayout();

        var itemCount:int = 400;
        layout.paging = TiledRowsLayout.PAGING_NONE;
        layout.gap = 10;
        layout.paddingTop = 0;
        layout.paddingRight = 0;
        layout.paddingBottom = 0;
        layout.paddingLeft = 0;
        layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
        layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
        layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
        layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
        layout.useSquareTiles = false;

        var scrollContainerIndent:int = SCROLL_CONTAINER_INDENT * AppSettings.scaleFactor;
        var scrollContainerY:int = SCROLL_CONTAINER_Y * AppSettings.scaleFactor;
        scrollContainer = new ScrollContainer();
        scrollContainer.x = scrollContainerIndent;
        scrollContainer.y = scrollContainerY;
        scrollContainer.width = AppSettings.appWidth - scrollContainerIndent * 2;
        scrollContainer.height = AppSettings.appHeight - (scrollContainerY + scrollContainerIndent);

        scrollContainer.layout = layout;
        scrollContainer.scrollerProperties.snapToPages = true;
        scrollContainer.scrollerProperties.snapScrollPositionsToPixels = true;
        addChild(this.scrollContainer);
    }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

    /**
     * @inheritDoc
     */
    public function onOpen ():void {
        var levelMenuItem:LevelMenuItem;

        //Очищаем превьюшки уровней:
        var numLevelMenuItems:int = levelMenuItems.length;
        for (var i:int = 0; i < numLevelMenuItems; i++) {
            levelMenuItem = levelMenuItems [i];
            levelMenuItem.removeEventListener(TouchEvent.TOUCH, touchListener);
            levelMenuItem.removeFromParent();
            levelMenuItem.destroy();
        }
        levelMenuItems = new Vector.<LevelMenuItem>();

        //Формируем список превьюшек уровней:
        var levels:Dictionary = levelsStorage.levels;
        var currentLevelData:LevelData;

        for each (currentLevelData in levels) {
            levelMenuItem = new LevelMenuItem (assetsManager);
            levelMenuItem.levelData = currentLevelData;
            levelMenuItem.addEventListener(TouchEvent.TOUCH, touchListener);
            levelMenuItems.push(levelMenuItem);
            scrollContainer.addChild(levelMenuItem);
        }

        //Сортируем превьюшки уровней:
        levelMenuItems.sort(sortFunction);

        //Показываем превьюшки уровней:
        numLevelMenuItems = levelMenuItems.length;
        for (i = 0; i < numLevelMenuItems; i++) {
            levelMenuItem = levelMenuItems [i];
            scrollContainer.addChild(levelMenuItem);
        }
    }

    /**
     * @inheritDoc
     */
    public function onClose ():void {

    }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

    private function sortFunction (item1:LevelMenuItem, item2:LevelMenuItem):int {
        if (item1.levelData && item2.levelData) {
            if (item1.levelData.id > item2.levelData.id) {
                return 1;
            }
            else if (item1.levelData.id < item2.levelData.id) {
                return -1;
            }
            else {
                return 0;
            }
        }
        else {
            return 0;
        }
    }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

    private function touchListener (event:TouchEvent):void {
        var touch:Touch = event.getTouch(stage);
        if (touch) {
            switch (touch.phase) {
                case TouchPhase.BEGAN:                                      // press
                   var levelMenuItem:LevelMenuItem = LevelMenuItem (event.currentTarget);
                   var levelData:LevelData = levelMenuItem.levelData;
                   if (levelData) {
                       //TODO: Реализовать инициализацию уровня:
//                       game.field.level;
                       PopUpManager.getInstance().openScreen (AppScreens.GAME_SCREEN);
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
