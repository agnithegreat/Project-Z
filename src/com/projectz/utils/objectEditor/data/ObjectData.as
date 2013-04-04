/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 0:41
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import com.projectz.utils.json.JSONLoader;

import flash.filesystem.File;
import flash.utils.Dictionary;

public class ObjectData extends JSONLoader {

    public static var STATIC_OBJECT: String = "so";
    public static var ANIMATED_OBJECT: String = "ao";
    public static var TARGET_OBJECT: String = "to";
    public static var DEFENDER: String = "de";
    public static var ENEMY: String = "en";
    public static var BACKGROUND: String = "bg";

    private var _name: String;
    public function get name():String {
        return _name;
    }

    private var _type: String;
    public function get type():String {
        return _type;
    }

    protected var _mask: Array;
    public function get mask():Array {
        _mask = [[1]];
        for each (var part:PartData in _parts) {
            for (var i:int = 0; i < part.width; i++) {
                while (_mask.length<=i) {
                    _mask.push([]);
                }
                for (var j:int = 0; j < part.height; j++) {
                    while (_mask[i].length<=j) {
                        _mask[i].push(0);
                    }
                    if (part.mask[i][j]) {
                        _mask[i][j] = part.mask[i][j];
                    }
                }
            }
        }
        return _mask;
    }
    public function get width():int {
        return mask.length;
    }
    public function get height():int {
        return mask[0].length;
    }

    private var _parts: Dictionary;
    public function get parts():Dictionary {
        return _parts;
    }
    public function getPart($name: String = ""):PartData {
        if ($name == PartData.SHADOW) {
            if (!_shadow) {
                _shadow = new PartData(PartData.SHADOW);
            }
            return _shadow;
        }
        if (!_parts[$name]) {
            _parts[$name] = new PartData($name);
        }
        return _parts[$name];
    }

    private var _shadow: PartData;
    public function get shadow():PartData {
        return _shadow;
    }

    public function ObjectData($name: String, $config: File = null) {
        super($config);

        _name = $name;
        _type = _name.split("-")[0];
        _parts = new Dictionary();
    }

    public function size($width: int, $height: int):void {
        for each (var part:PartData in parts) {
            part.size($width, $height);
        }
    }

    private function getParts():Object {
        var pts: Object = {};
        var index: String;
        for (index in _parts) {
           pts[index] = _parts[index].export();
        }
        if (_shadow) {
            pts[PartData.SHADOW] = _shadow.export();
        }
        return pts;
    }

    override public function parse($data: Object):void {
        size($data.mask.length, $data.mask[0].length);

        var index: String;
        var part: Object;
        for (index in $data.parts) {
            part = getPart(index);
            part.parse($data.parts[index]);
        }
    }

    public function export():Object {
        return {'name': _name, 'mask': mask, 'parts': getParts()};
    }
}
}
