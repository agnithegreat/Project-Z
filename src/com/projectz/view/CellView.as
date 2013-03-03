/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Cell;

import starling.display.Shape;

import starling.display.Sprite;

public class CellView extends Sprite {

    public static var cellWidth: int = 40;
    public static var cellHeight: int = 40;

    private var _cell: Cell;

    private var _shape: Shape;

    public function CellView($cell: Cell) {
        _cell = $cell;

        x = _cell.x*cellWidth;
        y = _cell.y*cellHeight;
    }

    private function draw():void {
        _shape = new Shape();
        addChild(_shape);

        _shape.graphics.lineStyle(2, 0);
        _shape.graphics.beginFill(0x00FF00);
        _shape.graphics.drawRect(0,0,cellWidth,cellHeight);
        _shape.graphics.endFill();
//
//        _shape.pivotX = _shape.width/2;
//        _shape.pivotY = _shape.height/2;
//        _shape.rotation = Math.PI/4;
//        _shape.height *= 0.5;
    }
}
}
