/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.filesystem.File;
import flash.utils.Dictionary;

import starling.utils.AssetManager;

public class ObjectParser {

    public static function parseDirectory($path: File, $assets: AssetManager, $objectList: Object):Dictionary {
        var listing: Vector.<File> = getFilesRecursive($path);
        for (var i:int = 0; i < listing.length; i++) {
            $objectList.files.push($path.getRelativePath(listing[i]));
        }
        return filterFiles(listing, $assets);
    }

    private static function filterFiles($files: Vector.<File>, $assets: AssetManager):Dictionary {
        // Список всех файлов со всеми расширениями
        var files: Dictionary = new Dictionary();

        // Список всех родительских директорий для всех файлов
        var directories: Dictionary = new Dictionary();

        // Список объектов без расширений, объединенных по общему префиксу
        var objects: Dictionary = new Dictionary();

        // Список имен частей объектов
        var parts: Dictionary = new Dictionary();

        var len: int = $files.length;
        var file: File;

        // Части имени файла
        var nameParts: Array;
        var name: String;
        for (var i:int = 0; i < len; i++) {
            file = $files[i];
            files[file.name] = file;
            nameParts = getFileName(file.name).split("_");
            name = nameParts.shift();
            directories[name] = file.parent;
            objects[name] = name;

            if (!parts[name]) {
                parts[name] = [];
            }
            parts[name].push(nameParts.join("_"));
        }

        var animated: Boolean;
        var partName: String;
        var part: PartData;
        for (name in objects) {
            file = files[name+".json"];
            objects[name] = new ObjectData(name, file ? file : directories[name].resolvePath(name+".json"));
            len = parts[name].length;
            for (i = 0; i < len; i++) {
                partName = parts[name][i];
                animated = files[name+"_"+partName+".xml"] && files[name+"_"+partName+".png"];
                if (animated) {
                    part = objects[name].getPart();
                    part.addTextures(partName, $assets.getTextures(name+"_"+partName));
                } else {
                    part = objects[name].getPart(partName);
                    part.addTextures(partName, $assets.getTexture(part.name ? name+"_"+part.name : name));
                }
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
