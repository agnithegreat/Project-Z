/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:00
 * To change this template use File | Settings | File Templates.
 */
package {
import com.projectz.App;

import flash.display.Bitmap;
import flash.display.Sprite;
CONFIG::desktop {
    import flash.desktop.NativeApplication;
    import flash.filesystem.File;
    import flash.events.Event;
}
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

    private var _scaleFactor: Number;

    private var _starling: Starling;

    public function Main() {
        var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !iOS;

        var viewPort:Rectangle = RectangleUtil.fit(
                new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                iOS ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, Constants.WIDTH, Constants.HEIGHT),
                ScaleMode.SHOW_ALL);

        _scaleFactor = viewPort.width < 1152 ? 1 : 2;
        _assets = new AssetManager(_scaleFactor);
        _assets.verbose = Capabilities.isDebugger;
        var basicAssetsPath:String = formatString("textures/{0}x", _scaleFactor);

        CONFIG::desktop {
            var appDir:File = File.applicationDirectory;
//            _assets.verbose = false;
            _assets.enqueue(
//                appDir.resolvePath("audio"),
//                appDir.resolvePath("fonts"),
                appDir.resolvePath(basicAssetsPath)
            );
        }

        CONFIG::web {
            _assets.enqueue(basicAssetsPath + "/level_elements/backgrounds/bg-test.jpg");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_1.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_1.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_2.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_2.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_3.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_3.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_4.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_4.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_5.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_attack_5.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_die.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_die.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_1.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_1.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_2.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_2.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_3.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_3.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_4.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_4.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_5.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/enemies/zombie/zombie_walk_5.xml");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-cell.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-shadow-tree-01.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-testbox.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-testwall.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-tree-01.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-testcar.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-testhome-downlayer.png");
            _assets.enqueue(basicAssetsPath + "/level_elements/static_objects/so-testhome-uplayer.png");
        }

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

        CONFIG::web {
            //_starling.start();
        }
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);
//        removeChild(_background);

//        var bgTexture:Texture = Texture.fromBitmap(_background, false, false, _scaleFactor);

        app.start(_assets);
        _starling.start();
    }
}
}
