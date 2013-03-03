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

import starling.display.Sprite;

public class App extends Sprite {

    private var _game: Game;
    private var _view: GameScreen;
//    private var _ui: UI;

    public function App() {
    }

    public function start():void {
        _game = new Game();
        _game.init();

        _view = new GameScreen(_game);
        addChild(_view);
    }
}
}
