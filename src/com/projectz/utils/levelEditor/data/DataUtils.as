/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 06.04.13
 * Time: 23:53
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.geom.Point;

public class DataUtils {

    public static function stringDataToPoint (string:String):Point {
        var point:Point = new Point();
        var pointAsArray:Array = string.split("_");
        if (pointAsArray.length > 0) {
            point.x = pointAsArray[0];
        }
        if (pointAsArray.length > 1) {
            point.y = pointAsArray[1];
        }
        return point;
    }

    public static function pointToStringData (point:Point):String {
        return (point.x + "_"  + point.y);
    }
}
}
