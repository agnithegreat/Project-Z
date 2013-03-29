/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 28.03.13
 * Time: 12:07
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.model.objects {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.objectEditor.data.TargetData;

public class Building extends FieldObject implements ITarget {

    private var _targetData: TargetData;

    private var _hp: int;
    public function get hp():int {
        return _hp;
    }

    public function Building($data:PartData, $shadow:PartData, $target: TargetData) {
        super($data, $shadow);

        _targetData = $target;

        _hp = _targetData.hp;
    }

    public function damage($value: int):void {
        _hp -= $value;
        dispatchEventWith(GameEvent.DAMAGE);
        if (_hp<=0) {
            _hp = 0;
            destruct();
        }
    }

    public function destruct():void {
    }

    override public function destroy():void {
        super.destroy();

        _targetData = null;
    }
}
}
