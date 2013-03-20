/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.controller.LevelEditorMode;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class ObjectEditorUI extends Sprite {

    private var controller: LevelEditorController;

    private var _filesPanel: FilesPanel;
    public function get filesPanel():FilesPanel {
        return _filesPanel;
    }

    private var _save: Button;

    private var _export: Button;

    public function ObjectEditorUI($assets: AssetManager, $controller: LevelEditorController) {
        controller = $controller;
        controller.addEventListener(LevelEditorEvent.SELECT_EDITOR_MODE, selectEditorModeListener);
        _filesPanel = new FilesPanel($controller);
        _filesPanel.x = Constants.WIDTH;
        addChild(_filesPanel);

        _save = new Button($assets.getTexture("Save"));
        _save.x = (Constants.WIDTH-_save.width)*0.5;
        _save.y = 10;
        addChild(_save);
        _save.addEventListener(Event.TRIGGERED, handleClick);

        _export = new Button($assets.getTexture("Save"));
        _export.x = Constants.WIDTH-_export.width*2;
        _export.y = Constants.HEIGHT-_export.height*2;
        addChild(_export);
        _export.addEventListener(Event.TRIGGERED, handleClick);
    }

    private function handleClick($event: Event):void {
        switch ($event.currentTarget) {
            case _save:
                controller.save();
                break;
            case _export:
                controller.export();
                break;
        }
    }

    private function selectEditorModeListener (event:Event):void {
        visible = (controller.mode == LevelEditorMode.EDIT_OBJECTS);
    }
}
}
