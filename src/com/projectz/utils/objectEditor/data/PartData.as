/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 09.03.13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.utils.Dictionary;

import starling.textures.Texture;

public class PartData {

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

    private var _offsetX: int = 0;
    public function get offsetX():int {
        return _offsetX;
    }
    private var _offsetY: int = 0;
    public function get offsetY():int {
        return _offsetY;
    }

    private var _pivotX: int = 0;
    public function get pivotX():int {
        return _pivotX;
    }
    private var _pivotY: int = 0;
    public function get pivotY():int {
        return _pivotY;
    }

    private var _states: Dictionary;
    public function get states():Dictionary {
        return _states;
    }

    private var _animated: Boolean;
    public function get animated():Boolean {
        return _animated;
    }

    public function PartData($name: String) {
        _name = $name;
        _states = new Dictionary();
    }

    public function addTextures($state: String, $textures: *):void {
        if ($textures) {
            _states[$state] = $textures;
            if ($textures is Vector.<Texture>) {
                _animated = true;
            }
        }
    }

    public function place($x: int, $y: int):void {
        _pivotX = $x;
        _pivotY = $y;
    }

    public function offset($x: int, $y: int):void {
        _offsetX = $x;
        _offsetY = $y;
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

    public function parse($data: Object):void {
        _offsetX = $data.x;
        _offsetY = $data.y;
        _pivotX = $data.pivotX;
        _pivotY = $data.pivotY;
        _mask = $data.mask;
    }

    public function export():Object {
        return {'name': _name, 'x': _offsetX, 'y': _offsetY, 'pivotX': _pivotX, 'pivotY': _pivotY, 'mask': _mask};
    }
}
}
