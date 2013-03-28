/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.view {
import com.projectz.game.model.Cell;
import com.projectz.game.event.GameEvent;

import starling.events.Event;
import starling.display.Image;
import starling.textures.Texture;

public class CellView extends PositionView {

    public function CellView($cell: Cell, $texture: Texture) {
        _cell = $cell;
        _cell.addEventListener(GameEvent.CELL_POS, handleUpdate);

        _cell = $cell;

        super();

        if ($texture) {
            setView($texture);
        }

        handleUpdate(null);
    }

    private function handleUpdate($event: Event):void {
        visible = Boolean(_cell.positionData);
    }

    protected function setView($texture: Texture):void {
        _bg = new Image($texture);
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        addChild(_bg);
    }

    override public function destroy():void {
        super.destroy();

        _cell = null;

        if (_bg) {
            _bg.removeFromParent(true);
        }
        _bg = null;
    }
}
}
