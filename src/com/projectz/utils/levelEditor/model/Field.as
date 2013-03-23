/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditBackgroundEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditPlaceEvent;
import com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.levelEditor.data.PlaceData;

import flash.geom.Point;

import starling.events.Event;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    private var _width: int;
    private var _height: int;

    private var _objectsStorage: ObjectsStorage;

    private var _fieldAsObj: Object;//представление поля клеток Cell в виде объекта. Ключом для получения служит строка с координатами клетки вида x_y
    private var _field: Vector.<Cell>;

    private var _levelData: LevelData;

    private var _objects: Vector.<FieldObject>;

    public function Field($width: int, $height: int, $objectsStorage: ObjectsStorage) {
        _width = $width;
        _height = $height;

        _objectsStorage = $objectsStorage;
        _objects = new <FieldObject>[];

        createField();

    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /////////////////////////////////////////////
    //GET & SET:
    /////////////////////////////////////////////

    public function get width():int {
        return _width;
    }

    public function get height():int {
        return _height;
    }

    public function set levelData(value:LevelData):void {
        _levelData = value;
        if (_levelData) {
            createObjects(_levelData.objects);
            changeBackground(_levelData.bg);
        }
    }

    public function get levelData():LevelData {
        return _levelData;
    }

    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    public function get field():Vector.<Cell> {
        return _field;
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    public function addObject($placeData: PlaceData):void {
        // TODO: implement check addObjectTest

        if (_levelData) {
            _levelData.addObject($placeData);
            createObject($placeData.x, $placeData.y, $placeData.realObject, $placeData);
            updateDepths();
            dispatchEventWith(GameEvent.UPDATE);
        }
    }

    public function selectObject($x: int,  $y: int):void {
        if (_levelData) {
            var object: PlaceData;

            var len: int = _levelData.objects.length;
            for (var i:int = 0; i < len; i++) {
                object = _levelData.objects[i];
                if (object.hitTest($x, $y)) {
                    break;
                } else {
                    object = null;
                }
            }

            if (object) {
                removeObject(object);
                dispatchEvent(new EditPlaceEvent (_objectsStorage.getObjectData(object.object), EditPlaceEvent.PLACE_ADDED));
            }
        }
    }

    public function changeBackground (backgroundId:String):void {
        if (_levelData) {
            _levelData.bg = backgroundId;
            if (backgroundId) {
                var objectData:ObjectData = _objectsStorage.getObjectData (backgroundId);
                dispatchEvent(new EditBackgroundEvent(objectData));
            }
        }
    }

    public function removeAllObject():void {
        if (_levelData) {
            var placeData: PlaceData;
            var len: int = _levelData.objects.length;
            while (_levelData.objects.length > 0) {
                placeData = _levelData.objects[0];
                removeObject(placeData);
            }
        }
    }

    /////////////////////////////////////////////
    //PATH:
    /////////////////////////////////////////////

    public function addPointToPath (point:Point, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                var hasThisPoint:Boolean = false;
                var numPoints:int = pathData.points.length;
                for (var i:int = 0; i < numPoints; i++) {
                    hasThisPoint = pathData.points [i].equals(point);
                    if (hasThisPoint) {
                        break;
                    }
                }
                if (!hasThisPoint) {
                    pathData.points.push(point);
                    dispatchEvent(new EditPathEvent (pathData));
                }
            }
        }
    }

    public function removePointFromPath (point:Point, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                var hasThisPoint:Boolean = true;
                var numPoints:int = pathData.points.length;
                for (var i:int = 0; i < numPoints; i++) {
                    hasThisPoint = pathData.points [i].equals(point);
                    if (hasThisPoint) {
                        break;
                    }
                }
                if (hasThisPoint) {
                    pathData.points.splice(i, 1);
                    dispatchEvent(new EditPathEvent (pathData));
                }
            }
        }
    }

    public function selectPathTarget (point:Point, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                var hasThisPoint:Boolean = false;
                var numPoints:int = pathData.points.length;
                for (var i:int = 0; i < numPoints; i++) {
                    hasThisPoint = pathData.points [i].equals(point);
                    if (hasThisPoint) {
                        break;
                    }
                }
                if (hasThisPoint) {
                    var _targetPoint:Point = pathData.points [i];
                    pathData.points.splice(i, 1);
                    pathData.points.push(_targetPoint);
                    dispatchEvent(new EditPathEvent (pathData));
                }
            }
        }
    }

    public function setPathColor (color:uint, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                pathData.color = color;
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.COLOR_WAS_CHANGED));
            }
        }
    }

    public function addNewPath ():void {
        if (_levelData) {
            var pathData:PathData = new PathData();
            var maxId:int = 0;
            var numPaths:int = _levelData.paths.length;
            for (var i:int = 0; i < numPaths; i++) {
                maxId = Math.max (maxId, _levelData.paths [i].id);
                trace("maxId = " + maxId);
            }
            pathData.id = maxId + 1;
            _levelData.paths.push (pathData);
            dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_ADDED));
        }
    }

    public function deletePath (pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                _levelData.paths.splice(index, 1);
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_REMOVED));
            }
        }
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    public function save ():void {
        levelData.save(levelData.export());
    }

    public function export ():void {
        //
    }

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;

        for (var id: String in _fieldAsObj) {
            delete _fieldAsObj[id];
        }
        _fieldAsObj = null;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function updateDepths():void {
        var toCheck: Vector.<Cell> = new <Cell>[];

        var object: FieldObject;
        var cell: Cell;
        var len: int = _field.length;
        for (var i:int = 0; i < len; i++) {
            _field[i].depth = 0;
            toCheck.push(_field[i]);
        }

        var index: int = 0;
        var tries: int = 100;
        var checkedObjects: Array = [];
        while (len && tries-->0) {
            for (i = 0; i < len; i++) {
                cell = toCheck[i];
                if (checkUpperCells(cell)) {
                    object = cell.object;
                    if (object && object.data.width>1 && object.data.height>1) {
                        object.markSize(cell.x, cell.y);
                        checkedObjects.push(object);
                        if (object.sizeChecked) {
                            setObjectDepth(object, ++index);
                        }
                    } else {
                        cell.depth = ++index;
                    }
                }
            }
            while (checkedObjects.length>0) {
                checkedObjects.pop().clearSize();
            }
            for (var k: int = 0; k < len; k++) {
                if (toCheck[k].depth) {
                    toCheck.splice(k--, 1);
                    len--;
                }
            }
        }
    }

    private function setObjectDepth($object: FieldObject, $depth: int):void {
        for (var i:int = 0; i < $object.data.width; i++) {
            for (var j:int = 0; j < $object.data.height; j++) {
                if ($object.data.mask[i][j]) {
                    var cell: Cell = getCell($object.cell.x+i-$object.data.top.x, $object.cell.y+j-$object.data.top.y);
                    cell.depth = $depth;
                }
            }
        }
    }

    private function checkUpperCells($cell: Cell):Boolean {
        return checkUpperCell( getCell($cell.x, $cell.y-1), $cell.object ) &&
               checkUpperCell( getCell($cell.x-1, $cell.y), $cell.object );
    }

    private function checkUpperCell($cell: Cell, $object: FieldObject):Boolean {
        return !$cell || $cell.depth || ($cell.object && $cell.object==$object);
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldAsObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                if (i+j>0.4*_width && i+j<1.6*_width && Math.abs(i-j)<0.4*_height) {
                    cell = new Cell(i, j);
                    _field.push(cell);
                    _fieldAsObj[i+"."+j] = cell;
                }
            }
        }
        _field.sort(sortField);
    }

    private function sortField($cell1: Cell, $cell2: Cell):int {
        if ($cell1.sorter>$cell2.sorter) {
            return 1;
        } else if ($cell1.sorter<$cell2.sorter) {
            return -1;
        }
        if ($cell1.y>$cell2.y) {
            return 1;
        } else if ($cell1.y<$cell2.y) {
            return -1;
        }
        return 0;
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldAsObj[x+"."+y];
    }

    private function removeObject($object: PlaceData):void {
        if (_levelData) {
            _levelData.removeObject($object);
            var len: int = _objects.length;
            for (var i:int = 0; i < len; i++) {
                var obj: FieldObject = _objects[i];
                if (obj.placeData == $object) {
                    removePart(obj.placeData.x, obj.placeData.y, obj);

                    _objects.splice(i--, 1);
                    len--;
                    dispatchEvent(new EditObjectEvent(obj, EditObjectEvent.OBJECT_REMOVED));
                }
            }
        }
    }

    private function removePart($x: int, $y: int, $object: FieldObject):void {
        var cell: Cell;
        for (var i:int = 0; i < $object.data.mask.length; i++) {
            for (var j:int = 0; j < $object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    cell.unlock();
                    if ($object.data.mask[i][j]==1) {
                        cell.removeObject($object);
                    }
                }
            }
        }
    }

    private function createObjects($objects: Vector.<PlaceData>):void {
        var len: int = $objects.length;
        for (var i: int = 0; i < len; i++) {
            var obj: PlaceData = $objects[i];
            obj.realObject = _objectsStorage.getObjectData(obj.object);
            createObject(obj.x, obj.y, obj.realObject, obj);
        }
        updateDepths();
        dispatchEventWith(GameEvent.UPDATE);
    }

    private function createObject($x: int, $y: int, $data: ObjectData, $placeData: PlaceData):void {
        for each (var part: PartData in $data.parts) {
            if (part.name!="shadow") {
                createPart($x, $y, part, $placeData);
            } else {
                createShadow($x, $y, part, $placeData);
            }
        }
    }

    private function createPart($x: int, $y: int, $data: PartData, $placeData: PlaceData):void {
        var object: FieldObject = new FieldObject($data, $placeData);

        var cell: Cell;
        for (var i:int = 0; i < object.data.mask.length; i++) {
            for (var j:int = 0; j < object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    cell.lock();
                    if (object.data.mask[i][j]==1) {
                        cell.addObject(object);
                    }
                }
            }
        }
        if (cell) {
            object.place(getCell($x+object.data.top.x, $y+object.data.top.y));
            _objects.push(object);

            dispatchEvent(new EditObjectEvent (object, EditObjectEvent.OBJECT_ADDED));
        }
    }

    private function createShadow($x: int, $y: int, $data: PartData, $placeData: PlaceData):void {
        var shadow: FieldObject = new FieldObject($data, $placeData);
        var cell: Cell = getCell($x, $y);
        cell.shadow = shadow;
        shadow.place(cell);

        dispatchEvent(new EditObjectEvent(shadow, EditObjectEvent.SHADOW_ADDED));
    }

}
}
