/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
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
        return y+x*0.1;
//        return Math.sqrt(positionX*positionX+positionY*positionY);
    }

    public function PositionView() {
        x = (positionY-positionX)*cellWidth*0.5;
        y = (positionY+positionX)*cellHeight*0.5;

        pivotX = cellWidth/2;
        pivotY = cellHeight/2;
    }

    public function destroy():void {
        dispatchEventWith(GameEvent.DESTROY);
    }
}
}
