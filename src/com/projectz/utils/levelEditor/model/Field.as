/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.events.LevelEditorEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectsStorage;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.pathFinding.Grid;
import com.projectz.utils.pathFinding.Path;
import com.projectz.utils.pathFinding.PathFinder;

import starling.events.Event;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    private var controller:LevelEditorController;

    private var _width: int;
    public function get width():int {
        return _width;
    }

    private var _height: int;
    public function get height():int {
        return _height;
    }

    private var _objectsStorage: ObjectsStorage;

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _grid: Grid;

    private var _level: LevelData;
    public function get level():LevelData {
        return _level;
    }

    private var _objects: Vector.<FieldObject>;
    public function get objects():Vector.<FieldObject> {
        return _objects;
    }

    public function Field($width: int, $height: int, $objectsStorage: ObjectsStorage, $level: LevelData, $controller:LevelEditorController) {
        controller = $controller;
        _width = $width;
        _height = $height;

        _grid = new Grid(_width, _height);

        _objectsStorage = $objectsStorage;
        _objects = new <FieldObject>[];

        _level = $level;
        createField();

        controller.addEventListener (LevelEditorEvent.SAVE, saveListener);
        controller.addEventListener (LevelEditorEvent.REMOVE_ALL_OBJECTS, removeAllObjectListener);
    }

    public function init():void {
        createObjects(_level.objects);
    }

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
        var mark: Array;
        var tries: int = 100;
        while (len && tries-->0) {
            for (i = 0; i < len; i++) {
                cell = toCheck[i];
                if (cell && checkUpperCells(cell)) {
                    mark = [];
                    object = cell.object;
                    if (object && object.data.width>1 && object.data.height>1) {
                        object.markSize(cell.x, cell.y);
                        if (object.sizeChecked) {
                            mark = mark.concat(getObjectCells(object));
                        }
                    } else {
                        mark.push(cell);
                    }
                    var markLen: int = mark.length;
                    for (var k: int = 0; k < markLen; k++) {
                        mark[k].depth = ++index;
                    }
                }
            }
            for (k = 0; k < len; k++) {
                if (toCheck[k].depth) {
                    toCheck.splice(k--, 1);
                    len--;
                }
            }
        }
    }

    private function getObjectCells($object: FieldObject):Array {
        var cells: Array = [];
        for (var i:int = 0; i < $object.data.width; i++) {
            for (var j:int = 0; j < $object.data.height; j++) {
                if ($object.data.mask[i][j]) {
                    cells.push(getCell($object.cell.x+i-$object.data.top.x, $object.cell.y+j-$object.data.top.y));
                }
            }
        }
        return cells;
    }

    private function checkUpperCells($cell: Cell):Boolean {
        var object: FieldObject = $cell.object;
        var cell: Cell = getCell($cell.x, $cell.y-1);
        if (cell && !cell.depth && (!cell.object || cell.object!=object)) {
            return false;
        }
        cell = getCell($cell.x-1, $cell.y);
        if (cell && !cell.depth && (!cell.object || cell.object!=object)) {
            return false;
        }
        return true;
    }

    private function getWay($start: Cell, $end: Cell):Vector.<Cell> {
        var way: Vector.<Cell> = new <Cell>[];
        _grid.setStartNode($start.x, $start.y);
        _grid.setEndNode($end.x, $end.y);
        var path: Path = PathFinder.findPath(_grid);
        var len: int = path.path.length;
        for (var i:int = 1; i < len; i++) {
            way.push(getCell(path.path[i].x, path.path[i].y));
        }
        return way;
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                if (i+j>0.4*_width && i+j<1.6*_width && Math.abs(i-j)<0.4*_height) {
                    cell = new Cell(i, j);
                    _field.push(cell);
                    _fieldObj[i+"."+j] = cell;
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
        return 0;
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    public function addObject($placeData: PlaceData):void {
        // TODO: implement check addObjectTest

        _level.addObject($placeData);
        createObject($placeData.x, $placeData.y, $placeData.realObject, $placeData);
        updateDepths();
        dispatchEventWith(GameEvent.UPDATE);
    }

    public function selectObject($x: int,  $y: int):void {
        var object: PlaceData;

        var len: int = _level.objects.length;
        for (var i:int = 0; i < len; i++) {
            object = _level.objects[i];
            if (object.hitTest($x, $y)) {
                break;
            } else {
                object = null;
            }
        }

        if (object) {
            removeObject(object);
            dispatchEventWith(LevelEditorEvent.PLACE_ADDED, false, _objectsStorage.getObjectData(object.object));
        }
    }

    private function removeObject($object: PlaceData):void {
        _level.removeObject($object);
        var len: int = _objects.length;
        for (var i:int = 0; i < len; i++) {
            var obj: FieldObject = _objects[i];
            if (obj.placeData == $object) {
                _objects.splice(i--, 1);
                len--;
                dispatchEventWith(LevelEditorEvent.OBJECT_REMOVED, false, obj);
            }
        }
    }

    private function removeAllObject():void {
        _level.removeAllObject();
        _objects = new <FieldObject>[];
        dispatchEventWith(LevelEditorEvent.ALL_OBJECTS_REMOVED, false);
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
                        _grid.setWalkable(cell.x, cell.y, false);
                        cell.addObject(object);
                    }
                }
            }
        }
        object.place(getCell($x+object.data.top.x, $y+object.data.top.y));
        _objects.push(object);

        dispatchEventWith(LevelEditorEvent.OBJECT_ADDED, false, object);
    }

    private function createShadow($x: int, $y: int, $data: PartData, $placeData: PlaceData):void {
        var shadow: FieldObject = new FieldObject($data, $placeData);
        var cell: Cell = getCell($x, $y);
        cell.shadow = shadow;
        shadow.place(cell);

        dispatchEventWith(LevelEditorEvent.SHADOW_ADDED, false, shadow);
    }

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;

        for (var id: String in _fieldObj) {
            delete _fieldObj[id];
        }
        _fieldObj = null;

        _grid.destroy();
        _grid = null;
    }

    private function saveListener (event:Event):void {
        level.save(level.export());
    }

    private function removeAllObjectListener (event:Event):void {
        removeAllObject();
    }
}
}
