/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.filesystem.File;
import flash.utils.Dictionary;

/**
 * Класс, предназначенный для хранения массива обектов LevelData и получения конкретного LevelData по его id.
 */
public class LevelStorage {

    private var _folder: File;

    private var _levels: Dictionary; //хранит ссылки на все уровни игры (в виде обектов LevelData)
    public function get levels():Dictionary {
        return _levels;
    }

    private var _levelsList: Object = {levels: []};
    public function get levelsList():Object {
        return _levelsList;
    }

    public function LevelStorage() {
    }

    /**
     * Формирует список уровней в виде объектов LevelData и сохраняет эти объекты в переменную _levels
     *
     * @param $path Путь к директории
     */
    public function parseDirectory ($path:String):void {
        _folder = new File($path);
        _levels = LevelParser.parseDirectory(_folder, _levelsList);
    }

    /**
     * Получение объекта LevelData, представляющего данные об уровне
     *
     * @param $id id'шник уровня
     */
    public function getLevelData ($id: int):LevelData {
        var id: String = "level_"+$id;
        if (!_levels[id]) {
            _levels[id] = new LevelData(_folder.resolvePath(id+".json"));
            _levels[id].id = $id;
        }
        return _levels[id];
    }
}
}
