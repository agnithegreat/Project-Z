/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz {
import com.projectz.model.Game;
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.view.GameScreen;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;

    private var _game: Game;
    private var _view: GameScreen;
//    private var _ui: UI;

    public function App() {
        _objectsStorage = new ObjectsStorage();
    }

    public function start($assets: AssetManager):void {
        _assets = $assets;
        _assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            Starling.juggler.delayCall(initStart, 0.15);

            stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        }
    }

    private function initStart():void {
        _objectsStorage.parseDirectory("textures/{0}x/level_elements", _assets);

        Starling.juggler.delayCall(startGame, 0.15);
    }

    private function startGame():void {
        _game = new Game(_objectsStorage);

        _view = new GameScreen(_game, _assets);
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

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(stage, TouchPhase.ENDED)) {
//            if (_game) {
//                endGame();
//                startGame();
//            }
        }
    }
}
}
