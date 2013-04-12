/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 27.03.13
 * Time: 12:13
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view.effects {
import com.projectz.game.view.PositionView;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.textures.Texture;

public class Effect extends PositionView {

    public static const BLOOD: String = "die";
    public static const DIE: String = "blood";

    private var _clip: MovieClip;

    private var _x: Number;
    override public function get positionX():Number {
        return _x;
    }
    private var _y: Number;
    override public function get positionY():Number {
        return _y;
    }

    public function Effect($x: Number, $y: Number, $textures: Vector.<Texture>) {
        _x = $x;
        _y = $y;

        super();

        _clip = new MovieClip($textures);
        _clip.loop = false;
        _clip.pivotX = _clip.width/2;
        _clip.pivotY = _clip.height/2;
        addChild(_clip);

        Starling.juggler.add(_clip);
    }

    public function hide($delay: Number, $time: Number):void {
        Starling.juggler.delayCall(tween, $delay, $time);
    }

    private function tween($time: Number):void {
        Starling.juggler.tween(this, $time, {
            alpha: 0,
            onComplete: dispatchDestroy
        });
    }

    override public function destroy():void {
        _clip.removeFromParent(true);
        _clip = null;
    }
}
}
