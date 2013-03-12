/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 06.03.13
 * Time: 20:50
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.ui {
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class UI extends Sprite {

    public static const ADD_X: String = "add_x_UI";
    public static const SUB_X: String = "sub_x_UI";
    public static const ADD_Y: String = "add_y_UI";
    public static const SUB_Y: String = "sub_y_UI";
    public static const SAVE: String = "save_UI";

    private var _filesPanel: FilesPanel;
    public function get filesPanel():FilesPanel {
        return _filesPanel;
    }

    private var _partsPanel: PartsPanel;
    public function get partsPanel():PartsPanel {
        return _partsPanel;
    }

    private var _save: Button;

    private var _addX: Button;
    private var _subX: Button;

    private var _addY: Button;
    private var _subY: Button;

    public function UI($assets: AssetManager) {
        _filesPanel = new FilesPanel();
        _filesPanel.x = Constants.WIDTH-200;
        addChild(_filesPanel);

        _partsPanel = new PartsPanel();
        _partsPanel.x = Constants.WIDTH-400;
        _partsPanel.y = Constants.HEIGHT-150;
        addChild(_partsPanel);

        _addX = new Button($assets.getTexture("Plus"));
        _addX.x = Constants.WIDTH-200-_addX.width-10;
        _addX.y = 10;
        addChild(_addX);
        _addX.addEventListener(Event.TRIGGERED, handleClick);

        _subX = new Button($assets.getTexture("Minus"));
        _subX.x = Constants.WIDTH-200-_addX.width-_subX.width-20;
        _subX.y = 10;
        addChild(_subX);
        _subX.addEventListener(Event.TRIGGERED, handleClick);

        _addY = new Button($assets.getTexture("Plus"));
        _addY.x = 10;
        _addY.y = 10;
        addChild(_addY);
        _addY.addEventListener(Event.TRIGGERED, handleClick);

        _subY = new Button($assets.getTexture("Minus"));
        _subY.x = 20+_addY.width;
        _subY.y = 10;
        addChild(_subY);
        _subY.addEventListener(Event.TRIGGERED, handleClick);

        _save = new Button($assets.getTexture("Save"));
        _save.x = (Constants.WIDTH-200-_save.width)*0.5;
        _save.y = 10;
        addChild(_save);
        _save.addEventListener(Event.TRIGGERED, handleClick);
    }

    private function handleClick($event: Event):void {
        switch ($event.currentTarget) {
            case _addX:
                dispatchEventWith(ADD_X);
                break;
            case _subX:
                dispatchEventWith(SUB_X);
                break;
            case _addY:
                dispatchEventWith(ADD_Y);
                break;
            case _subY:
                dispatchEventWith(SUB_Y);
                break;
            case _save:
                dispatchEventWith(SAVE);
                break;
        }
    }
}
}
