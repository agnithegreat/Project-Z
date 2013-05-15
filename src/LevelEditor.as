/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.utils.json.JSONLoader;
import com.projectz.utils.levelEditor.App;
import com.projectz.utils.levelEditor.ui.ConfigPanel;

import flash.display.Sprite;

import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.formatString;

[SWF(frameRate="60", width="1424", height="768")]
public class LevelEditor extends Sprite {

    private var _assets: AssetManager;
    private var _starling: Starling;

    private var _config: JSONLoader;//Файлик с настройками самомго редактора (хранит ссылку на папку с файлами в dropbox).
    private var _directory: File;
    private var configPanel: ConfigPanel;//Стартовая панель редактора уровней для настройки работы редактора.

    /**
     * Основной класс редактора уровней.
     */
    public function LevelEditor() {
        _config = new JSONLoader(File.applicationDirectory.resolvePath("config.json"));
        _config.addEventListener(Event.COMPLETE, completeListener_loadConfigFile);
        _config.load();
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function init():void {
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = false;

        var viewPort:Rectangle = new Rectangle(0, 0, Constants.WIDTH+200, Constants.HEIGHT);

        _assets = new AssetManager();

        _assets.verbose = Capabilities.isDebugger;
        _assets.verbose = false;
        _assets.enqueue(
                _directory.resolvePath(formatString("textures/{0}x", 1)),
                _directory.resolvePath(formatString("utils/level_editor", 1))
        );

        _starling = new Starling(App, stage, viewPort);
        _starling.stage.stageWidth  = Constants.WIDTH+200;
        _starling.stage.stageHeight = Constants.HEIGHT;
        _starling.showStats = true;
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function completeListener_loadConfigFile(event:Event):void {
        _config.removeEventListener(Event.COMPLETE, completeListener_loadConfigFile);
        if (_config.data.path) {
            _directory = new File(_config.data.path);
            init();
        } else {
            _directory = new File();
            //Отображаем панель первого запуска редактора уровней для настройки пути к ассетам.
            configPanel = new ConfigPanel(_config, _directory);
            addChild (configPanel);
            configPanel.addEventListener(Event.COMPLETE, completeListener_start);
        }
    }

    private function completeListener_start(event:*):void {
        removeChild (configPanel);
        init();
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        app.startLoading(_assets, _config);
        _starling.start();
    }

}
}
