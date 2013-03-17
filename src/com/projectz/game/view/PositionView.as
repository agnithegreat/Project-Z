/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.event.GameEvent;

import starling.display.Sprite;

public class PositionView extends Sprite {

    public static var cellWidth: int = 72;
    public static var cellHeight: int = 36;

    public function get positionX():Number {
        return 0;
    }
    public function get positionY():Number {
        return 0;
    }

    public function get depth():Number {
        return 0;
    }

    public function PositionView() {
        x = (positionY-positionX)*cellWidth*0.5;
        y = (positionY+positionX)*cellHeight*0.5;

        pivotX = cellWidth/2;
        pivotY = cellHeight/2;
    }

    protected function dispatchDestroy():void {
        dispatchEventWith(GameEvent.DESTROY, true);
    }

    public function destroy():void {
    }
}
}
