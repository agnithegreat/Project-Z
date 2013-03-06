/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.view {
import com.projectz.utils.objectEditor.model.FieldObject;

public class ShadowView extends CellView {

    protected var _object: FieldObject;

    public function ShadowView($object: FieldObject) {
        _object = $object;

        // TODO: shadow вместо name
        super(_object.cell, _object.name);
    }

    override public function destroy():void {
        super.destroy();

        _object = null;
    }
}
}
