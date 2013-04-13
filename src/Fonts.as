/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 13.04.13
 * Time: 13:36
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.net.URLRequest;

public class Fonts {

    private static var _path: String;
    private static var _stack: Array;
    private static var _loader: Loader;

    public static function init($path: String, $fonts: Array):void {
        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);

        _path = $path;
        _stack = $fonts;

        next();
    }

    private static function next():void {
        if (_stack.length>0) {
            load(_stack.pop());
        } else {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
        }
    }

    private static function load($font: String):void {
        _loader.load(new URLRequest(_path+$font));
    }

    private static function loaderCompleteHandler(event:Event):void {
        var loaderInfo:LoaderInfo = event.target as LoaderInfo;
        var FontClass:Class = loaderInfo.applicationDomain.getDefinition("MotoFontInfo") as Class;
        if (FontClass){
            var fontName:String = FontClass.FONT_NAME;
            var definitionName:String = FontClass.FONT_CLASS;
            var fontClass:Class = loaderInfo.applicationDomain.getDefinition(definitionName) as Class;
        }

        next();
    }
}
}
