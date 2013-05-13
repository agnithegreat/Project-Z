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

/**
 * Класс, хранящий сслыку на файл в формаке json.
 * Загружает, парсит и сохраняет файл.
 */
public class JSONLoader extends EventDispatcher {

    private var fileStream:FileStream = new FileStream();

    protected var _file: File;
    public function get exists():Boolean {
        return _file.exists;
    }

    private var _name: String;

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

    public function saveAs($data: Object):void {
        _name = _name || _file.name;
        var text: String = JSON.stringify($data);
        _file.addEventListener(Event.COMPLETE, handleComplete_save);
        _file.save(text, _name);
    }

    public function save($data: Object):void {
        fileStream.open (_file, FileMode.WRITE);
        var dataAsString: String = JSON.stringify($data);
        fileStream.writeUTFBytes (dataAsString);
        fileStream.close ();
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

    public function get path():String {
        return _file.nativePath;
    }

    protected function handleComplete(event:Event):void {
        _file.removeEventListener(Event.COMPLETE, handleComplete);

        var bytes: ByteArray = _file.data;
        _data = JSON.parse(bytes.readUTFBytes(bytes.length));
        parse(_data);

        dispatchEventWith(Event.COMPLETE, false, data);
    }

    protected function handleComplete_save(event:Event):void {
        _file.removeEventListener(Event.COMPLETE, handleComplete_save);

        dispatchEventWith(Event.COMPLETE, false, data);
    }

    protected function handleCancel(event:Event):void {
        dispatchEventWith(Event.CANCEL, false, data);
    }
}
}
