/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 09.03.13
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import com.projectz.utils.objectEditor.data.events.EditPartDataEvent;

import flash.geom.Point;
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

import starling.textures.Texture;

/**
 * Класс, хранящий данные о части игрового объекта.
 */
public class PartData extends EventDispatcher {

    public static const SHADOW: String = "shadow";

    public static const UNWALKABLE: int = 1;
    public static const UNSHOTABLE: int = 2;

    private var _name: String;
    /**
     * Имя части объекта.
     */
    public function get name():String {
        return _name;
    }

    private var _mask: Array = [[1]];
    /**
     * Массив массивов данных о клетках, которые занимает часть объекта.
     * Значения определяют свойства клетки:
     * <p>
     * <ul>
     *  <li>0 - простреливаемый проходимый;</li>
     *  <li>1 - простреливаемый непроходимый;</li>
     *  <li>2 - простреливаемый непроходимый;</li>
     *  <li>3 - непростреливаемый непроходимый.</li>
     * </ul>
     * </p>
     */
    public function get mask():Array {
        return _mask;
    }
    private var _width: int;
    /**
     * Ширина части объекта (в клетках).
     */
    public function get width():int {
        return _width;
    }
    private var _height: int;
    /**
     * Высота части объекта (в клетках).
     */
    public function get height():int {
        return _height;
    }

    private var _pivotX: int = 0;
    /**
     * Отступ по оси X.
     */
    public function get pivotX():int {
        return _pivotX;
    }
    private var _pivotY: int = 0;
    /**
     * Отступ по оси Y.
     */
    public function get pivotY():int {
        return _pivotY;
    }

    private var _states: Dictionary;
    /**
     * Состояния части объекта.
     */
    public function get states():Dictionary {
        return _states;
    }

    private var _animated: Boolean;
    /**
     * Является ли часть объекта анимированной.
     */
    public function get animated():Boolean {
        return _animated;
    }

    /**
     *
     * @param $name Имя части объекта.
     */
    public function PartData($name: String) {
        _name = $name;
        _states = new Dictionary();
    }

    /**
     * Добавления текстур к соответствующему состоянию частей объекта.
     * @param $state Состояние объекта.
     * @param $textures Текстуры. Может быть объектом Texture или Vector.&lt;Texture&gt;>.
     *
     * @see starling.textures.Texture
     */
    public function addTextures($state: String, $textures: *):void {
        if ($textures) {
            _states[$state] = $textures;
            if ($textures is Vector.<Texture>) {
                _animated = true;
            }
        }
    }

    /**
     * Установка части объекта, установка значений отступов.
     * @param $x Отступ по оси X.
     * @param $y Отступ по оси Y.
     *
     * @see #pivotX
     * @see #pivotY
     */
    public function place($x: int, $y: int):void {
        _pivotX = $x;
        _pivotY = $y;
        dispatchEvent(new EditPartDataEvent(this, EditPartDataEvent.PART_DATA_WAS_CHANGED));
    }

    /**
     * Устаноска размера части объекта (в клетках).
     * @param $width Ширина части объекта (в клетках).
     * @param $height Высота части объекта (в клетках).
     */
    public function setSize($width: int, $height: int):void {
        _mask = [];
        for (var i:int = 0; i < $width; i++) {
            _mask[i] = [];
            for (var j:int = 0; j < $height; j++) {
                _mask[i][j] = 1;
            }
        }
        _width = _mask.length;
        _height = _mask[0].length;
        dispatchEvent(new EditPartDataEvent(this, EditPartDataEvent.PART_DATA_WAS_CHANGED));
    }

    /**
     * Проверка, является ли указанная клетка проходимой.
     * @param $x Координата x клетки.
     * @param $y Координата y клетки.
     * @return Возвращает 0, если клетка проходимая. Возвращает 1, если клетка непроходимая.
     */
    public function getWalkable($x: int, $y: int):int {
        if (($x < _width) && ($y < _height)) {
//        return (WALKABLE & _mask[$x][$y]);
            return _mask[$x][$y];
        }
        else {
            return -1;
        }
    }

    /**
     * Установка проходимости клетки.
     * @param $x Координата x клетки.
     * @param $y Координата x клетки.
     * @param $walkable Если значение равно 0, то клетка станет проходимой, если 1, то непроходимой.
     */
    public function setWalkable($x: int, $y: int, $walkable: int):void {
        if ($x<0 || $y<0 || $x > _width || $y > _height) {
            return;
        }
//        _mask[$x][$y] = $walkable;
        _mask[$x][$y] = $walkable + getShotable($x, $y);
        dispatchEvent(new EditPartDataEvent(this, EditPartDataEvent.PART_DATA_WAS_CHANGED));
    }

    /**
     * Проверка, является ли клекта проcтреливаемой.
     * @param $x Координата x клетки.
     * @param $y Координата y клетки.
     * @return Возвращает 0, если клетка простреливаемая, возвращает 2, если клетка непростреливаемая.
     */
    public function getShotable($x: int, $y: int):int {
        return (UNSHOTABLE & _mask[$x][$y]);
    }

    /**
     * Установка простреливаемости клетки.
     * @param $x Координата x клетки.
     * @param $y Координата x клетки.
     * @param $shotable Если значение равно 0, то клетка станет простреливаемой, если 1, то непростреливаемой.
     */
    public function setShotable($x: int, $y: int, $shotable: int):void {
        if ($x<0 || $y<0 || $x > _width || $y > _height) {
            return;
        }
        _mask[$x][$y] = UNWALKABLE*getWalkable($x, $y) + UNSHOTABLE*$shotable;
        dispatchEvent(new EditPartDataEvent(this, EditPartDataEvent.PART_DATA_WAS_CHANGED));
    }

    private function getTop():Point {
        for (var i: int = 0; i < width+height; i++) {
            for (var j:int = 0; j <= i; j++) {
                if (i-j < width && j < height && _mask[i-j][j]) {
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
