/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model {
import com.projectz.utils.data.ObjectsStorage;

import starling.core.Starling;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    private var _objectsStorage: ObjectsStorage;

    private var _field: Field;
    public function get field():Field {
        return _field;
    }

    private var _active: Boolean;

    public function Game($objectsStorage: ObjectsStorage) {
        _objectsStorage = $objectsStorage;

        _field = new Field(36, 36, _objectsStorage);
    }

    public function init():void {
        _field.init();

        start();
    }

    public function start():void {
        _active = true;
        handleTimer();
    }

    public function stop():void {
        _active = false;
    }

    private function handleTimer():void {
        if (_field && _active) {
            _field.step(0.02);

            Starling.juggler.delayCall(handleTimer, 1/60);
        }
    }

    public function destroy():void {
        _active = false;

        _field.destroy();
        _field = null;
    }
}
}
