/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:43
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.objects {
import com.projectz.game.view.*;
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.objects.Personage;

import flash.utils.Dictionary;

import starling.core.Starling;

import starling.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;

public class PersonageView extends PositionView {

    protected var _personage: Personage;
    override public function get positionX():Number {
        return _personage.positionX;
    }
    override public function get positionY():Number {
        return _personage.positionY;
    }

    override public function get depth():Number {
        return _personage.cell.depth;
    }

    protected var _currentState: MovieClip;
    protected var _states: Dictionary;

    override public function get animated():Boolean {
        return true;
    }

    public function PersonageView($personage: Personage) {
        _personage = $personage;
        _personage.addEventListener(GameEvent.UPDATE, handleUpdate);

        _states = new Dictionary();

        super();
    }

    public function addState($id: String, $textures: Vector.<Texture>, $fps: int = 12, $loop: Boolean = true):void {
        if ($textures && $textures.length>0) {
            var state: MovieClip = new MovieClip($textures, $fps);
            state.loop = $loop;
            state.pivotX = _personage.data.pivotX;
            state.pivotY = _personage.data.pivotY;
            _states[$id] = state;
        }
    }

    public function setState($id: String):void {
        var frame: int = 0;
        if (_currentState) {
            _currentState.removeEventListeners();
            frame = _currentState.currentFrame;
            Starling.juggler.remove(_currentState);
            _currentState.stop();
            removeChild(_currentState);
            _currentState = null;
        }

        _currentState = _states[$id];
        _currentState.currentFrame = frame%_currentState.numFrames;
        addChild(_currentState);
        _currentState.play();
        Starling.juggler.add(_currentState);
    }

    private function handleUpdate($event: Event):void {
        x = (positionY-positionX)*cellWidth*0.5;
        y = (positionY+positionX)*cellHeight*0.5;
    }

    override public function destroy():void {
        super.destroy();

        _personage.removeEventListeners();
        _personage = null;

        if (_currentState) {
            Starling.juggler.remove(_currentState);
            _currentState.removeFromParent();
        }
        _currentState = null;

        var state: MovieClip;
        for (var id: String in _states) {
            state = _states[id];
            state.dispose();
            delete _states[id];
        }
        _states = null;
    }
}
}
