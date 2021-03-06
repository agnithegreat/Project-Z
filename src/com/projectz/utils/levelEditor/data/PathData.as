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
    private var _points:Vector.<String>;//массив точек (строк формата "x_y"), образующих путь, по которому перемещаются враги.

    public function PathData() {
        _points = new Vector.<String>();
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function get id():Number {
        return _id;
    }

    public function set id(value:Number):void {
        _id = value;
    }

    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        _color = value;
    }

    public function clearAllPoints ():void {
        _points = new Vector.<String>();
    }

    public function parse($data: Object):void {
        _id = $data.id;
        _color = uint ($data.color);
        _points = new Vector.<String>();
        var len:int = $data.points.length;
        for (var i:int = 0; i < len; i++) {
            var pointData:Object = $data.points[i];
            var pointAsString: String = String(pointData.x + "_"  + pointData.y);
            _points.push(pointAsString);
        }
    }

    public function export():Object {
        //Преобразовываем Vector из строкового представления {x_y} в строковое представление {"x":x,"y":y}:
        var arrPointsAsObjects:Array/*of Objects {"x":x,"y":y}*/ = new Array()/*of Objects {"x":x,"y":y}*/;
        var len: int = _points.length;
        for (var i:int = 0; i < len; i++) {
            var point:Point = DataUtils.stringDataToPoint(_points [i]);
            arrPointsAsObjects[i] = {"x":point.x, "y":point.y};
        }
        return {"id": _id, "color": _color, "points": arrPointsAsObjects};
    }

    public function get points():Vector.<String> {
        return _points;
    }
}
}
