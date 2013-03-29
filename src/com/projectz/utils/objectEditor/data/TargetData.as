/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 28.03.13
 * Time: 11:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.filesystem.File;

public class TargetData extends ObjectData {

    // Количество жизней.
    private var _hp: int;
    public function get hp():int {
        return _hp;
    }

    public function TargetData($name:String, $config:File = null) {
        super($name, $config);
    }

    override public function parse($data: Object):void {
        super.parse($data);

        _hp = $data.hp ? $data.hp : 100;
    }

    override public function export():Object {
        var obj: Object = super.export();
        obj.hp = _hp;
        return obj;
    }
}
}
