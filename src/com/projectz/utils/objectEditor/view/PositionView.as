/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {

import flash.geom.Point;

import starling.display.Sprite;

public class PositionView extends Sprite {

    public static var cellWidth: int = 72;
    public static var cellHeight: int = 36;

    protected var _position: Point;
    public function get position():Point {
        return _position;
    }

    public function get depth():Number {
        return 0;
    }

    public function PositionView($position: Point) {
        _position = $position;

        x = (_position.y-_position.x)*cellWidth*0.5;
        y = (_position.y+_position.x)*cellHeight*0.5;

        pivotX = cellWidth/2;
        pivotY = cellHeight/2;
    }

    public function destroy():void {
    }
}
}
