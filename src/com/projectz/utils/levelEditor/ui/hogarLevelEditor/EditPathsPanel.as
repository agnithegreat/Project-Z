/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 19:16
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.hogarLevelEditor {
import com.hogargames.display.GraphicStorage;

import flash.display.MovieClip;

public class EditPathsPanel extends GraphicStorage implements IPanel {

    public function EditPathsPanel(mc:MovieClip) {
        super (mc);
    }

    public function show():void {
        visible = true;
    }

    public function hide():void {
        visible = false;
    }
}
}
