/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.objectEditor.data.PartData;

import flash.geom.Point;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;

public class ObjectView extends PositionView {

    private var _partData: PartData;
    public function get partData():PartData {
        return _partData;
    }

    private var _bg: Image;

    public function ObjectView($data: PartData) {
        _partData = $data;

        super(new Point(0,0));

        if (_partData.animated) {
            _bg = new MovieClip(_partData.states["attack_01"]);
            addChild(_bg);

            Starling.juggler.add(_bg as MovieClip);
        } else {
            _bg = new Image(_partData.states[_partData.name]);
            addChild(_bg);
        }

        update();
    }

    public function update():void {
        _bg.pivotX = _bg.width/2+_partData.pivotX;
        _bg.pivotY = _bg.height/2+_partData.pivotY;
    }

    override public function destroy():void {
        super.destroy();

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
