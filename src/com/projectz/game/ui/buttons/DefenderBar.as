/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 12.04.13
 * Time: 18:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {

import com.projectz.utils.objectEditor.data.DefenderData;

import starling.display.DisplayObject;

import starling.utils.AssetManager;

public class DefenderBar extends BasicBar {

    private var _defenderData:DefenderData;

    private static const ICON_X:int = 70;
    private static const ICON_Y:int = 90;

    public function DefenderBar($assets: AssetManager) {
        super($assets);
    }

    public function get defenderData():DefenderData {
        return _defenderData;
    }

    public function set defenderData(value:DefenderData):void {
        _defenderData = value;
        createIconByObjectData(_defenderData);
        setText(String (_defenderData.cost));
    }

    override protected function placeIcon (icon:DisplayObject):void {
        icon.x = ICON_X;
        icon.y = ICON_Y;
    }
}
}
