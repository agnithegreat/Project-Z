/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import com.projectz.game.model.objects.Defender;
import com.projectz.game.model.objects.Enemy;

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
        var ObjectClass: Class;
        var part: PartData;
        for (name in objects) {
            file = files[name+".json"];
            ObjectClass = getClass(name.split("-")[0]);
            objects[name] = new ObjectClass(name, file ? file : directories[name].resolvePath(name+".json"));
            len = parts[name].length;
            for (i = 0; i < len; i++) {
                partName = parts[name][i];
                animated = !partName && files[name+".xml"] && files[name+".png"];
                if (animated) {
                    part = objects[name].getPart(partName);
                    for (var j:int = 1; j <= 5; j++) {
                        if (objects[name].type == ObjectType.ENEMY) {
                            part.addTextures(Enemy.WALK+"-0"+j, $assets.getTextures(name+"-"+Enemy.WALK+"-0"+j));
                            part.addTextures(Enemy.ATTACK+"-0"+j, $assets.getTextures(name+"-"+Enemy.ATTACK+"-0"+j));
                            part.addTextures(Enemy.DIE+"-0"+j, $assets.getTextures(name+"-"+Enemy.DIE+"-0"+j));
                        } else if (objects[name].type == ObjectType.DEFENDER) {
                            part.addTextures(Defender.STATIC+"-0"+j, $assets.getTextures(name+"-"+Defender.STATIC+"-0"+j));
                            part.addTextures(Defender.ATTACK+"-0"+j, $assets.getTextures(name+"-"+Defender.ATTACK+"-0"+j));
                            part.addTextures(Defender.FIGHT+"-0"+j, $assets.getTextures(name+"-"+Defender.FIGHT+"-0"+j));
                            part.addTextures(Defender.RELOAD+"-0"+j, $assets.getTextures(name+"-"+Defender.RELOAD+"-0"+j));
                        }
                    }
                } else {
                    part = objects[name].getPart(partName);
                    part.addTextures(partName, $assets.getTexture(part.name ? name+"_"+part.name : name));
                }
            }
        }
        return objects;
    }

    private static function getClass($type: String):Class {
        switch ($type) {
            case ObjectType.DEFENDER:
                return DefenderData;
            case ObjectType.ENEMY:
                return EnemyData;
            case ObjectType.TARGET_OBJECT:
                return TargetData;
        }
        return ObjectData;
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
            if (file.isDirectory) {
                if (file.name !="." && file.name !="..") {
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
