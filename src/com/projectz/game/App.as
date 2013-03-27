/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game {
import com.projectz.game.controller.GameController;
import com.projectz.game.controller.UIController;
import com.projectz.game.model.Game;
import com.projectz.utils.json.JSONManager;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.game.view.GameScreen;

import starling.events.Event;
import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.utils.formatString;

public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;
    private var _levelsStorage: LevelStorage;

    private var _jsonManager: JSONManager;

    private var _controller: GameController;
    private var _uiController: UIController;

    private var _game: Game;
    private var _view: GameScreen;
//    private var _ui: UI;

    private var _path: String;

    public function App() {
        _objectsStorage = new ObjectsStorage();
        _levelsStorage = new LevelStorage();
    }

    public function start($assets: AssetManager, $path: String):void {
        _path = $path;

        _assets = $assets;
        _assets.loadQueue(handleProgress);
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

        _objectsStorage.parseDirectory(formatString(_path+"/textures/{0}x/level_elements", _assets.scaleFactor), _assets);
        _jsonManager.addFiles(_objectsStorage.objects);

        _levelsStorage.parseDirectory(_path+"/levels");
        _jsonManager.addFiles(_levelsStorage.levels);

        _jsonManager.load();
    }

    private function handleLoadProgress($event: Event):void {
        trace("JSON loading progress:", $event.data);
    }

    private function handleLoaded($event: Event):void {
        _jsonManager.removeEventListener(Event.CHANGE, handleLoadProgress);
        _jsonManager.removeEventListener(Event.COMPLETE, handleLoaded);

        startGame();
    }

    private function startGame():void {
        _game = new Game(_objectsStorage, _levelsStorage.getLevelData("level_01"));
        _controller = new GameController(_game);
        _uiController = new UIController(_controller, _assets);

        _view = new GameScreen(_game, _uiController);
        addChild(_view);

        _game.init();
    }

    private function endGame():void {
        _view.destroy();
        _view.removeFromParent(true);
        _view = null;

        _game.destroy();
        _game = null;
    }
}
}
