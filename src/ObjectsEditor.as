/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:00
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.utils.objectEditor.App;

import flash.display.Sprite;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.formatString;

[SWF(frameRate="60")]
public class ObjectsEditor extends Sprite {

    private var _assets: AssetManager;

    private var _starling: Starling;

    public function ObjectsEditor() {
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = false;

        var viewPort:Rectangle = new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT);

        var appDir:File = File.applicationDirectory;
        _assets = new AssetManager();

        _assets.verbose = Capabilities.isDebugger;
        _assets.verbose = false;
        _assets.enqueue(
                appDir.resolvePath(formatString("textures/{0}x", 1))
        );

        _starling = new Starling(App, stage, viewPort);
        _starling.stage.stageWidth  = Constants.WIDTH;
        _starling.stage.stageHeight = Constants.HEIGHT;
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        app.start(_assets);
        _starling.start();
    }
}
}
