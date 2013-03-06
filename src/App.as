/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.model.Game;
import com.projectz.view.GameScreen;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class App extends Sprite {

    public static var assets: AssetManager;

    private var _game: Game;
    private var _view: GameScreen;
//    private var _ui: UI;

    public function App() {
    }

    public function start($assets: AssetManager):void {
        assets = $assets;
        assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            Starling.juggler.delayCall(startGame, 0.15);

            stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        }
    }

    private function startGame():void {
        _game = new Game();
        _game.init();

        _view = new GameScreen(_game);
        addChild(_view);
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
            if (_game) {
                endGame();
                startGame();
            }
        }
    }
}
}
