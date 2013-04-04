/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 14.03.13
 * Time: 20:58
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import com.projectz.utils.json.JSONLoader;

import flash.filesystem.File;
import flash.geom.Point;

public class LevelData extends JSONLoader {

    private var _id: int;
    public function get id():int {
        return _id;
    }
    public function set id($value: int):void {
        _id = $value;
    }

    private var _bg: String;
    public function get bg():String {
        return _bg;
    }
    public function set bg($value: String):void {
        _bg = $value;
    }

    private var _objects: Vector.<PlaceData>;
    public function get objects():Vector.<PlaceData> {
        return _objects;
    }

    private var _paths: Vector.<PathData>;//вектор путей, по которым перемещаются враги.
    public function get paths():Vector.<PathData> {
        return _paths;
    }

    private var _generators: Vector.<GeneratorData>;
    public function get generators():Vector.<GeneratorData> {
        return _generators;
    }

    private var _positions: Vector.<PositionData>;
    public function get positions():Vector.<PositionData> {
        return _positions;
    }

    private var _waves: Vector.<WaveData>;
    public function get waves():Vector.<WaveData> {
        return _waves;
    }

    public function LevelData($config: File = null) {
        super($config);

        _objects = new <PlaceData>[];
        _paths = new <PathData>[];
        _generators = new <GeneratorData>[];
        _positions = new <PositionData>[];
        _waves = new <WaveData>[];
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function addObject($object: PlaceData):void {
        if (_objects.indexOf($object)<0) {
            _objects.push($object);
        }
    }
    public function removeObject($object: PlaceData):void {
        var index: int = _objects.indexOf($object);
        if (index >= 0) {
            _objects.splice(index, 1);
        }
    }

    public function addNewPath ():PathData {
        //расчитываем максимальный id среди всех путей:
        var maxId:int = 0;
        var numPaths:int = paths.length;
        for (var i:int = 0; i < numPaths; i++) {
            maxId = Math.max (maxId, paths [i].id);
        }
        //добавляем новый путь:
        var pathData:PathData = new PathData ();
        pathData.id = maxId + 1;
        paths.push (pathData);
        return pathData;
    }

    public function deletePath (pathData:PathData):Boolean {
        var index:int = _paths.indexOf(pathData);
        if (index != -1) {
            _paths.splice(index, 1);
            return true;
        }
        return false;
    }

    public function addNewGenerator ():GeneratorData {
        var generatorData: GeneratorData = new GeneratorData();
        if (paths.length > 0) {
            var pathData:PathData = paths [0];
            generatorData.pathId = pathData.id;
            if (pathData.points.length > 0) {
                var point:Point = pathData.points [0];
                generatorData.place (point.x,  point.y);
            }
        }
        _generators.push (generatorData);
        return generatorData;
    }

    public function removeGenerator ($gen:GeneratorData):Boolean {
        var index:int = _generators.indexOf($gen);
        if (index != -1) {
            _generators.splice(index, 1);
            return true;
        }
        return false;
    }

    public function addPosition($pos: PositionData):void {
        if (_positions.indexOf($pos)<0) {
            _positions.push($pos);
        }
    }
    public function removePosition($pos: PositionData):void {
        var index: int = _positions.indexOf($pos);
        if (index >= 0) {
            _positions.splice(index, 1);
        }
    }

    public function addNewWave():WaveData {
        //расчитываем максимальный id среди всех волн:
        var maxId:int = 0;
        var numWaves:int = waves.length;
        var i:int;
        for (i = 0; i < numWaves; i++) {
            maxId = Math.max (maxId, waves [i].id);
        }
        //добавляем новую волну:
        var waveData:WaveData = new WaveData ();
        waveData.id = maxId + 1;
        _waves.push(waveData);
        //добавляем новую волну в каждый генератор:
        var numGenerators:int = generators.length;
        for (i = 0; i < numGenerators; i++) {
            var generatorData:GeneratorData = generators [i];
            generatorData.addNewWaveData(waveData.id);
        }

        return waveData;
    }

    public function removeWave(id:int):Boolean {
        var numWaves:int = waves.length;
        for (var i:int = 0; i < numWaves; i++) {
            var waveData:WaveData = _waves [i];
            if (waveData.id == id) {
                //удаляем волну:
                _waves.splice(i, 1);
                //удаляем волну из каждого генератора:
                var numGenerators:int = generators.length;
                for (var j:int = 0; j < numGenerators; j++) {
                    var generatorData:GeneratorData = generators [j];
                    generatorData.removeWaveData(id);
                }
                return true;
            }
        }
        return false;
    }

    override public function parse($data: Object):void {
        _id = $data.id;
        _bg = $data.bg;

        var len: int = $data.objects ? $data.objects.length : 0;
        var i:int;
        for (i = 0; i < len; i++) {
            var object: PlaceData = new PlaceData();
            object.parse($data.objects[i]);
            _objects.push(object);
        }

        len = $data.paths ? $data.paths.length : 0;
        for (i = 0; i < len; i++) {
            var pathData: PathData = new PathData();
            pathData.parse($data.paths[i]);
            _paths.push(pathData);
        }

        len = $data.generators ? $data.generators.length : 0;
        for (i = 0; i < len; i++) {
            var generator: GeneratorData = new GeneratorData();
            generator.parse($data.generators[i]);
            _generators.push(generator);
        }

        len = $data.positions ? $data.positions.length : 0;
        for (i = 0; i < len; i++) {
            var pos: PositionData = new PositionData();
            pos.parse($data.positions[i]);
            _positions.push(pos);
        }

        len = $data.waves ? $data.waves.length : 0;
        for (i = 0; i < len; i++) {
            var wave: WaveData = new WaveData();
            wave.parse($data.waves[i]);
            _waves.push(wave);
        }
    }

    public function export():Object {
        return {'id': _id, 'bg': _bg, 'objects': getObjects(), 'paths':getPaths(), 'generators': getGenerators(), 'positions': getPositions(), "waves": getWaves()};
    }

    public function getPathDataById (id:int):PathData {
        var numPath:int = _paths.length;
        for (var i:int = 0; i < numPath; i++) {
            var pathData:PathData = _paths [i];
            if (pathData.id == id) {
                return pathData;
            }
        }
        return pathData;
    }

    public function getWaveDataById (id:int):WaveData {
        var numWaves:int = _waves.length;
        for (var i:int = 0; i < numWaves; i++) {
            var waveData:WaveData = _waves [i];
            if (waveData.id == id) {
                return waveData;
            }
        }
        return waveData;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function getObjects():Array {
        var objs: Array = [];
        var len: int = _objects.length;
        for (var i:int = 0; i < len; i++) {
            objs[i] = _objects[i].export();
        }
        return objs;
    }

    private function getPaths():Array {
        var paths: Array = [];
        var len: int = _paths.length;
        for (var i:int = 0; i < len; i++) {
            paths[i] = _paths[i].export();
        }
        return paths;
    }

    private function getGenerators():Array {
        var gs: Array = [];
        var len: int = _generators.length;
        for (var i:int = 0; i < len; i++) {
            gs[i] = _generators[i].export();
        }
        return gs;
    }

    private function getPositions():Array {
        var ps: Array = [];
        var len: int = _positions.length;
        for (var i:int = 0; i < len; i++) {
            ps[i] = _positions[i].export();
        }
        return ps;
    }

    private function getWaves():Array {
        var ws: Array = [];
        var len: int = _waves.length;
        for (var i:int = 0; i < len; i++) {
            ws[i] = _waves[i].export();
        }
        return ws;
    }
}
}
