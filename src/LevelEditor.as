/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.utils.levelEditor.App;

import flash.display.Sprite;

import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.formatString;

[SWF(frameRate="60")]
public class LevelEditor extends Sprite {

    private var _assets: AssetManager;
    private var _starling: Starling;

    private var _so: SharedObject;
    private var _directory: File;

    public function LevelEditor() {
        checkPath();
    }

    private function checkPath():void {
        _so = SharedObject.getLocal("dropbox", "/");
        if (_so.data.path) {
            _directory = new File(_so.data.path);
            init();
        } else {
            _directory = new File();
            _directory.addEventListener("select", handleSelect);
            _directory.browseForDirectory("Final");
        }
    }

    private function handleSelect(event:Object):void {
        _so.data.path = _directory.nativePath;
        init();
    }

    private function init():void {
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = false;

        var viewPort:Rectangle = new Rectangle(0, 0, Constants.WIDTH+200, Constants.HEIGHT);

        _assets = new AssetManager();

        _assets.verbose = Capabilities.isDebugger;
        _assets.verbose = false;
        _assets.enqueue(
                _directory.resolvePath(formatString("textures/{0}x", 1))
        );

        _starling = new Starling(App, this.stage, viewPort);
        _starling.stage.stageWidth  = Constants.WIDTH+200;
        _starling.stage.stageHeight = Constants.HEIGHT;
        _starling.showStats = true;
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        app.startLoading(_assets, _so.data.path);
        _starling.start();
    }

}
}
