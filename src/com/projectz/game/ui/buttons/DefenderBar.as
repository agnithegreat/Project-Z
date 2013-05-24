/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 12.04.13
 * Time: 18:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {

import com.projectz.utils.objectEditor.data.DefenderData;

import starling.utils.AssetManager;

public class DefenderBar extends BasicBar {

    private var _defenderData:DefenderData;

    public function DefenderBar($assets: AssetManager) {
        super($assets);
    }

    public function get defenderData():DefenderData {
        return _defenderData;
    }

    public function set defenderData(value:DefenderData):void {
        _defenderData = value;
    }
}
}
