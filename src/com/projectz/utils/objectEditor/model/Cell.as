/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.model {
import starling.events.EventDispatcher;

public class Cell extends EventDispatcher {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    public function Cell($x: int, $y: int) {
        _x = $x;
        _y = $y;
    }

    public function destroy():void {
    }
}
}
