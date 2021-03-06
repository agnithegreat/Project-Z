/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:00
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.AppSettings;

CONFIG::web {
    import flash.net.URLLoader;
    import flash.net.URLRequest;
}

CONFIG::desktop {
    import flash.desktop.NativeApplication;
    import flash.filesystem.File;
}

import com.projectz.game.App;
import com.projectz.utils.json.JSONLoader;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import starling.utils.formatString;

[SWF(frameRate="60", width="1024", height="768")]
public class Main extends Sprite {

//    [Embed(source="../assets/textures/loaderSD.png")]
//    private static var Background:Class;
//
//    // Startup image for HD screens
//    [Embed(source="../assets/textures/loaderHD.png")]
//    private static var BackgroundHD:Class;

//    [Embed(source="../fonts/poplarstd.ttf", embedAsCFF="false", fontFamily="Polar Std")]
//    private static const Polar:Class;

    private var _assets: AssetManager;

    private var viewPort:Rectangle;
    private var basicAssetsPath:String;
    private var _scaleFactor: Number;

    private var _starling: Starling;

    private var _config: JSONLoader;

    public function Main() {
        _config = new JSONLoader(File.applicationDirectory.resolvePath("config.json"));
        _config.addEventListener(starling.events.Event.COMPLETE, handleLoaded);
        _config.load();
    }

    private function handleLoaded(event:starling.events.Event):void {
        if (!_config.data.path) {
            _config.data.path = File.applicationDirectory.nativePath;
        }
        init();
    }

    private function init():void {
        var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !iOS;

        Fonts.init();

        viewPort = RectangleUtil.fit(
                new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                iOS ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                ScaleMode.SHOW_ALL);

        // TODO: подготовить графику для retina
//        _scaleFactor = viewPort.width < 1152 ? 1 : 2;
        _scaleFactor = 1;
        AppSettings.scaleFactor = _scaleFactor;
        _assets = new AssetManager(_scaleFactor);
        basicAssetsPath = formatString("textures/{0}x/final", _scaleFactor);

        _assets.verbose = Capabilities.isDebugger;

        CONFIG::desktop {
            var dir: File = new File(_config.data.path);
            _assets.verbose = false;
            _assets.enqueue(
                dir.resolvePath("sounds"),
                dir.resolvePath(basicAssetsPath)
            );
            initApp ();
        }


        CONFIG::web {
            //загружаем xml файл c асетами:
            var urlLoader:URLLoader = new URLLoader ();
            urlLoader.addEventListener (flash.events.Event.COMPLETE, completeListener_loadTexturesListXml);
            urlLoader.load (new URLRequest (Constants.TEXTURES_LIST_XML_URL));
        }
    }

    private function initApp ():void {

//        _background = _scaleFactor == 1 ? new Background() : new BackgroundHD();
//        Background = BackgroundHD = null;

//        _background.x = viewPort.x;
//        _background.y = viewPort.y;
//        _background.width  = viewPort.width;
//        _background.height = viewPort.height;
//        _background.smoothing = true;
//        addChild(_background);

        _starling = new Starling(App, stage, viewPort);
        _starling.stage.stageWidth  = Constants.WIDTH;
        _starling.stage.stageHeight = Constants.HEIGHT;
        _starling.showStats = true;
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;

        _starling.addEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);

        CONFIG::desktop {
            NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });

            NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
        }
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);
//        removeChild(_background);

//        var bgTexture:Texture = Texture.fromBitmap(_background, false, false, _scaleFactor);

        app.start(_assets, _config.data.path);
        _starling.start();
    }

CONFIG::web {
    private function completeListener_loadTexturesListXml (event:flash.events.Event):void {
        var urlLoader:URLLoader = URLLoader (event.currentTarget);
        urlLoader.removeEventListener (flash.events.Event.COMPLETE, completeListener_loadTexturesListXml);
        var xml:XML = XML (urlLoader.data);

        //добавляем урлы всех асетов из xml файла в AssetManager:
        for (var i:int; i < xml.texture.length(); i++) {
            var url:String = xml.texture [i];
            _assets.enqueue(basicAssetsPath + url);
//            trace ('add asset url: "' + (basicAssetsPath + url) + '"');
        }

        initApp ();
    }
}

}
}
