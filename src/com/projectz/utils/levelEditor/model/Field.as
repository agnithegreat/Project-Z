/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.model {
import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.data.DataUtils;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.GeneratorWaveData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.data.WaveData;
import com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderZonesEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditGeneratorWaveEvent;
import com.projectz.utils.levelEditor.model.events.editGenerators.EditWavesEvent;
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

    public function addObject($placeData: PlaceData):Boolean {
        if (!checkObject($placeData.x, $placeData.y, $placeData.realObject)) {
            return false;
        }
        if (_levelData) {
            _levelData.addObject($placeData);
            createObject($placeData.x, $placeData.y, $placeData.realObject, $placeData);
            updateDepths();
            dispatchEventWith(GameEvent.UPDATE);
        }
        return true;
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
    //PATHS:
    /////////////////////////////////////////////

    public function addPointsToPath (points:Vector.<Point>, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                for (var i:int = 0; i < points.length; i++) {
                    var point:Point = points [i];
                    var pointAsString:String = DataUtils.pointToStringData(point);
                    if (pathData.points.indexOf(pointAsString) == -1) {
                        pathData.points.push(pointAsString);
                    }
                }
                dispatchEvent(new EditPathEvent (pathData));
            }
        }
    }

    public function removePointFromPath (points:Vector.<Point>, pathData:PathData):void {
        if (_levelData) {
            var index:int = _levelData.paths.indexOf(pathData);
            if (index != -1) {
                for (var i:int = 0; i < points.length; i++) {
                    var point:Point = points [i];
                    var pointAsString:String = DataUtils.pointToStringData(point);
                    var pointIndex:int = pathData.points.indexOf(pointAsString);
                    if (pointIndex != -1) {
                        pathData.points.splice(pointIndex, 1);
                    }
                }
                dispatchEvent(new EditPathEvent (pathData));
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
            var pathData:PathData = _levelData.addNewPath ();
            dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_ADDED));
        }
    }

    public function deletePath (pathData:PathData):void {
        if (_levelData) {
            if (_levelData.deletePath (pathData)) {
                dispatchEvent(new EditPathEvent (pathData, EditPathEvent.PATH_WAS_REMOVED));
            }
        }
    }

    /////////////////////////////////////////////
    //GENERATORS & WAVES:
    /////////////////////////////////////////////

    public function addNewGenerator ():void {
        if (_levelData) {
            var generatorData:GeneratorData = _levelData.addNewGenerator ();
            var numWaves:int = _levelData.waves.length;
            for (var i:int = 0; i < numWaves; i++) {
                var generatorWaveData:GeneratorWaveData = new GeneratorWaveData();
                var waveData:WaveData = _levelData.waves [i];
                generatorWaveData.id = waveData.id;
                generatorData.waves.push (generatorWaveData);
            }
            dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_ADDED));
        }
    }

    public function removeGenerator (generatorData:GeneratorData):void {
        if (_levelData) {
            if (_levelData.removeGenerator(generatorData)) {
                dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_REMOVED));
            }
        }
    }

    public function setGeneratorPath (pathId:int, generatorData:GeneratorData):void {
        if (_levelData) {
            var index:int = _levelData.generators.indexOf (generatorData);
            if (index != -1) {
                //проверяем, существует ли путь с таким id:
                var numPaths:int = _levelData.paths.length;
                for (var i:int = 0; i < numPaths; i++) {
                    var pathData:PathData = _levelData.paths [i];
                    if (pathData.id == pathId) {
                        generatorData.pathId = pathId;
                        if (pathData.points.length > 0) {
                            var point:Point = DataUtils.stringDataToPoint(pathData.points [0]);
                            generatorData.place (point.x, point.y);
                        }
                        dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                        break;
                    }
                }
            }
        }
    }

    public function setGeneratorPosition (point:Point, generatorData:GeneratorData):void {
        if (_levelData) {
            var index:int = _levelData.generators.indexOf (generatorData);
            if (index != -1) {
                //находим текущий путь по id:
                var numPaths:int = _levelData.paths.length;
                for (var i:int = 0; i < numPaths; i++) {
                    var pathData:PathData = _levelData.paths [i];
                    if (pathData.id == generatorData.pathId) {
                        //проверяем, существует ли в текущем пути указаная точка:
                        var numPoints:int = pathData.points.length;
                        for (var j:int = 0; j < numPoints; j++) {
                            var pathPoint:Point = DataUtils.stringDataToPoint(pathData.points [j]);
                            if (pathPoint.equals (point)) {
                                generatorData.place(point.x, point.y);
                                dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                                break;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    public function addNewWave():void {
        if (_levelData) {
            var waveData:WaveData = _levelData.addNewWave ();
            dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_ADDED));
        }
    }

    public function removeWave(waveId:int):void {
        if (_levelData) {
            var waveData:WaveData = _levelData.getWaveDataById(waveId);
            if (_levelData.removeWave (waveId)) {
                dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_REMOVED));
                trace ("удаляем волну " + waveId);
            }
            else {
                trace ("не можем удалить волну " + waveId);
            }
        }
    }

    //устанавливаем время для волны:
    public function setWaveTime (time:int, waveData:WaveData):void {
        if (_levelData) {
            var index:int = _levelData.waves.indexOf (waveData);
            if (index != -1) {
                waveData.time = time;
                dispatchEvent(new EditWavesEvent (waveData, EditWavesEvent.WAVE_WAS_CHANGED));
            }
        }
    }

    //устанавливаем задержку для волны генератора:
    public function setDelayOfGeneratorWave (delay:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData) {
            var numGenerators:int = _levelData.generators.length;
            for (var i:int = 0; i < numGenerators; i++) {
                var generatorData:GeneratorData = _levelData.generators [i];
                var index:int = generatorData.waves.indexOf (generatorWaveData);
                if (index != -1) {
                    generatorWaveData.delay = delay;
                    dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED));
                    dispatchEvent(new EditGeneratorEvent (generatorData, EditGeneratorEvent.GENERATOR_WAS_CHANGED));
                    break;
                }
            }
        }
    }

    //добавляем врага в стек волны генератора:
    public function addEnemyToGeneratorWave (enemyId:String, positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData && hasGeneratorWaveData (generatorWaveData)) {
            if (generatorWaveData.sequence.length >= positionId) {
                generatorWaveData.sequence.splice(positionId, 0, enemyId);
                dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED));
            }
        }
    }

    //убираем врага из стека волны генератора:
    public function removeEnemyToGeneratorWave (positionId:int, generatorWaveData:GeneratorWaveData):void {
        if (_levelData && hasGeneratorWaveData (generatorWaveData)) {
            if (generatorWaveData.sequence.length > positionId) {
                generatorWaveData.sequence.splice(positionId, 1);
                dispatchEvent(new EditGeneratorWaveEvent (generatorWaveData, EditGeneratorWaveEvent.GENERATOR_WAVE_WAS_CHANGED))
            }
        }
    }

    /////////////////////////////////////////////
    //DEFENDER ZONES:
    /////////////////////////////////////////////

    public function addPointsToDefenderZones (points:Vector.<Point>):void {
        if (_levelData) {
            for (var i:int = 0; i < points.length; i++) {
                var point:Point = points [i];
                var pointAsString:String = DataUtils.pointToStringData(point);
                if (_levelData.defenderZonesPoints.indexOf(pointAsString) == -1) {
                    _levelData.defenderZonesPoints.push(pointAsString);
                }
            }
            dispatchEvent(new EditDefenderZonesEvent ());
        }
    }

    public function removePointsToDefenderZone (points:Vector.<Point>):void {
        if (_levelData) {
            for (var i:int = 0; i < points.length; i++) {
                var point:Point = points [i];
                var pointAsString:String = DataUtils.pointToStringData(point);
                var pointIndex:int = _levelData.defenderZonesPoints.indexOf(pointAsString);
                if (pointIndex != -1) {
                    _levelData.defenderZonesPoints.splice(pointIndex, 1);
                }
            }
            dispatchEvent(new EditDefenderZonesEvent ());
        }
    }

    public function clearAllDefenderZonesPoint ():void {
        if (_levelData) {
            _levelData.clearAllDefenderZonesPoint();
            dispatchEvent(new EditDefenderZonesEvent ());
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
                if (!cell.depth && checkUpperCells(cell)) {
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
            createPart($x, $y, part, $placeData);
        }
    }

    private function checkObject($x: int, $y: int, $data: ObjectData):Boolean {
        for each (var part: PartData in $data.parts) {
            for (var i:int = 0; i < $data.mask.length; i++) {
                for (var j:int = 0; j < $data.mask[i].length; j++) {
                    var cell: Cell = getCell($x+i, $y+j);
                    if (cell) {
                        if ($data.mask[i][j]==1 && cell.object) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }

    private function createPart($x: int, $y: int, $data: PartData, $placeData: PlaceData):void {
        var object: FieldObject = new FieldObject($data, $placeData);

        var cell: Cell;
        for (var i:int = 0; i < object.data.mask.length; i++) {
            for (var j:int = 0; j < object.data.mask[i].length; j++) {
                cell = getCell($x+i, $y+j);
                if (cell) {
                    if (object.data.mask[i][j]) {
                        cell.lock();
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

    private function hasGeneratorWaveData (generatorWaveData:GeneratorWaveData):Boolean {
        if (_levelData) {
            var numGenerators:int = _levelData.generators.length;
            for (var i:int = 0; i < numGenerators; i++) {
                var generatorData:GeneratorData = _levelData.generators [i];
                var index:int = generatorData.waves.indexOf (generatorWaveData);
                if (index != -1) {
                    return true;
                }
            }
        }
        return false;
    }
}
}
