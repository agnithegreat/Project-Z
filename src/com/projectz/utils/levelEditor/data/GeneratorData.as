/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 27.03.13
 * Time: 20:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

public class GeneratorData {

    // TODO: обдумать, стоит ли использовать один и тот же генератор на разных волнах, или просто расписать свои параметры для каждой волны.
    // возможно, лучше задавать генератор не типом монстров, а их последовательностью
    // TODO: waves

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _type: String;
    public function get type():String {
        return _type;
    }
    public function set type($value: String):void {
        _type = $value;
    }

    private var _amount: int;
    public function get amount():int {
        return _amount;
    }
    public function set amount($value: int):void {
        _amount = $value;
    }

    private var _delay: int;
    public function get delay():int {
        return _delay;
    }
    public function set delay($value: int):void {
        _delay = $value;
    }

    private var _path: int;
    public function get path():int {
        return _path;
    }
    public function set path($value: int):void {
        _path = $value;
    }

    public function GeneratorData() {
    }

    public function place($x: int, $y: int):void {
        _x = $x;
        _y = $y;
    }

    public function parse($data: Object):void {
        _x = $data.x;
        _y = $data.y;
        _type = $data.type;
        _amount = $data.amount ? $data.amount : 10;
        _delay = $data.delay ? $data.delay : 60;
        _path = $data.path ? $data.path : 2;
    }

    public function export():Object {
        return {"x": _x, "y": _y, "type": _type, "amount": _amount, "delay": _delay, "path": _path};
    }
}
}
