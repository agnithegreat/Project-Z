/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor {
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.ui.FileLine;
import com.projectz.utils.levelEditor.ui.UI;
import com.projectz.utils.levelEditor.view.FieldView;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.formatString;

public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;
    private var _levelsStorage: LevelStorage;

    private var _model: Field;
    private var _view: FieldView;
    private var _ui: UI;

    public function App() {
        _objectsStorage = new ObjectsStorage();
        _levelsStorage = new LevelStorage();
    }

    //Запустаем приложение, начав загрузку ассетов:
    public function startLoading($assets: AssetManager):void {
        _assets = $assets;
        _assets.loadQueue(handleProgress);
    }

    private function handleProgress(ratio: Number):void {
        //TODO:Сюда можно добавить прелоадер, отображающий ход загрузки ассетов
        if (ratio == 1) {
            //После загрузки всех ассетов запускаем приложение с задерждой
            Starling.juggler.delayCall(startApp, 0.15);
        }
    }

    //Запускаем приложение после загрузки всех ассетов:
    private function startApp():void {
        _objectsStorage.parseDirectory(formatString("textures/{0}x/level_elements", _assets.scaleFactor), _assets);
        _levelsStorage.parseDirectory("levels");

        Starling.juggler.delayCall(startGame, 0.15);
    }

    private function startGame():void {
        _model = new Field(36, 36, _objectsStorage, _levelsStorage.getLevelData("level_01"));

        _view = new FieldView(_model, _assets);
        addChild(_view);

        _model.init();

        _ui = new UI(_assets);
        _ui.addEventListener(FileLine.SELECT_FILE, handleOperation);
        addChild(_ui);

        _ui.filesPanel.showFiles(_objectsStorage);

//        var sprite:flash.display.Sprite = new flash.display.Sprite();
//        sprite.graphics.beginFill(0x00ff00);
//        sprite.graphics.drawRect(100, 100, 400, 250);
//        sprite.graphics.endFill();
//        Starling.current.nativeStage.addChild (sprite);
    }

    private function handleOperation($event: Event):void {
        _view.selectFile($event.data as ObjectData);
    }
}
}
