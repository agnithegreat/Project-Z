/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 12.04.13
 * Time: 18:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui {

import com.projectz.app.ui.elements.BasicBar;
import com.projectz.game.model.objects.Defender;
import com.projectz.game.view.objects.DefenderView;
import com.projectz.utils.StarlingUtils;
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
        createIconByDefenderData(_defenderData);
        setText(String (_defenderData.cost));


    }

    /**
     * Создание и отображение иконки по DefenderData.
     * @param defenderData Защитник для создания иконки.
     */
    public function createIconByDefenderData (defenderData:DefenderData):void {
        if (defenderData) {
            if (defenderData is DefenderData) {
                var defender:Defender = new Defender (defenderData);
                var defenderView:DefenderView = new DefenderView (defender);
                defenderView.stay(1);
                defenderView.stopCurrentStateAnimation();
                positionIcon (defenderView);
                addIcon(defenderView);
                defenderView
            }
        }
    }

    override protected function positionIcon (icon:DisplayObject):void {
        icon.x = ICON_X;
        icon.y = ICON_Y;
    }
}
}
