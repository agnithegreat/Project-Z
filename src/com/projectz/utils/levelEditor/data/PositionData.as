/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 28.03.13
 * Time: 8:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

public class PositionData {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _radius: int;
    public function get radius():int {
        return _radius;
    }
    public function set radius($value: int):void {
        _radius = $value;
    }

    // TODO: добавить эффекты
    private var _effects: Vector;

    public function PositionData() {
    }

    public function place($x: int, $y: int):void {
        _x = $x;
        _y = $y;
    }

    public function parse($data: Object):void {
        _x = $data.x;
        _y = $data.y;
        _radius = $data.radius;
    }

    public function export():Object {
        return {"x": _x, "y": _y, "radius": _radius};
    }
}
}
