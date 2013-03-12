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

    public function ObjectsStorage() {
        _objects = new Dictionary();
    }

    /**
     * Выполняет поиск всех ассетов в указанной дерриктории, соотносит их с заранее загруженным содержимым из AssetManager.
     * Формирует список ассетов в виде объектов ObjectData и сохраняет эти объекты в переменную _objects
     *
     * @param path Путь к директории
     * @param $animated Наличие анимации в ассетах
     * @param _assets AssetManager с заранее загруженными ассетами
     */
    public function parseDirectory (path:String, $animated: Boolean, _assets: AssetManager):void {
        var folder: File = File.applicationDirectory.resolvePath(formatString(path, _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), $animated, _assets);
    }

    /**
     * Получение объекта ObjectData, представляющего данные об ассете
     *
     * @param id id'шник объекта
     */
    public function getObjectData (id:String):ObjectData {
        var objectData:ObjectData;
        objectData = _objects [id];
        if (objectData) {
            return objectData;
        }
        else {
            throw new Error ('Asset "' + id + '" not parsed.');
        }
    }

    /**
     * Соотносит список файлов с заранее загруженным содержимым из AssetManager.
     * Формирует список ассетов в виде объектов ObjectData и сохраняет эти объекты в переменную _objects
     *
     * @param $objects Список файлов
     * @param $animated Наличие анимации в ассетах
     * @param _assets AssetManager с заранее загруженными ассетами
     */
    private function parseObjects($objects: Dictionary, $animated: Boolean, _assets: AssetManager):void {
        var name: String;
        var obj: ObjectData;
        var part: PartData;
        for (name in $objects) {
            obj = $objects[name] as ObjectData;
            for each (part in obj.parts) {
                if ($animated) {
                    part.addTextures(_assets.getTextures(name+"_"+part.name));
                } else {
                    part.addTextures(_assets.getTexture(part.name ? name+"_"+part.name : name));
                }
            }
            _objects[name] = obj;
        }
    }

}
}
