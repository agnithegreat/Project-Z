/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 27.03.13
 * Time: 20:56
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {

public class GeneratorData {

    private var _x: int;
    public function get x():int {
        return _x;
    }

    private var _y: int;
    public function get y():int {
        return _y;
    }

    private var _path: int;
    public function get path():int {
        return _path;
    }
    public function set path($value: int):void {
        _path = $value;
    }

    private var _waves: Vector.<GeneratorWaveData>;
    public function get waves():Vector.<GeneratorWaveData> {
        return _waves;
    }

    public function GeneratorData() {
        _waves = new <GeneratorWaveData>[];
    }

    public function place($x: int, $y: int):void {
        _x = $x;
        _y = $y;
    }

    public function parse($data: Object):void {
        _x = $data.x;
        _y = $data.y;
        _path = $data.path ? $data.path : 2;

        var len: int = $data.waves.length;
        for (var i:int = 0; i < len; i++) {
            _waves[i] = new GeneratorWaveData();
            _waves[i].parse($data.waves[i]);
        }
    }

    public function export():Object {
        return {"x": _x, "y": _y, "path": _path, "waves": getWaves()};
    }

    private function getWaves():Array {
        var waves: Array = [];
        var len: int = _waves.length;
        for (var i:int = 0; i < len; i++) {
            waves[i] = _waves[i].export();
        }
        return waves;
    }
}
}
