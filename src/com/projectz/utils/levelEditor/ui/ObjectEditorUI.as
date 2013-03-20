/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class ObjectEditorUI extends Sprite {

    public static const SAVE: String = "save_UI";
    public static const EXPORT: String = "export_UI";

    private var _filesPanel: FilesPanel;
    public function get filesPanel():FilesPanel {
        return _filesPanel;
    }

    private var _save: Button;

    private var _export: Button;

    public function ObjectEditorUI($assets: AssetManager) {
        _filesPanel = new FilesPanel();
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
                dispatchEventWith(SAVE);
                break;
            case _export:
                dispatchEventWith(EXPORT);
                break;
        }
    }
}
}
