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
                _mask[i][j] = 1;
            }
        }
    }

    private function getDepthNextCell($x: int, $y: int):Point {
        // TODO: какая-то хуйня, их хер выровняешь правильно. надо искать новые методы индексации
        for (var i: int = $x+$y; i < width+height; i++) {
            for (var j:int = $y; j <= i; j++) {
                if (i-j<width && j<height && _mask[i-j][j]) {
                    return new Point(i-j, j);
                }
            }
        }
        return null;
    }

    private var _top: Point;
    public function get top():Point {
        if (!_top && width==height==1) {
            _top = new Point(0, 0);
        }
        if (!_top) {
            _top = getDepthNextCell(0, 0);
        }
        return _top;
    }

    private var _left: Point;
    public function get left():Point {
        if (!_left && width==height==1) {
            _left = new Point(0, 0);
        }
        if (!_left) {
            var x: int = width-1;
            var y: int = 0;
            var i: int = 0;
            var j: int = 0;
            while (x+i<0 || y+i<0 || !_mask[x+i][y+i]) {
                if (i>=j) {
                    x--;
                    i = 0;
                    j++;
                } else {
                    i++;
                }
            }
            _left = getDepthNextCell(x-y+top.y, top.y);
        }
        return _left;
    }

    private var _right: Point;
    public function get right():Point {
        if (!_right && width==height==1) {
            _right = new Point(0, 0);
        }
        if (!_right) {
            var x: int = 0;
            var y: int = height-1;
            var i: int = 0;
            var j: int = 0;
            while (x+i<0 || y+i<0 || !_mask[x+i][y+i]) {
                if (i>=j) {
                    y--;
                    i = 0;
                    j++;
                } else {
                    i++;
                }
            }
            _right = getDepthNextCell(top.x, y-x+top.x);
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
    }

    public function export():Object {
        return {'name': _name, 'pivotX': _pivotX, 'pivotY': _pivotY, 'mask': _mask};
    }
}
}
