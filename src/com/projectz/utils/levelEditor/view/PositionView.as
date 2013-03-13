/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {
import com.projectz.utils.levelEditor.event.GameEvent;

import starling.display.Sprite;

public class PositionView extends Sprite {

    public static var CELL_WIDTH: int = 72;
    public static var CELL_HEIGHT: int = 36;

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
        x = (positionY-positionX)*CELL_WIDTH*0.5;
        y = (positionY+positionX)*CELL_HEIGHT*0.5;

        pivotX = CELL_WIDTH/2;
        pivotY = CELL_HEIGHT/2;
    }

    protected function dispatchDestroy():void {
        dispatchEventWith(GameEvent.DESTROY, true);
    }

    public function destroy():void {
    }
}
}
