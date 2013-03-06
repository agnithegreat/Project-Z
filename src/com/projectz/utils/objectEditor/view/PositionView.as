/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {

import starling.display.Sprite;

public class PositionView extends Sprite {

    public static var cellWidth: int = 72;
    public static var cellHeight: int = 36;

    public function get depth():Number {
        return 0;
    }

    public function PositionView() {
        pivotX = cellWidth/2;
        pivotY = cellHeight/2;
    }

    public function destroy():void {
    }
}
}
