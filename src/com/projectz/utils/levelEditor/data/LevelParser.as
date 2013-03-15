/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.data {
import flash.filesystem.File;
import flash.utils.Dictionary;

public class LevelParser {

    public static function parseDirectory($path: File, $levelList: Object):Dictionary {
        var listing: Vector.<File> = getFilesRecursive($path);
        for (var i:int = 0; i < listing.length; i++) {
            $levelList.levels.push($path.getRelativePath(listing[i]));
        }
        return filterFiles(listing);
    }

    private static function filterFiles($files: Vector.<File>):Dictionary {
        // Список всех файлов со всеми расширениями
        var files: Dictionary = new Dictionary();

        // Список всех родительских директорий для всех файлов
        var directories: Dictionary = new Dictionary();

        // Список объектов без расширений, объединенных по общему префиксу
        var objects: Dictionary = new Dictionary();

        var len: int = $files.length;
        var file: File;

        // Части имени файла
        var name: String;
        for (var i:int = 0; i < len; i++) {
            file = $files[i];
            files[file.name] = file;
            name = getFileName(file.name);
            directories[name] = file.parent;
            objects[name] = name;
        }

        var level: LevelData;
        for (name in objects) {
            if (name != "levelsList") {
                file = files[name+".json"];
                objects[name] = new LevelData(file ? file : directories[name].resolvePath(name+".json"));
            }
        }
        return objects;
    }

    private static function getFileName($name: String):String {
        return $name.split(".")[0];
    }

    private static function getFilesRecursive($file: File):Vector.<File> {
        var fileList: Vector.<File> = new <File>[];
        var files: Array = $file.getDirectoryListing();
        var len: int = files.length;
        var file: File;
        for (var i:int = 0; i < len; i++) {
            file = $file.resolvePath(files[i].name);
            if (files[i].isDirectory) {
                if (files[i].name !="." && files[i].name !="..") {
                    fileList = fileList.concat(getFilesRecursive(file));
                }
            } else {
                fileList.push(file);
            }
        }
        return fileList;
    }
}
}
