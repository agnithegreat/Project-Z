/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 02.03.13
 * Time: 19:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz {
import com.projectz.model.Game;
import com.projectz.utils.objectEditor.ObjectParser;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.view.GameScreen;

import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
import starling.utils.formatString;

public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objects: Dictionary;

    private var _game: Game;
    private var _view: GameScreen;
//    private var _ui: UI;

    public function App() {
        _objects = new Dictionary();
    }

    public function start($assets: AssetManager):void {
        _assets = $assets;
        _assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        if (ratio == 1) {
            Starling.juggler.delayCall(initStart, 0.15);

            stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        }
    }

    private function initStart():void {
        var folder: File = File.applicationDirectory.resolvePath(formatString("textures/{0}x/level_elements/anim_object", _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), true);

        folder = File.applicationDirectory.resolvePath(formatString("textures/{0}x/level_elements/defenders", _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), true);

        folder = File.applicationDirectory.resolvePath(formatString("textures/{0}x/level_elements/enemies", _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), true);

        folder = File.applicationDirectory.resolvePath(formatString("textures/{0}x/level_elements/static_objects", _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), false);

        trace(_assets.getTextureNames());

        Starling.juggler.delayCall(startGame, 0.15);
    }

    private function parseObjects($objects: Dictionary, $animated: Boolean):void {
        var name: String;
        var obj: ObjectData;
        var part: PartData;
        for (name in $objects) {
            obj = $objects[name] as ObjectData;
            for each (part in obj.parts) {
                if ($animated) {
                    part.addTextures(_assets.getTextures(name+"_"+part.name));
                } else {
                    part.addTextures(_assets.getTexture(part.name ? name+"_"+part.name : name));
                }
            }
            _objects[name] = obj;
        }
    }

    private function startGame():void {
        _game = new Game(_objects);
        _game.init();

        _view = new GameScreen(_game, _assets);
        addChild(_view);
    }

    private function endGame():void {
        _view.destroy();
        _view.removeFromParent(true);
        _view = null;

        _game.destroy();
        _game = null;
    }

    private function handleTouch($event: TouchEvent):void {
        if ($event.getTouch(stage, TouchPhase.ENDED)) {
            if (_game) {
                endGame();
                startGame();
            }
        }
    }
}
}
