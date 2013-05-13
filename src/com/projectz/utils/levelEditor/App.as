/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor {
import com.projectz.utils.json.JSONManager;
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.ui.LevelEditorUI;
import com.projectz.utils.levelEditor.view.FieldView;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import starling.events.Event;
import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.utils.formatString;

/**
 * Редактор уровней.
 */
public class App extends Sprite {

    public static var testSprite:Sprite = new Sprite();

    private var _assetsManager: AssetManager;
    private var _objectsStorage: ObjectsStorage;
    private var _levelsStorage: LevelStorage;

    private var _jsonManager: JSONManager;

    private var _model: Field;
    private var _view: FieldView;
    private var _controller: LevelEditorController;
    private var _uiController: UIController;

    private var _levelEditorUI: LevelEditorUI;

    private var _path: String;

    public function App() {
        _objectsStorage = new ObjectsStorage();
        _levelsStorage = new LevelStorage();

        addChild(testSprite);
    }

    //Запустаем приложение, начав загрузку ассетов:
    public function startLoading($assets: AssetManager, $path: String):void {
        _path = $path;
        _assetsManager = $assets;
        _assetsManager.loadQueue(handleProgress);
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
        _jsonManager = new JSONManager();
        _jsonManager.addEventListener(Event.CHANGE, handleLoadProgress);
        _jsonManager.addEventListener(Event.COMPLETE, handleLoaded);

        _objectsStorage.parseDirectory(formatString(_path+"/textures/{0}x/final/level_elements", _assetsManager.scaleFactor), _assetsManager);
        _jsonManager.addFiles(_objectsStorage.objects);

        _levelsStorage.parseDirectory(_path+"/levels");
        _jsonManager.addFiles(_levelsStorage.levels);

        _jsonManager.load();
    }

    private function handleLoadProgress($event: Event):void {
        trace("JSON loading progress:", $event.data);
    }

    private function handleLoaded($event: Event):void {
        _jsonManager.removeEventListener(Event.CHANGE, handleLoadProgress);
        _jsonManager.removeEventListener(Event.COMPLETE, handleLoaded);

        startGame();
    }

    private function startGame():void {
        //init mvc model:
        _model = new Field(72, 72, _objectsStorage);

        _controller = new LevelEditorController(_model);
        _uiController = new UIController(_controller);

        _view = new FieldView(_model, _assetsManager, _uiController);

        addChild(_view);


        //add ui:
        _levelEditorUI = new LevelEditorUI(_uiController, _model, _objectsStorage, _levelsStorage, _assetsManager);

        _levelEditorUI.x = Constants.WIDTH;
        Starling.current.nativeStage.addChild(_levelEditorUI);

        //init application:
        _model.levelData = _levelsStorage.getLevelData(2);
        _uiController.mode = UIControllerMode.EDIT_OBJECTS;
    }
}
}
