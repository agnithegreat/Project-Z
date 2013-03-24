/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 14.03.13
 * Time: 21:19
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.model.Cell;
import com.projectz.utils.objectEditor.data.PartData;

public class Defender extends Personage {

    public static const FIGHT: String = "fight";
    public static const ATTACK: String = "attack";
    public static const RELOAD: String = "reload";
    public static const STATIC: String = "static";

    public function Defender($data:PartData, $shadow: PartData) {
        super($data, $shadow);
    }

    public function fight():void {
        _state = FIGHT;
        dispatchEventWith(_state);
    }

    public function attack($cell: Cell):void {
        _state = ATTACK;
        dispatchEventWith(_state);
    }

    public function reload($cell: Cell):void {
        _state = RELOAD;
        dispatchEventWith(_state);
    }

    public function stay($cell: Cell):void {
        _state = STATIC;
        dispatchEventWith(_state);
    }
}
}
