/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 09.03.13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.geom.Point;
import flash.utils.Dictionary;

import starling.textures.Texture;
import starling.utils.AssetManager;

public class PartData {

    public static const BACK: String = "back";
    public static const SHADOW: String = "shadow";

    private var _name: String;
    public function get name():String {
        return _name;
    }

    private var _mask: Array = [[1]];
    public function get mask():Array {
        return _mask;
    }
    private var _width: int;
    public function get width():int {
        return _width;
    }
    private var _height: int;
    public function get height():int {
        return _height;
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

    public function size($width: int, $height: int):void {
        _mask = [];
        for (var i:int = 0; i < $width; i++) {
            _mask[i] = [];
            for (var j:int = 0; j < $height; j++) {
                _mask[i][j] = _name==SHADOW ? 0 : 1;
            }
        }
        _width = _mask.length;
        _height = _mask[0].length;
    }

    private function getTop():Point {
        for (var i: int = 0; i < width+height; i++) {
            for (var j:int = 0; j <= i; j++) {
                if (i-j<width && j<height && _mask[i-j][j]) {
                    return new Point(i-j, j);
                }
            }
        }
        return null;
    }

    private var _top: Point;
    public function get top():Point {
        if (!_top && (width==height==1 || _name==SHADOW)) {
            _top = new Point(0, 0);
        }
        if (!_top) {
            _top = getTop();
        }
        return _top;
    }

    private var _left: Point;
    public function get left():Point {
        if (!_left) {
            _left = new Point(width-1, top.y);
            while (!_mask[_left.x][_left.y]) {
                _left.x--;
            }
        }
        return _left;
    }

    private var _right: Point;
    public function get right():Point {
        if (!_right) {
            _right = new Point(top.x, height-1);
            while (!_mask[_right.x][_right.y]) {
                _right.y--;
            }
        }
        return _right;
    }

    public function invertCellState($x: int, $y: int):void {
        _mask[$x][$y] = _mask[$x][$y] ? 0 : 1;
    }

    public function parse($data: Object):void {
        _pivotX = $data.pivotX;
        _pivotY = $data.pivotY;
        _mask = $data.mask;
        _width = _mask.length;
        _height = _mask[0].length;
    }

    public function export():Object {
        return {'name': _name, 'pivotX': _pivotX, 'pivotY': _pivotY, 'mask': _mask};
    }
}
}
