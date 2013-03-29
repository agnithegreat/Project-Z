/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 29.03.13
 * Time: 14:04
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
public class WaveData {

    private var _id: int;
    public function get id():int {
        return _id;
    }
    public function set id($value:int):void {
        _id = $value;
    }

    private var _time: int;
    public function get time():int {
        return _time;
    }
    public function set time($value:int):void {
        _time = $value;
    }

    public function WaveData() {
    }

    public function parse($data: Object):void {
        _id = $data.id;
        _time = $data.time ? $data.time : 30;
    }

    public function export():Object {
        return {"id": _id, "time": _time};
    }

}
}
