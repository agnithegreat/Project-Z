/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 11.03.13
 * Time: 15:05
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent;

import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

/**
 * Класс, предназначенный для хранения массива обектов LevelData и получения конкретного LevelData по его id.
 */
public class LevelStorage extends EventDispatcher {

    private var _folder: File;
    private var _levelsList: Object = {levels: []};

    private static const LEVEL:String = "level_";

    private var _levels: Dictionary; //хранит ссылки на все уровни игры (в виде обектов LevelData)
    /**
     * Все уровни игры в виде объекта Dictionary. Ключами служат строки вида "level_1", где цифра - это id'шник уровня.
     */
    public function get levels():Dictionary {
        return _levels;
    }

    /**
     * Добавление нового уровня.
     */
    public function addNewLevel ():void {
        var i:int = 1;
        var currentLevelId:String;
        for (currentLevelId in _levels) {
            i++;
        }
        var id: String = LEVEL + i;
        var levelData:LevelData = new LevelData(_folder.resolvePath(id+".json"));
        _levels[id] = levelData;
        levelData.save(levelData.export());
        dispatchEvent(new EditLevelsEvent (levelData, EditLevelsEvent.LEVEL_WAS_ADDED));
    }

    /**
     * Удаление уровня.
     * @param levelData Уровень для удаления.
     */
    public function removeLevel (levelData:LevelData):void {
        if (levelData) {
            var currentLevelId:String;
            var currentLevelData:LevelData;
            for (currentLevelId in _levels) {
                currentLevelData = _levels[currentLevelId];
                if (currentLevelData == levelData) {
                    currentLevelData.deleteFile();
                    _levels [currentLevelId] = null;
                    dispatchEvent(new EditLevelsEvent (levelData, EditLevelsEvent.LEVEL_WAS_REMOVED));
                    break;
                }
            }
        }
    }

    /**
     * Формирует список уровней в виде объектов LevelData и сохраняет эти объекты в переменную _levels.
     *
     * @param $path Путь к директории
     */
    public function parseDirectory ($path:String):void {
        _folder = new File($path);
        _levels = LevelParser.parseDirectory(_folder, _levelsList);
    }

    /**
     * Получение объекта LevelData, представляющего данные об уровне.
     *
     * @param $id Id'шник уровня.
     */
    public function getLevelData ($id: int):LevelData {
        var id: String = LEVEL+$id;
        return _levels[id];
    }
}
}
