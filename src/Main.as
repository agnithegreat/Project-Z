/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:00
 * To change this template use File | Settings | File Templates.
 */
package {

CONFIG::web {
    import flash.net.URLLoader;
    import flash.net.URLRequest;
}

CONFIG::desktop {
    import flash.desktop.NativeApplication;
    import flash.filesystem.File;
}

import com.projectz.game.App;

import flash.display.Bitmap;
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

[SWF(frameRate="60")]
public class Main extends Sprite {

//    [Embed(source="../assets/textures/loaderSD.png")]
//    private static var Background:Class;
//
//    // Startup image for HD screens
//    [Embed(source="../assets/textures/loaderHD.png")]
//    private static var BackgroundHD:Class;
//
//    [Embed(source="../assets/fonts/segoepr.ttf", embedAsCFF="false", fontFamily="Segoe Print")]
//    private static const Segoe:Class;

    private var _assets: AssetManager;
    private var _background: Bitmap;

    private var viewPort:Rectangle;
    private var basicAssetsPath:String;
    private var _scaleFactor: Number;

    private var _starling: Starling;

    public function Main() {
        var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !iOS;

        viewPort = RectangleUtil.fit(
                new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                iOS ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                ScaleMode.SHOW_ALL);

        // TODO: подготовить графику для retina
//        _scaleFactor = viewPort.width < 1152 ? 1 : 2;
        _scaleFactor = 1;
        _assets = new AssetManager(_scaleFactor);
        basicAssetsPath = formatString("textures/{0}x", _scaleFactor);

        _assets.verbose = Capabilities.isDebugger;

        CONFIG::desktop {
            var appDir:File = File.applicationDirectory;
            _assets.verbose = false;
            _assets.enqueue(
                appDir.resolvePath("sounds"),
//                appDir.resolvePath("fonts"),
                appDir.resolvePath(basicAssetsPath)
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

        app.start(_assets);
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
