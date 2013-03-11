/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 0:41
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class ObjectData {

    private var _name: String;
    public function get name():String {
        return _name;
    }

    private var _mask: Array = [[1]];
    public function get mask():Array {
        return _mask;
    }
    public function get width():int {
        return _mask.length;
    }
    public function get height():int {
        return _mask[0].length;
    }

    private var _parts: Dictionary;
    public function get parts():Dictionary {
        return _parts;
    }
    public function getPart($name: String = ""):PartData {
        if (!_parts[$name]) {
            _parts[$name] = new PartData($name);
        }
        return _parts[$name];
    }

    private var _config: File;
    public function get exists():Boolean {
        return _config.exists;
    }

    public function ObjectData($name: String, $config: File = null) {
        _name = $name;
        _config = $config;
        _parts = new Dictionary();

        if (_config && exists) {
            load();
        }
    }

    public function size($width: int, $height: int):void {
        _mask = [];
        for (var i:int = 0; i < $width; i++) {
            _mask[i] = [];
            for (var j:int = 0; j < $height; j++) {
                _mask[i][j] = 1;
            }
        }
    }

    public function invertCellState($x: int, $y: int):void {
        _mask[$x][$y] = _mask[$x][$y] ? 0 : 1;
    }

    private function getParts():Object {
        var pts: Object = {};
        var index: String;
        for (index in _parts) {
           pts[index] = _parts[index].export();
        }
        return pts;
    }

    public function parse($data: String):void {
        var data: Object = JSON.parse($data);

        _mask = data.mask;

        var index: String;
        var part: Object;
        for (index in data.parts) {
            part = getPart(index);
            part.parse(data.parts[index]);
        }
    }

    public function save():void {
        var data: String = JSON.stringify(export());
        _config.save(data);
    }

    public function export():Object {
        return {'name': _name, 'mask': _mask, 'parts': getParts()};
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
