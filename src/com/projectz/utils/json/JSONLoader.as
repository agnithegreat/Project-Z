/**
 * Created with IntelliJ IDEA.
 * User: maxim
 * Date: 20.03.13
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.json {
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import starling.events.EventDispatcher;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.filesystem.File;

public class JSONLoader extends EventDispatcher {

    private static var fs: FileStream = new FileStream();

    protected var _file: File;
    public function get exists():Boolean {
        return _file.exists;
    }

    protected var _data: Object;
    public function get data():Object {
        if (!_data) {
            _data = {};
        }
        return _data;
    }

    public function JSONLoader($file: File) {
        _file = $file;
    }

    public function parse($data: Object):void {

    }

    public function save($data: Object):void {
        var text: String = JSON.stringify($data);
        fs.addEventListener(Event.COMPLETE, handleComplete_save);
        fs.open(_file, FileMode.WRITE);
        fs.writeUTFBytes(text);
        fs.close();
    }

    protected function handleComplete_save(event:Event):void {
        fs.removeEventListener(Event.COMPLETE, handleComplete_save);
        dispatchEventWith(Event.COMPLETE, false, data);
    }

    public function load():void {
        if (_file.exists) {
            _file.addEventListener(Event.COMPLETE, handleComplete);
            _file.addEventListener(Event.CANCEL, handleCancel);
            _file.load();
        } else {
            dispatchEventWith(Event.COMPLETE, false, data);
        }
    }

    protected function handleComplete(event:Event):void {
        _file.removeEventListener(Event.COMPLETE, handleComplete);

        var bytes: ByteArray = _file.data;
        _data = JSON.parse(bytes.readUTFBytes(bytes.length));
        parse(_data);

        dispatchEventWith(Event.COMPLETE, false, data);
    }

    protected function handleCancel(event:Event):void {
        dispatchEventWith(Event.CANCEL, false, data);
    }
}
}
