/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    public function Game() {
    }

    public function init():void {
        _field = new Field(10, 10);
        _field.init();
    }

    public function destroy():void {
        _field.destroy();
        _field = null;
    }
}
}
