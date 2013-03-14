/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor {
import com.projectz.model.Game;
import com.projectz.utils.objectEditor.ObjectsStorage;
import com.projectz.view.FieldView;

import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.AssetManager;

public class LevelEditorApp extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;

    private var _model: Game;
    private var _view: FieldView;

    public function LevelEditorApp() {
        _objectsStorage = new ObjectsStorage();
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
        _objectsStorage.parseDirectory("textures/{0}x/level_elements", _assets);

        Starling.juggler.delayCall(startGame, 0.15);
    }

    private function startGame():void {
        _model = new Game(_objectsStorage)

        _view = new FieldView(_model.field, _assets);
        addChild(_view);

        _model.init();
    }
}
}
