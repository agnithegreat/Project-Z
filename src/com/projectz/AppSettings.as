/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 15:18
 * To change this template use File | Settings | File Templates.
 */
package com.projectz {

public class AppSettings {

    private static var _scaleFactor:int = 1;

    public function AppSettings() {

    }

    public static function get scaleFactor():int {
        return _scaleFactor;
    }

    public static function set scaleFactor(value:int):void {
        _scaleFactor = value;
    }

    public static function get appWidth ():int {
        return Constants.WIDTH * _scaleFactor;
    }

    public static function get appHeight ():int {
        return Constants.HEIGHT * _scaleFactor;
    }

}
}
