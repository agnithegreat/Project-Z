/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.04.13
 * Time: 8:24
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.ui.buttons {
import starling.display.Button;
import starling.textures.Texture;

public class ButtonBase extends Button {


    public function ButtonBase(upState:Texture, text:String = "", downState:Texture = null) {
        super(upState, text, downState);
    }
}
}
