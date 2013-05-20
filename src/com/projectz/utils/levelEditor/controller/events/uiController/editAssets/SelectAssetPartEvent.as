/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.05.13
 * Time: 12:54
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.controller.events.uiController.editAssets {

import com.projectz.utils.objectEditor.data.PartData;

import starling.events.Event;

/**
 * Событие выбора части ассета для редактирования.
 */
public class SelectAssetPartEvent extends Event {

    private var _partData:PartData;

    /**
     * Выбор части ассета для редактирования.
     */
    public static const SELECT_ASSET_PART:String = "select asset part";

    public function SelectAssetPartEvent(partData:PartData, type:String = SELECT_ASSET_PART, bubbles:Boolean = false) {
        this.partData = partData;
        super (type, bubbles, partData);
    }

    /**
     * Часть ассета для редактирования.
     */
    public function get partData():PartData {
        return _partData;
    }

    public function set partData(value:PartData):void {
        _partData = value;
    }
}
}
