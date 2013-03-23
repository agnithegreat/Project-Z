/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 24.03.13
 * Time: 0:22
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.json {
import flash.utils.Dictionary;

import starling.events.Event;
import starling.events.EventDispatcher;

public class JSONManager extends EventDispatcher {

    private var _files: Vector.<JSONLoader>;

    private var _loaded: int = 0;
    private var _total: int = 0;
    public function get progress():Number {
        return _loaded/_total;
    }

    public function get currentLoading():JSONLoader {
        return _files[_loaded];
    }

    public function JSONManager() {
        _files = new <JSONLoader>[];
    }

    public function addFiles($files: Dictionary):void {
        for each (var file:JSONLoader in $files) {
            addFile(file);
        }
    }

    public function addFile($file: JSONLoader):void {
        _files.push($file);
    }

    public function load():void {
        _total = _files.length;
        loadCurrent();
    }

    private function loadCurrent():void {
        currentLoading.addEventListener(Event.COMPLETE, handleNext);
        currentLoading.load();
    }

    private function handleNext($event: Event):void {
        currentLoading.removeEventListener(Event.COMPLETE, handleNext);
        _loaded++;

        if (_loaded<_total) {
            loadCurrent();
            dispatchEventWith(Event.CHANGE, false, progress);
        } else {
            dispatchEventWith(Event.COMPLETE);
        }
    }
}
}
