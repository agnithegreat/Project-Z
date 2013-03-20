/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.03.13
 * Time: 18:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

import flash.geom.Point;

public class PathData {

    private var _id: Number;
    private var _color: uint = 0x00ff00;//цвет нужен только для редактора путей в LevelEditor'е.
    private var _points:Vector.<Point>;//массив точек, образующих путь, по которому перемещаются враги.

    public function PathData() {
        _points = new Vector.<Point>();
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get id():Number {
        return _id;
    }

    public function set id(value:Number):void {
        value = _id;
    }

    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        _color = value;
    }

    public function clearAllPoints ():void {
        _points = new Vector.<Point>();
    }

    public function parse($data: Object):void {
        _id = $data.id;
        _color = uint ($data.color);
        _points = new Vector.<Point>();
        var len:int = $data.points.length;
        for (var i:int = 0; i < len; i++) {
            var pointData:Object = $data.points [i];
            var point: Point = new Point(pointData.x, pointData.y);
            _points.push(point);
        }
    }

    public function export():Object {
        return {"id": _id, "color": _color, "points": _points.toString()};
    }

    public function get points():Vector.<Point> {
        return _points;
    }
}
}
