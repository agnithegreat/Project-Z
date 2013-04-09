/**
 * Created with IntelliJ IDEA.
 * User: maxim
 * Date: 20.03.13
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.json {
import com.projectz.game.model.Field;

import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import starling.events.EventDispatcher;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.filesystem.File;

public class JSONLoader extends EventDispatcher {

    protected var _file: File;
    private var dataForSave: Object;

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
        dataForSave = $data;

        _file.addEventListener(Event.SELECT, handleSelect);
        _file.addEventListener(Event.CANCEL, handleCancel);
        _file.browseForSave(_file.name);
    }

    public function load():void {
        if (_file.exists) {
            _file.addEventListener(Event.COMPLETE, handleComplete_load);
            _file.addEventListener(Event.CANCEL, handleCancel);
            _file.load();
        } else {
            dispatchEventWith(Event.COMPLETE, false, data);
        }
    }

    protected function handleComplete_load(event:Event):void {
        _file.removeEventListener(Event.COMPLETE, handleComplete_load);
        _file.removeEventListener(Event.CANCEL, handleCancel);

        var bytes: ByteArray = _file.data;
        _data = JSON.parse(bytes.readUTFBytes(bytes.length));
        parse(_data);

        dispatchEventWith(Event.COMPLETE, false, data);
    }

    protected function handleCancel(event:Event):void {
        trace("handleCancel");
        _file.removeEventListener(Event.COMPLETE, handleComplete_load);
        _file.removeEventListener(Event.CANCEL, handleCancel);
        dispatchEventWith(Event.CANCEL, false, data);
    }

    private function handleSelect(event:Event):void {
        trace("handleSelect");
        var file:File = File (event.target);
        file.removeEventListener(Event.SELECT, handleSelect);
        file.removeEventListener(Event.CANCEL, handleCancel);
        if (file.exists && dataForSave)
        {
            var text: String = JSON.stringify(dataForSave);
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes(text);
            stream.close();

            dispatchEventWith(Event.COMPLETE, false, data);
        }
    }
}
}
