/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.Car;
import com.projectz.model.FieldObject;
import com.projectz.model.House;
import com.projectz.model.Tree;

public class ObjectView extends CellView {

    protected var _object: FieldObject;

    override public function get depth():Number {
        return _object.depth;
    }

    public function ObjectView($object: FieldObject) {
        _object = $object;

//        super($object.cell, _object is Tree ? "so-tree-01" : "so-testhome-uplayer");
//        super($object.cell, _object is Tree ? "so-tree-01" : "so-testbox");
        super($object.cell, _object is Tree ? "so-tree-01" : _object is House ? "so-testbox" : _object is Car ? "so-testcar" : "");
    }

    override public function destroy():void {
        super.destroy();

        _object = null;
    }
}
}
