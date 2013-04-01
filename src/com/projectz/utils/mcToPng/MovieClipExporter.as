/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 31.03.13
 * Time: 14:18
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.mcToPng {
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.net.getClassByAlias;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

public class MovieClipExporter extends Sprite {

    private var _file: File;
    private var _sequence: Vector.<PNG>;

    public function MovieClipExporter() {
        super();

        _file = new File();
        _file.addEventListener(Event.SELECT, handleSelect);
        _file.addEventListener(Event.COMPLETE, handleLoaded);
        _file.browse();
    }

    private function handleSelect($event: Event):void {
        _file.load();
    }

    private function handleLoaded($event: Event):void {
        var data:ByteArray = _file.data;
        var loader: Loader = new Loader();

        var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
        loaderContext.allowCodeImport = true;
        loader.loadBytes(data, loaderContext);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
    }

    private function onLoaderComplete(event:Event):void {
        var name: String = _file.name.split(".")[0];
        var type: String = name.split("-")[1];
        var Cl: Class = getDefinitionByName(type) as Class;
        _sequence = MovieClipToPNG.exportPNGSequence(name, new Cl());
        saveNext(null);
    }

    private function saveNext($event: Event):void {
        var png: PNG = _sequence.shift();
        var file: File = new File();
        file.addEventListener(Event.COMPLETE, saveNext);
        file.save(png.data, png.name+".png");
    }
}
}
