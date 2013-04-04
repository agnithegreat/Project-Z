/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 29.03.13
 * Time: 13:05
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

public class GeneratorWaveData {

    private var _id: int;
    public function get id():int {
        return _id;
    }
    public function set id($value:int):void {
        _id = $value;
    }

    private var _sequence: Array = new Array(); // of String: ["en-normal", "en-cock", "en-cock", ..]
    public function get sequence():Array {
        return _sequence;
    }

    public function get amount():int {
        return _sequence.length;
    }

    private var _delay: int;
    public function get delay():int {
        return _delay;
    }
    public function set delay($value: int):void {
        _delay = $value;
    }

    public function GeneratorWaveData() {
    }

    // TODO: добавить методы для изменения стэка монстров _sequence

    public function parse($data: Object):void {
        _sequence = $data.sequence ? $data.sequence.split(",") : [];
        _delay = $data.delay ? $data.delay : 60;
        _id = $data.id ? $data.id : 0;
        trace ("--- id = " + $data.id);
    }

    public function export():Object {
        return {"id": _id,"sequence": _sequence.join(","), "delay": _delay};
    }
}
}
