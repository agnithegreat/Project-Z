/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import com.projectz.utils.json.JSONLoader;

import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

/**
 * Класс, предназначенный для хранения массива обектов ObjectData и получения конкретного ObjectData по его id.
 */
public class ObjectsStorage {

    private var _objects: Dictionary; //хранит ссылки на все ассеты игры (в виде обектов ObjectData)
    public function get objects():Dictionary {
        return _objects;
    }

    private var _types: Dictionary; //хранит группы ассетов по типам (so, ao, de и т.д.);

    private var _objectsList: Object = {files: []};
    public function get objectsList():Object {
        return _objectsList;
    }

    public function getObjectsByType($type: String):Dictionary {
        return _types[$type];
    }

    public function ObjectsStorage() {
        _types = new Dictionary();
    }

    /**
     * Выполняет поиск всех ассетов в указанной дерриктории, соотносит их с заранее загруженным содержимым из AssetManager.
     * Формирует список ассетов в виде объектов ObjectData и сохраняет эти объекты в переменную _objects
     *
     * @param $path Путь к директории
     * @param $assets AssetManager с заранее загруженными ассетами
     */
    public function parseDirectory ($path:String, $assets: AssetManager):void {
        var folder: File = new File($path);
        _objects = ObjectParser.parseDirectory(folder, $assets, _objectsList);

        for each (var object:ObjectData in _objects) {
            if (!_types[object.type]) {
                _types[object.type] = new Dictionary();
            }
            _types[object.type][object.name] = object;
        }
    }

    /**
     * Получение объекта ObjectData, представляющего данные об ассете
     *
     * @param $id id'шник объекта
     */
    public function getObjectData ($id:String):ObjectData {
        var objectData:ObjectData;
        objectData = _objects [$id];
        if (objectData) {
            return objectData;
        }
        else {
            throw new Error ('Asset "' + $id + '" not parsed.');
        }
    }
}
}
