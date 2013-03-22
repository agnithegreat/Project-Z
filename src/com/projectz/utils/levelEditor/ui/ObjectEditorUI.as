/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectModeEvent;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class ObjectEditorUI extends Sprite {

    private var uiController:UIController;

    private var _filesPanel:FilesPanel;
    public function get filesPanel():FilesPanel {
        return _filesPanel;
    }

    private var _save:Button;

    private var _export:Button;

    public function ObjectEditorUI($assets:AssetManager, uiController:UIController) {
        this.uiController = uiController;
        uiController.addEventListener(SelectModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        _filesPanel = new FilesPanel(uiController);
        _filesPanel.x = Constants.WIDTH + 200;
        addChild(_filesPanel);

        _save = new Button($assets.getTexture("Save"));
        _save.x = (Constants.WIDTH - _save.width) * 0.5;
        _save.y = 10;
        addChild(_save);
        _save.addEventListener(Event.TRIGGERED, handleClick);

        _export = new Button($assets.getTexture("Save"));
        _export.x = Constants.WIDTH - _export.width * 2;
        _export.y = Constants.HEIGHT - _export.height * 2;
        addChild(_export);
        _export.addEventListener(Event.TRIGGERED, handleClick);
    }

    private function handleClick($event:Event):void {
        switch ($event.currentTarget) {
            case _save:
                uiController.save();
                break;
            case _export:
                uiController.export();
                break;
        }
    }

    private function selectUIControllerModeListener(event:SelectModeEvent):void {
        _filesPanel.visible = (event.mode == UIControllerMode.EDIT_OBJECTS);
    }
}
}
