/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game {
import com.projectz.app.ui.popups.PopUpManager;
import com.projectz.game.controller.GameController;
import com.projectz.game.controller.UIController;
import com.projectz.game.model.Game;
import com.projectz.app.ui.popups.PopUpContainer;
import com.projectz.app.ui.screens.AppScreens;
import com.projectz.app.ui.screens.ScreensStorage;
import com.projectz.app.ui.screens.IScreen;
import com.projectz.app.ui.screens.LevelMenuScreen;
import com.projectz.app.ui.screens.ScreensContainer;
import com.projectz.utils.json.JSONManager;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.objectEditor.ObjectDataManager;
import com.projectz.utils.objectEditor.data.DefenderData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.app.ui.screens.GameScreen;

import feathers.themes.MetalWorksMobileTheme;

import flash.utils.Dictionary;

import starling.display.DisplayObject;

import starling.events.Event;
import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.utils.formatString;

public class App extends Sprite {

    //Скрины:
    private static var _screenContainer:ScreensContainer;//Контейнер для отображения скринов.
    private static var _screenStorage:ScreensStorage;//Хранилище скринов.

    //Попапы:
    private static var _popUpContainer:PopUpContainer;//Контейнер для отображения попапов.

    //Попапы:
    private var _assetsManager: AssetManager;//Менеджер ресурсов старлинга.
    private var _objectsStorage: ObjectsStorage;//Хранилище данных об  игровых объектов.
    private var _levelsStorage: LevelStorage;//Хранилище данных об уровнях игры.

    private var _jsonManager: JSONManager;

    //Модель (mvc):
    private var _game: Game;

    //Контроллер (mvc):
    private var _controller: GameController;
    private var _uiController: UIController;

    private var _theme:MetalWorksMobileTheme; //Тема для ui (из  движка feathers).

    private var _assetsPath: String;//Путь к асетам для загрузки.

    public function App() {
        _objectsStorage = new ObjectsStorage();
        _levelsStorage = new LevelStorage();

        addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
    }

    /**
     * Отображение указанного экрана приложения.
     * @param screenId Id'шник экрана.
     * @see com.projectz.app.ui.screens.ScreensStorage
     */
    public static function openScreen (screenId:String):void {
        var screen:IScreen = _screenStorage.getScreen (screenId);
        _screenContainer.open (screen);
    }

    /**
     * Добавление (отображение) попапа.
     *
     * @param popUp Попап для отображения.
     */
    public static function showPopUp (popUp:DisplayObject):void {
        if (_popUpContainer) {
            _popUpContainer.showPopUp (popUp);
        }
    }

    /**
     * Удаление (скрытие) попапа.
     *
     * @param popUp Попап для удаления.
     */
    public static function hidePopUp (popUp:DisplayObject):void {
        if (_popUpContainer) {
            _popUpContainer.showPopUp (popUp);
        }
    }

    public function start($assets: AssetManager, $path: String):void {
        _assetsPath = $path;

        _assetsManager = $assets;
        _assetsManager.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            Starling.juggler.delayCall(initStart, 0.15);
        }
    }

    private function initStart():void {
        _jsonManager = new JSONManager();
        _jsonManager.addEventListener(Event.CHANGE, handleLoadProgress);
        _jsonManager.addEventListener(Event.COMPLETE, handleLoaded);

        _objectsStorage.parseDirectory(formatString(_assetsPath+"/textures/{0}x/final/level_elements", _assetsManager.scaleFactor), _assetsManager);
        _jsonManager.addFiles(_objectsStorage.objects);

        _levelsStorage.parseDirectory(_assetsPath+"/levels");
        _jsonManager.addFiles(_levelsStorage.levels);

        _jsonManager.load();
    }

    private function handleLoadProgress($event: Event):void {
//        trace("JSON loading progress:", $event.data);
    }

    private function handleLoaded($event: Event):void {
        _jsonManager.removeEventListener(Event.CHANGE, handleLoadProgress);
        _jsonManager.removeEventListener(Event.COMPLETE, handleLoaded);

        startGame();
    }

    private function startGame():void {
        _game = new Game(_objectsStorage, _levelsStorage.getLevelData(2));
        _controller = new GameController(_game);
        _uiController = new UIController(_controller, _assetsManager);

        //Создаём скрины:
        var _gameScreen:GameScreen = new GameScreen(_game, _uiController, _assetsManager);
        var _levelMenuScreen:LevelMenuScreen = new LevelMenuScreen(_game, _uiController, _levelsStorage, _assetsManager);

        _screenStorage = new ScreensStorage();
        _screenStorage.addScreen (_gameScreen, AppScreens.GAME_SCREEN);
        _screenStorage.addScreen (_levelMenuScreen, AppScreens.LEVEL_MENU_SCREEN);

        //Создаём контейнер для скринов:
        var containerForScreens:Sprite = new Sprite();
        addChild(containerForScreens);
        _screenContainer = new ScreensContainer(containerForScreens);

        //Показываем игровой экран:
        openScreen (AppScreens.GAME_SCREEN);

        //Создаём контейнер для попапов:
        var containerForScreensPopUps:Sprite = new Sprite();
        addChild(containerForScreensPopUps);
        _popUpContainer = new PopUpContainer (containerForScreensPopUps);
        //Инициализируем менеджер попапов:
        PopUpManager.getInstance().init(_assetsManager);

        //FOR TESTS+++
        var allDefendersAsDictionary:Dictionary = _objectsStorage.getObjectsByType (ObjectType.DEFENDER);
        var allDefendersAsVector:Vector.<DefenderData> = new Vector.<DefenderData>();
        var defenderData:DefenderData;
        for each (defenderData in allDefendersAsDictionary) {
            allDefendersAsVector.push (defenderData);
        }
        allDefendersAsVector.sort(ObjectDataManager.sortByName);
        _gameScreen.initDefenders(allDefendersAsVector);
        //FOR TESTS---

        _game.init();
    }

//////////////////////////////////
//LISTENERS:
//////////////////////////////////

    private function addedToStageListener (event:Event):void {
        _theme = new MetalWorksMobileTheme(stage);
    }
}
}
