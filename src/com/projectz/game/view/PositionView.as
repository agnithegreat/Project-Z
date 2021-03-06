/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.event.GameEvent;
import com.projectz.game.model.Cell;

import starling.display.Image;

import starling.display.Sprite;

public class PositionView extends Sprite {

    public static var cellWidth: int = 36;
    public static var cellHeight: int = 18;

    protected var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }
    public function get positionX():Number {
        return _cell.x;
    }
    public function get positionY():Number {
        return _cell.y;
    }

    protected var _bg: Image;

    public function get depth():Number {
        return _cell.depth;
    }

    public function get animated():Boolean {
        return false;
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
