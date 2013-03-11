/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor {
import com.projectz.utils.objectEditor.data.ObjectData;

import flash.filesystem.File;
import flash.utils.Dictionary;

public class ObjectParser {

    public static function parseDirectory($path: File):Dictionary {
        var listing: Vector.<File> = getFilesRecursive($path);
        return filterFiles(listing);
    }

    private static function filterFiles($files: Vector.<File>):Dictionary {
        var names: Object = {};
        var fileNames: Object = {};
        var parts: Object = {};

        var len: int = $files.length;
        var name: String;
        var nameParts: Array = [];
        for (var i:int = 0; i < len; i++) {
            nameParts = getFileName($files[i].name).split("_");
            name = nameParts.shift();
            names[name] = name;
            fileNames[name] = $files[i];
            if (!parts[name]) {
                parts[name] = [];
            }
            parts[name].push(nameParts.join("_"));
        }

        var files: Dictionary = new Dictionary();
        var file: File;
        for (name in names) {
            file = fileNames[name] as File;
            files[name] = new ObjectData(name, file.parent.resolvePath(name+".json"));
            len = parts[name].length;
            for (i = 0; i < len; i++) {
                files[name].getPart(parts[name][i]);
            }
        }
        return files;
    }

    private static function getFileName($name: String):String {
        return $name.split(".")[0];
    }

    private static function getFilesRecursive($file: File):Vector.<File> {
        var fileList: Vector.<File> = new <File>[];
        trace ("$file = " + $file + "; nativePath = " + $file.nativePath);
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
