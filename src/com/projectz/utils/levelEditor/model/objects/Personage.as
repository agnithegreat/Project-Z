/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 11:45
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model.objects {
import com.projectz.utils.levelEditor.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;

import flash.geom.Point;

public class Personage extends FieldObject {

    protected var _target: Cell;
    public function get target():Cell {
        return _target;
    }

    public function get dirX():int {
        return _target ? _target.x-_cell.x : 0;
    }
    public function get dirY():int {
        return _target ? _target.y-_cell.y : 0;
    }

    public function get direction():int {
        var angle: Number = Math.atan2(dirY, dirX);
        return _target ? angle/(Math.PI/4)-1 : 0;
    }

    public function get distance():Number {
        return _target ? Point.distance(new Point(_target.x, _target.y), new Point(_cell.x, _cell.y)) : 0;
    }

    protected var _alive: Boolean;
    public function get alive():Boolean {
        return _alive;
    }

    public function Personage($data: PartData) {
        super($data);

        _alive = true;
    }

    override public function destroy():void {
        super.destroy();

        _target = null;
    }
}
}
