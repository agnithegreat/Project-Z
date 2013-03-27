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

    public function LevelData($config: File = null) {
        super($config);

        _objects = new <PlaceData>[];
        _paths = new <PathData>[];
        _generators = new <GeneratorData>[];
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

    public function addPath (id:int):PathData {
        var pathData:PathData = new PathData ();
        pathData.id = id;
        paths.push (pathData);
        return pathData;
    }

    public function removePath (pathData:PathData):Boolean {
        var index:int = _paths.indexOf(pathData);
        if (index != -1) {
            _paths.splice(index, 1);
            return true;
        }
        return false;
    }

    override public function parse($data: Object):void {
        _id = $data.id;
        _bg = $data.bg;

        var len: int = $data.objects.length;
        var i:int;
        for (i = 0; i < len; i++) {
            var object: PlaceData = new PlaceData();
            object.parse($data.objects[i]);
            _objects.push(object);
        }

        len = $data.paths.length;
        for (i = 0; i < len; i++) {
            var pathData: PathData = new PathData();
            pathData.parse($data.paths[i]);
            _paths.push(pathData);
        }

        len = $data.generators.length;
        for (i = 0; i < len; i++) {
            var generator: GeneratorData = new GeneratorData();
            generator.parse($data.generators[i]);
            _generators.push(generator);
        }
    }

    public function export():Object {
        return {'id': _id, 'bg': _bg, 'objects': getObjects(), 'paths':getPaths(), 'generators': getGenerators()};
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
}
}
