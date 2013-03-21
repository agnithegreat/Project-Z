/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.03.13
 * Time: 12:12
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor {
import com.projectz.utils.levelEditor.controller.LevelEditorController;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.data.LevelStorage;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.ui.ObjectEditorUI;
import com.projectz.utils.levelEditor.ui.hogarLevelEditor.LevelEditorUI;
import com.projectz.utils.levelEditor.view.FieldView;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectsStorage;

import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.utils.formatString;

public class App extends Sprite {

    private var _assets: AssetManager;
    private var _objectsStorage: ObjectsStorage;
    private var _levelsStorage: LevelStorage;

    private var _model: Field;
    private var _view: FieldView;
    private var _controller: LevelEditorController;
    private var _uiController: UIController;

    private var _levelEditorUI: LevelEditorUI;
    private var _objectEditorUI: ObjectEditorUI;

    private var _path: String;

    public function App() {
        _objectsStorage = new ObjectsStorage();
        _levelsStorage = new LevelStorage();
    }

    //Запустаем приложение, начав загрузку ассетов:
    public function startLoading($assets: AssetManager, $path: String):void {
        _path = $path;
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
        _objectsStorage.parseDirectory(formatString(_path+"/textures/{0}x/level_elements", _assets.scaleFactor), _assets);
        _levelsStorage.parseDirectory(_path+"/levels");

        Starling.juggler.delayCall(startGame, 0.15);
    }

    private function startGame():void {
        //init mvc model:
        _model = new Field(36, 36, _objectsStorage);

        _controller = new LevelEditorController(_model);
        _uiController = new UIController(_controller);

        _view = new FieldView(_model, _assets, _uiController);

        addChild(_view);

        //add ui:
        _objectEditorUI = new ObjectEditorUI(_assets, _uiController);

        addChild(_objectEditorUI);
        _objectEditorUI.filesPanel.showFiles(_objectsStorage);

        _levelEditorUI = new LevelEditorUI(_uiController, _objectsStorage);

        _levelEditorUI.x = Constants.WIDTH;
        Starling.current.nativeStage.addChild(_levelEditorUI);

        //init application:
        _model.levelData = _levelsStorage.getLevelData("level_01");
        _uiController.mode = UIControllerMode.EDIT_OBJECTS;
        _uiController.selectCurrentObjectType(ObjectData.STATIC_OBJECT);
        _uiController.selectCurrentObject(null);
    }
}
}
