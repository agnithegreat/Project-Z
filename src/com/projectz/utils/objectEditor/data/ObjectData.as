/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 07.03.13
 * Time: 0:41
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class ObjectData {

    public var name: String;

    public var x: int = 0;
    public var y: int = 0;

    public var mask: Array = [[1]];

    private var _config: File;
    public function get exists():Boolean {
        return _config.exists;
    }

    public function ObjectData($name: String, $config: File) {
        name = $name;
        _config = $config;

        if (exists) {
            load();
        }
    }

    public function parse($data: String):void {
        var data: Object = JSON.parse($data);
        x = data.x;
        y = data.y;
        mask = data.mask;
    }

    public function save():void {
        var data: String = JSON.stringify({'x': x, 'y': y, 'mask': mask});
        _config.save(data);
    }

    private function load():void {
        _config.addEventListener(Event.COMPLETE, handleLoad);
        _config.load();
    }

    private function handleLoad($event: Event):void {
        var bytes: ByteArray = _config.data;
        parse(bytes.readUTFBytes(bytes.length));
    }
}
}
