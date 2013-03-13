/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.PartData;

import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.utils.AssetManager;
import starling.utils.formatString;

/**
 * Класс, предназначенный для хранения массива обектов ObjectData и получения конкретного ObjectData по его id.
 */
public class ObjectsStorage {

    private var _objects: Dictionary; //хранит ссылки на все ассеты игры (в виде обектов ObjectData)
    private var _folders: Dictionary;

    public function getFolder($id: String):Dictionary {
        return _folders[$id];
    }

    public function ObjectsStorage() {
        _objects = new Dictionary();
        _folders = new Dictionary();
    }

    /**
     * Выполняет поиск всех ассетов в указанной дерриктории, соотносит их с заранее загруженным содержимым из AssetManager.
     * Формирует список ассетов в виде объектов ObjectData и сохраняет эти объекты в переменную _objects
     *
     * @param $path Путь к директории
     * @param $assets AssetManager с заранее загруженными ассетами
     */
    public function parseDirectory ($path:String, $assets: AssetManager):void {
        var folder: File = File.applicationDirectory.resolvePath(formatString($path, $assets.scaleFactor));
        _folders[folder.name] = ObjectParser.parseDirectory(folder, $assets);

        for (var o:String in _folders[folder.name]) {
            _objects[o] = _folders[folder.name][o];
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