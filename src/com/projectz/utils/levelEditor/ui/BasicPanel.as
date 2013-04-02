/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 03.04.13
 * Time: 0:06
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui {
import com.hogargames.display.GraphicStorage;

import flash.display.MovieClip;

public class BasicPanel extends GraphicStorage implements IPanel {

    public function BasicPanel(mc:MovieClip) {
        super (mc);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function show():void {
        visible = true;
    }

    public function hide():void {
        visible = false;
    }
}
}
