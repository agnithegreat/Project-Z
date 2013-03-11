/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 12:38
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.geom.Point;

public class PathData {

    private var _id:int;
    private var _points:Vector.<Point> = new Vector.<Point> ();//массив точек, образующих путь

    public function PathData() {

    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get id():int {
        return _id;
    }

    public function set id(value:int):void {
        _id = value;
    }

    public function get points():Vector.<Point> {
        return _points;
    }

}
}
