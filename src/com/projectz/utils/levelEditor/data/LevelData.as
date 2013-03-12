/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 12:31
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

public class LevelData {

    private var paths:Vector.<PathData> = new Vector.<PathData> ();//массив путей по которым перемещаются волны врагов

    public function LevelData() {

    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function export():Object {
//        return {'name': _name, 'mask': _mask, 'parts': getParts()};
    }
}
}
