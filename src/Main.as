/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:00
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.textures.Texture;

import starling.utils.AssetManager;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;

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

    private var _scaleFactor: Number;

    private var _starling: Starling;

    public function Main() {
        var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !iOS;

        var viewPort:Rectangle = RectangleUtil.fit(
                new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
                ScaleMode.SHOW_ALL);

        _scaleFactor = viewPort.width < 480 ? 1 : 2;
//        var appDir:File = File.applicationDirectory;
//        _assets = new AssetManager(_scaleFactor);
//
//        _assets.verbose = Capabilities.isDebugger;
//        _assets.verbose = true;
//        _assets.enqueue(
//                appDir.resolvePath("audio"),
//                appDir.resolvePath("fonts"),
//                appDir.resolvePath(formatString("textures/{0}x", _scaleFactor))
//        );

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

        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });

        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);
//        removeChild(_background);

//        var bgTexture:Texture = Texture.fromBitmap(_background, false, false, _scaleFactor);

//        app.start(bgTexture, _assets);
        _starling.start();
    }
}
}
