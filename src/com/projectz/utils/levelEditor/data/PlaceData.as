/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 14.03.13
 * Time: 21:02
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import com.projectz.utils.objectEditor.data.ObjectData;

public class PlaceData {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _object: String;
    public function get object():String {
        return _object;
    }
    public function set object($value: String):void {
        _object = $value;
    }

    public var realObject: ObjectData;

    public function place($x: int, $y: int):void {
        _x = $x;
        _y = $y;
    }

    public function parse($data: Object):void {
        _x = $data.x;
        _y = $data.y;
        _object = $data.object;
    }

    public function export():Object {
        return {"x": _x, "y": _y, "object": _object};
    }
}
}
