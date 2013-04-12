/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 28.03.13
 * Time: 8:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.geom.Point;

public class DefenderPositionData {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _availablePoints:Vector.<String>;//массив точек (строк формата "x_y").
    public function get availablePoints():Vector.<String> {
        return _availablePoints;
    }

    private var _area: Vector.<Point>;
    public function get area():Vector.<Point> {
        return _area;
    }

    public function DefenderPositionData() {
        _availablePoints = new <String>[];
    }

    public function clearAllDefenderZonesPoint ():void {
        _availablePoints = new Vector.<String>();
    }

    public function place($x: int, $y: int):void {
        _x = $x;
        _y = $y;
    }

    public function parse($data: Object):void {
        _x = $data.x;
        _y = $data.y;

        _area = new <Point>[];

        var len:int = $data.availablePoints ? $data.availablePoints.length : 0;
        for (var i:int = 0; i < len; i++) {
            var pointData:Object = $data.availablePoints[i];
            var pointAsString:String = String(pointData.x + "_"  + pointData.y);
            _availablePoints.push(pointAsString);
            _area.push(new Point(pointData.x, pointData.y));
        }
    }

    public function export():Object {
        return {"x": _x, "y": _y, "availablePoints": getAvailablePoints()};
    }


    private function getAvailablePoints():Array {
        //Преобразовываем Vector из строкового представления {x_y} в строковое представление {"x":x,"y":y}:
        var arrPointsAsObjects:Array/*of Objects {"x":x,"y":y}*/ = new Array()/*of Objects {"x":x,"y":y}*/;
        var len: int = _availablePoints.length;
        for (var i:int = 0; i < len; i++) {
            var point:Point = DataUtils.stringDataToPoint(_availablePoints [i]);
            arrPointsAsObjects[i] = {"x":point.x, "y":point.y};
        }
        return arrPointsAsObjects;
    }
}
}
