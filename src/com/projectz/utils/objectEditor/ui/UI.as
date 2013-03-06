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

public class UI extends Sprite {

    private var _filesPanel: FilesPanel;
    public function get filesPanel():FilesPanel {
        return _filesPanel;
    }

    private var _save: Button;

    public function UI() {
        _filesPanel = new FilesPanel();
        _filesPanel.x = Constants.WIDTH-200;
        addChild(_filesPanel);

//        _save = new Button();
    }
}
}
