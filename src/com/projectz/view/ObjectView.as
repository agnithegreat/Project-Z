/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 04.03.13
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.view {
import com.projectz.model.FieldObject;
import com.projectz.model.Tree;

public class ObjectView extends CellView {

    protected var _object: FieldObject;

    public function ObjectView($object: FieldObject) {
        _object = $object;

        super($object.cell, _object is Tree ? "so-tree-01" : "so-testbox");

        pivotY -= int(_object.size.length*0.5)*cellHeight;
    }
}
}
