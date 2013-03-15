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

    private var _levels: Dictionary; //хранит ссылки на все ассеты игры (в виде обектов LevelData)

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
        var folder: File = File.applicationDirectory.resolvePath($path);
        _levels = LevelParser.parseDirectory(folder, _levelsList);
    }

    /**
     * Получение объекта LevelData, представляющего данные об уровне
     *
     * @param $id id'шник уровня
     */
    public function getLevelData ($id:String):LevelData {
        var levelData:LevelData;
        levelData = _levels [$id];
        if (levelData) {
            return levelData;
        }
        else {
            throw new Error ('Level "' + $id + '" not parsed.');
        }
    }
}
}
