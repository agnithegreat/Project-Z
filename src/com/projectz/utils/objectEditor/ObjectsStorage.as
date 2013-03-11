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

public class ObjectsStorage {

    private var _objects: Dictionary;

    public function ObjectsStorage() {
        _objects = new Dictionary();
    }

    public function parseDirectory (path:String, $animated: Boolean, _assets: AssetManager):void {
        var folder: File = File.applicationDirectory.resolvePath(formatString(path, _assets.scaleFactor));
        parseObjects(ObjectParser.parseDirectory(folder), $animated, _assets);
    }

    private function parseObjects($objects: Dictionary, $animated: Boolean, _assets: AssetManager):void {
        var name: String;
        var obj: ObjectData;
        var part: PartData;
        for (name in $objects) {
            obj = $objects[name] as ObjectData;
            for each (part in obj.parts) {
                if ($animated) {
                    trace ("---addTextures: "  + (name+"_"+part.name));
                    part.addTextures(_assets.getTextures(name+"_"+part.name));
                } else {
                    trace ("---|---addTextures: "  + (part.name ? name+"_"+part.name : name));
                    part.addTextures(_assets.getTexture(part.name ? name+"_"+part.name : name));
                }
            }
            _objects[name] = obj;
        }
    }

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

}
}
