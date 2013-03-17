/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 14.03.13
 * Time: 20:58
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class LevelData {

    private var _id: int;
    public function get id():int {
        return _id;
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

    private var _config: File;
    public function get exists():Boolean {
        return _config.exists;
    }

    private var _paths: Vector.<PathData>;//вектор путей, по которым перемещаются враги.
    public function get paths():Vector.<PathData> {
        return _paths;
    }

    //TODO:добавить генераторы, которые генерируют волны, привязывают к путям, задают задержки по времни и т.д.

    public function LevelData($config: File = null) {
        _objects = new <PlaceData>[];
        _paths = new <PathData>[];

        _config = $config;
        if (_config && exists) {
            load();
        }
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function addPath (id:String):PathData {
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

    public function parse($data: String):void {
        var data: Object = JSON.parse($data);

        _id = data.id;
        _bg = data.bg;

        var len: int = data.objects.length;
        var i:int;
        for (i = 0; i < len; i++) {
            var object: PlaceData = new PlaceData();
            object.parse(data.objects[i]);
            _objects.push(object);
        }

        len = data.paths.length;
        for (i = 0; i < len; i++) {
            var pathData: PathData = new PathData();
            pathData.parse(data.paths[i]);
            _paths.push(pathData);
        }
    }

    public function save():void {
        var data: String = JSON.stringify(export());
        _config.save(data);
    }

    public function export():Object {
        return {'id': _id, 'bg': _bg, 'objects': getObjects(), 'paths':getPaths()};
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

    private function load():void {
        _config.addEventListener(Event.COMPLETE, handleLoad);
        _config.load();
    }

    private function handleLoad($event: Event):void {
        _config.removeEventListener(Event.COMPLETE, handleLoad);

        var bytes: ByteArray = _config.data;
        parse(bytes.readUTFBytes(bytes.length));
    }
}
}
