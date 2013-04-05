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
import com.projectz.utils.levelEditor.ui.SelectConfigPanel;

import flash.display.Sprite;
import flash.events.MouseEvent;

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

    private var _config: JSONLoader;
    private var _directory: File;
    private var selectConfigPanel: SelectConfigPanel;

    public function LevelEditor() {
        addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
    }

    private function addedToStageListener (event:flash.events.Event):void {
        _config = new JSONLoader(File.applicationDirectory.resolvePath("config.json"));
        _config.addEventListener(Event.COMPLETE, completeListener_loadConfigFile);
        _config.load();
    }

    private function completeListener_loadConfigFile(event:Event):void {
        trace("completeListener_loadConfigFile");
        _config.removeEventListener(Event.COMPLETE, completeListener_loadConfigFile);
        if (_config.data.path) {
            _directory = new File(_config.data.path);
            init();
        } else {
            trace("нет пути");
            _directory = new File();
            _directory.addEventListener(Event.SELECT, handleSelect);
            _directory.addEventListener(Event.CANCEL, handleCancel);

            selectConfigPanel = new SelectConfigPanel();
            selectConfigPanel.btnSelectPath.addEventListener(MouseEvent.CLICK, clickListener_selectPath);
            selectConfigPanel.btnSaveConfig.addEventListener(MouseEvent.CLICK, clickListener_btnSaveConfig);
            selectConfigPanel.btnStart.addEventListener(MouseEvent.CLICK, clickListener_btnStart);
            addChild (selectConfigPanel);
            selectConfigPanel.selectPathStep();
        }
    }

    private function completeListener_saveConfigFile(event:Event):void {
        trace("completeListener_saveConfigFile");
        selectConfigPanel.finalStep();
    }


    private function clickListener_selectPath (event:MouseEvent):void {
        trace("clickListener_selectPath");
        _directory.browseForDirectory("Final");
    }

    private function clickListener_btnSaveConfig (event:MouseEvent):void {
        trace("clickListener_btnSaveConfig");
        _config.addEventListener(Event.COMPLETE, completeListener_saveConfigFile);
        _config.save(_config.data);
    }

    private function clickListener_btnStart (event:MouseEvent):void {
        trace("clickListener_btnStart");
        removeChild(selectConfigPanel);
        init();
    }

    private function handleSelect(event:Object):void {
        trace("handleSelect");
        _config.data.path = _directory.nativePath;
        selectConfigPanel.showPath(_config.data.path);
        selectConfigPanel.saveConfigStep();
    }

    private function handleCancel(event:Object):void {
        trace("handleCancel");
    }

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
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;
        _starling.addEventListener(Event.ROOT_CREATED, handleRootCreated);
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(Event.ROOT_CREATED, handleRootCreated);

        app.startLoading(_assets, _config.data.path);
        _starling.start();
    }

}
}
