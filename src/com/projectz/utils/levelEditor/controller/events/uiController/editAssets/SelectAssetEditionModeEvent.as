/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 16.05.13
 * Time: 15:34
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editAssets {

import starling.events.Event;

/**
 * Событие выбора режима редактирования ассетов.
 */
public class SelectAssetEditionModeEvent extends Event {

    /**
     * Выбор режима редактирования ассетов.
     */
    public static const SELECT_ASSET_EDITING_MODE:String = "select asset editing mode";

    public function SelectAssetEditionModeEvent(type:String = SELECT_ASSET_EDITING_MODE, bubbles:Boolean = false, data:Object = null) {
        super (type, bubbles, data);
    }
}
}