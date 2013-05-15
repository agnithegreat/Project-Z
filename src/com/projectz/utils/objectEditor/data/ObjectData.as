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

/**
 * Класс, хранящий данные об игровом объекте.
 */
public class ObjectData extends JSONLoader {

    private var _name: String;
    /**
     * Название объекта.
     */
    public function get name():String {
        return _name;
    }

    private var _type: String;
    /**
     * Тип объекта.
     * @see com.projectz.utils.objectEditor.data.ObjectType
     */
    public function get type():String {
        return _type;
    }

    protected var _mask: Array/*of Array(of int)*/;
    /**
     * Массив массивов данных о клетках, которые занимает объект.
     * Хначения массива определяют свойтсва клеток
     * (0 = непростреливаемый непроходимый, 1 = проходимый, 2 = простреливаемый, 3 = простреливаемый проходимый).
     */
    public function get mask():Array/*of Array(of int)*/ {
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

    /**
     * Ширина объекта (в клетках).
     */
    public function get width():int {
        return mask.length;
    }

    /**
     * Высота объекта (в клетках).
     */
    public function get height():int {
        return mask[0].length;
    }

    private var _parts: Dictionary;
    /**
     * Части объекта в виде объекта Dictionary.
     */
    public function get parts():Dictionary {
        return _parts;
    }

    /**
     * Получение части объекта по имени.
     * @param $name Имя части объекта.
     * @return Часть объекта.
     */
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
    /**
     * Часть объекта, являющеяся тенью.
     */
    public function get shadow():PartData {
        return _shadow;
    }

    /**
     *
     * @param $name Имя объекта.
     * @param $config Файл, хранящий данные об объекте.
     */
    public function ObjectData($name: String, $config: File = null) {
        super($config);

        _name = $name;
        _type = _name.split("-")[0];
        _parts = new Dictionary();
    }

    /**
     * Устаноска размера объекта (в клетках).
     * @param $width Ширина объекта (в клетках).
     * @param $height Высота объекта (в клетках).
     */
    public function setSize($width: int, $height: int):void {
        for each (var part:PartData in parts) {
            part.setSize($width, $height);
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

    /**
     * Сохранение текущего состояния объекта в файл.
     */
    public function saveFile ():void {
        save(export());
    }

    /**
     * @inheritDoc
     */
    override public function parse($data: Object):void {
        setSize($data.mask.length, $data.mask[0].length);

        var index: String;
        var part: Object;
        for (index in $data.parts) {
            part = getPart(index);
            part.parse($data.parts[index]);
        }
    }

    /**
     * Представление текущего состояния в виде объекта.
     * @return Объект, хранящий данные.
     */
    public function export():Object {
        return {'name': _name, 'mask': mask, 'parts': getParts()};
    }
}
}
