/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 0:41
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {

import com.projectz.utils.json.JSONLoader;
import com.projectz.utils.objectEditor.data.events.EditObjectDataEvent;

import flash.filesystem.File;
import flash.utils.Dictionary;

/**
 * Отправляется при изменении данных.
 *
 * @eventType com.projectz.utils.objectEditor.data.events.EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED
 */
[Event(name="object data was changed", type="com.projectz.utils.objectEditor.data.events.EditObjectDataEvent")]

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
     *
     * @see com.projectz.utils.objectEditor.data.ObjectType
     */
    public function get type():String {
        return _type;
    }

    protected var _mask: Array/*of Array(of int)*/;
    /**
     * Массив массивов данных о клетках, которые занимает объект.
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
     * Проверка, является ли указанная клетка проходимой.
     * @param $x Координата x клетки.
     * @param $y Координата y клетки.
     * @return Возвращает 0, если клетка проходимая. Возвращает 1, если клетка непроходимая.
     * Возвращает -1, если клетки не существует.
     */
    public function getUnwalkable($x: int, $y: int):int {
        if (($x < width) && ($y < height)) {
            return (PartData.UNWALKABLE & _mask[$x][$y]);
        }
        else {
            return -1;
        }
    }

    /**
     * Проверка, является ли клекта проcтреливаемой.
     * @param $x Координата x клетки.
     * @param $y Координата y клетки.
     * @return Возвращает 0, если клетка простреливаемая, возвращает 2, если клетка непростреливаемая.
     * Возвращает -1, если клетки не существует.
     */
    public function getUnshotable($x: int, $y: int):int {
        if (($x < width) && ($y < height)) {
            return (PartData.UNSHOTABLE & _mask[$x][$y]);
        }
        else {
            return -1;
        }
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
     * Установка размера объекта (в клетках).
     * @param $width Ширина объекта (в клетках).
     * @param $height Высота объекта (в клетках).
     */
    public function setSize($width: int, $height: int):void {
        for each (var part:PartData in parts) {
            part.setSize($width, $height);
        }
        dispatchEvent(new EditObjectDataEvent(this, EditObjectDataEvent.OBJECT_DATA_WAS_CHANGED));
    }

    /**
     * Смещение всех частей или текущей выбранной части на указанное расстояние.
     * @param $dx Расстояние по оси x.
     * @param $dy Расстояние по оси y.
     */
    public function moveParts($dx: int, $dy: int):void {
        var partData:PartData;
        for each (partData in _parts) {
            partData.place(partData.pivotX + $dx, partData.pivotY + $dy);
        }
        if (_shadow) {
            _shadow.place(_shadow.pivotX + $dx, _shadow.pivotY + $dy);
        }
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
//        setSize($data.parts[""].mask.length, $data.parts[""].mask.length);
        var index: String;
        var part: PartData;
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
        return {'name': _name, 'parts': getParts()};
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
}
}
