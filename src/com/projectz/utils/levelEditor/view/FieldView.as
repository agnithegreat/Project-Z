/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {

import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.controller.EditMode;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectEditDefenderPositionModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectEditPathModeEvent;
import com.projectz.utils.levelEditor.data.DataUtils;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.model.events.editDefenderZones.EditDefenderPositionEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditObjectEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditBackgroundEvent;
import com.projectz.utils.levelEditor.model.events.editObjects.EditPlaceEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editObjects.SelectObjectsTypeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.SelectUIControllerModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEvent;
import com.projectz.utils.levelEditor.model.Field;
import com.projectz.utils.levelEditor.model.events.editPaths.EditPathEvent;
import com.projectz.utils.levelEditor.model.objects.FieldObject;
import com.projectz.utils.objectEditor.data.ObjectData;
import com.projectz.utils.objectEditor.data.ObjectType;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var uiController:UIController;

    private var _assets:AssetManager;

    private var _field:Field;

    private var _bg:Image;
    private var _container:Sprite;

    private var _cellsContainer:Sprite;
    private var _cellsViewAsObject:Object = new Object();
    private var _objectsContainer:Sprite;

    private var _currentObject:FieldObjectView;
    private var _currentCell:CellView;

    private var _shift:Boolean;

    protected var _selectMode: Boolean;
    protected var _isRolledOver:Boolean;
    protected var _lastCellX:int;
    protected var _lastCellY:int;

    private var firstSelectedPointForEditingPath:Point;
    //используется при редактировании пути методом редактирования областей по двум точкам.
    //Хранит информацию о первой выбраной точке.

    private var firstSelectedPointForEditingDefenderZones:Point;
    //используется при редактировании зон защитников методом редактирования областей по двум точкам.
    //Хранит информацию о первой выбраной точке.

    public function FieldView($field:Field, $assets:AssetManager, uiController:UIController) {
        _assets = $assets;
        this.uiController = uiController;

        uiController.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        uiController.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(SelectEditPathModeEvent.SELECT_EDIT_PATH_MODE, selectEditPathModeListener);
        uiController.addEventListener(SelectEditDefenderPositionModeEvent.SELECT_EDIT_DEFENDER_POSITION_MODE, selectEditDefenderPositionModeListener);
        uiController.addEventListener(SelectPathEvent.SELECT_PATH, selectPathListener);
        uiController.addEventListener(SelectGeneratorEvent.SELECT_GENERATOR, selectGeneratorListener);
        uiController.addEventListener(SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION, selectDefenderPositionListener);

        _field = $field;
        _field.addEventListener(EditBackgroundEvent.BACKGROUND_WAS_CHANGED, backgroundWasChangedListener);
        _field.addEventListener(GameEvent.UPDATE, handleUpdate);
        _field.addEventListener(EditObjectEvent.OBJECT_ADDED, handleAddObject);
        _field.addEventListener(EditObjectEvent.OBJECT_REMOVED, handleRemoveObject);
        _field.addEventListener(EditPlaceEvent.PLACE_ADDED, handleAddPlace);
        _field.addEventListener(EditPathEvent.PATH_WAS_CHANGED, handleChangePath);
        _field.addEventListener(EditPathEvent.COLOR_WAS_CHANGED, handleChangePath);
        _field.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED, handleEditDefenderZones);

        _container = new Sprite();
        addChild(_container);

        _cellsContainer = new Sprite();
        _cellsContainer.touchable = false;
        _container.addChild(_cellsContainer);

        var len:int = _field.field.length;
        var cellView:CellView;
        for (var i:int = 0; i < len; i++) {
            cellView = new CellView(
                    _field.field[i],
                    $assets.getTexture("ms-cell-levelEditor"),
                    $assets.getTexture("ms-cell-levelEditor-lock"),
                    $assets.getTexture("ms-cell-levelEditor-flag"),
                    $assets.getTexture("ms-cell-levelEditor-hatching")
            );
            _cellsContainer.addChild(cellView);
            _cellsViewAsObject[cellView.positionX + "_" + cellView.positionY] = cellView;
        }

        _cellsContainer.flatten();

        _container.x = (Constants.WIDTH + PositionView.cellWidth) * 0.5;
        _container.y = (Constants.HEIGHT + (1 - (_field.height + _field.height) * 0.5) * PositionView.cellHeight) * 0.5;

        _objectsContainer = new Sprite();
        _objectsContainer.touchable = false;
        _container.addChild(_objectsContainer);

        addEventListener(GameEvent.DESTROY, handleDestroy);

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    public function destroy():void {
        stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

        removeEventListeners();

        uiController.removeEventListeners();
        _field.removeEventListeners();
        _field = null;

        _bg.removeFromParent(true);
        _bg = null;

        var cell:CellView;
        while (_cellsContainer.numChildren > 0) {
            cell = _cellsContainer.getChildAt(0) as CellView;
            cell.destroy();
            cell.removeFromParent(true);
        }
        _cellsContainer.removeFromParent(true);
        _cellsContainer = null;
        _cellsViewAsObject = null;

        var object:ObjectView;
        while (_objectsContainer.numChildren > 0) {
            object = _objectsContainer.removeChildAt(0, true) as ObjectView;
            if (object) {
                object.destroy();
            }
        }
        _objectsContainer.removeFromParent(true);
        _objectsContainer = null;

        _container = null;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    private function addObject($data:ObjectData):void {
        if (_currentObject) {
            _currentObject.destroy();
            _currentObject.removeFromParent(true);
            _currentObject = null;
        }

        if ($data) {
            _currentObject = new FieldObjectView($data, _assets);
            _container.addChild(_currentObject);

            if (_currentCell) {
                _currentObject.x = _currentCell.x;
                _currentObject.y = _currentCell.y;
            }
        }

        _objectsContainer.alpha = _currentObject ? 0.5 : 1;
    }

    private function update():void {
        _objectsContainer.sortChildren(sortByDepth);
    }

    private function sortByDepth($child1:PositionView, $child2:PositionView):int {
        if ($child1.depth > $child2.depth) {
            return 1;
        } else if ($child1.depth < $child2.depth) {
            return -1;
        }
        return 0;
    }

    private function getCellViewByPosition($x:int, $y:int):CellView {
        var cellView:CellView = _cellsViewAsObject[$x + "_" + $y];
        if (!cellView) {
//            trace("ищем перебором");
//            for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
//                var _cellView:CellView = CellView(_cellsContainer.getChildAt(i));
//                if ((_cellView.positionX == $x) && (_cellView.positionY == $y)) {
//                    cellView = _cellView;
//                    break;
//                }
//            }
        }
        return cellView;
    }

    private function redrawPaths (pathData:PathData):void {
        _cellsContainer.unflatten();
        clearAllCells(true, true, true);
        var levelData:LevelData = _field.levelData;
        if (levelData) {
            var numPaths:int = levelData.paths.length;
            for (var i:int = 0; i < numPaths; i++) {
                var curPathData:PathData = levelData.paths [i];
                //pathData рисуем в последнюю очередь (последний слой)!
                if (curPathData != pathData) {
                    drawPath (curPathData, false);
                }
            }
        }
        //pathData рисуем в последнюю очередь (последний слой)!
        drawPath (pathData, true);
        _cellsContainer.flatten();
    }

    private function drawPath (pathData:PathData, showHatching:Boolean = false):void {
        if (pathData) {
            var color:uint = pathData.color;
            var numPoints:int = pathData.points.length;
            for (var i:int = 0; i < numPoints; i++) {
                var point:Point = DataUtils.stringDataToPoint(pathData.points[i]);
                var cellView:CellView = getCellViewByPosition(point.x, point.y);
                if (cellView) {
                    cellView.color = color;
                    cellView.showHatching = showHatching;
                }
            }
        }
    }

    private function redrawDefenderPositions (currentDefenderPositionData:DefenderPositionData):void {
        clearAllCells(false, true, true);
        var levelData:LevelData = _field.levelData;
        if (levelData) {
            _cellsContainer.unflatten();
            var numDefenderPositions:int = levelData.defenderPositions.length;
            for (var i:int = 0; i < numDefenderPositions; i++) {
                var defenderPosition:DefenderPositionData = levelData.defenderPositions [i];
                if (defenderPosition != currentDefenderPositionData) {
                    drawDefenderPosition (defenderPosition);
                }
            }
            if (currentDefenderPositionData) {
                var cellView:CellView;
                cellView = getCellViewByPosition(currentDefenderPositionData.x, currentDefenderPositionData.y);
                cellView.showFlag = true;
                cellView.showHatching = true;
                drawDefenderPosition (currentDefenderPositionData, true);
            }
            _cellsContainer.flatten();
        }
    }

    private function drawDefenderPosition (defenderPositionData:DefenderPositionData, showExtraHatching:Boolean = false):void {
        if (defenderPositionData) {
            _cellsContainer.unflatten();
            var availablePoints:Vector.<String> = defenderPositionData.availablePoints;
            var numAvailablePoints:int = availablePoints.length;
            for (var i:int = 0; i < numAvailablePoints; i++) {
                var point:Point = DataUtils.stringDataToPoint(availablePoints[i]);
                var cellView:CellView = getCellViewByPosition(point.x, point.y);
                if (showExtraHatching) {
                    cellView.showExtraHatching();
                }
                else {
                    cellView.showHatching = true;
                }
            }
            cellView = getCellViewByPosition(defenderPositionData.x, defenderPositionData.y);
            cellView.showFlag = true;
            _cellsContainer.flatten();
        }
    }

    private function clearAllCells (clearColor:Boolean = true, clearFlag:Boolean = true, clearHatching:Boolean = true, clearLock:Boolean = false):void {
        _cellsContainer.unflatten();
        var numCells:int = _cellsContainer.numChildren;
        for (var i:int = 0; i < numCells; i++) {
            var cellView:CellView = CellView (_cellsContainer.getChildAt(i));
            if (clearColor) {
                cellView.color = 0xffffff;
            }
            if (clearFlag) {
                cellView.showFlag = false;
            }
            if (clearHatching) {
                cellView.showHatching = false;
            }
            if (clearLock) {
                cellView.showLock = false;
            }
        }
        _cellsContainer.flatten();
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

    private function handleAddedToStage($event:Event):void {
        stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
    }

    private function handleAddPlace($event:EditPlaceEvent):void {
        addObject($event.objectData);
    }

    private function handleChangePath($event:EditPathEvent):void {
        redrawPaths ($event.pathData);
    }

    private function handleEditDefenderZones($event:EditDefenderPositionEvent):void {
        redrawDefenderPositions($event.defenderPositionData);
    }

    private function handleAddObject($event:EditObjectEvent):void {
        var fieldObject:FieldObject = $event.fieldObject;
        var object:ObjectView = new ObjectView(fieldObject, fieldObject.data.name);
        _objectsContainer.addChild(object);

        _cellsContainer.unflatten();
        for (var i:int = 0; i < fieldObject.data.width; i++) {
            for (var j:int = 0; j < fieldObject.data.height; j++) {
                if (fieldObject.data.mask[i][j]) {
                    var cellView:CellView = getCellViewByPosition(fieldObject.cell.x - fieldObject.data.top.x + i, fieldObject.cell.y - fieldObject.data.top.y + j);
                    if (cellView) {
                        cellView.showLock = true;
                    }
                }
            }
        }
        _cellsContainer.flatten();
    }

    private function handleRemoveObject($event:EditObjectEvent):void {
        var object:FieldObject = $event.fieldObject;
        _cellsContainer.unflatten();
        for (i = 0; i < object.data.width; i++) {
            for (var j:int = 0; j < object.data.height; j++) {
                if (object.data.mask[i][j]) {
                    var cellView:CellView = getCellViewByPosition(object.cell.x - object.data.top.x + i, object.cell.y - object.data.top.y + j);
                    if (cellView) {
                        cellView.showLock = false;
                    }
                }
            }
        }

        var len:int = _objectsContainer.numChildren;
        for (var i:int = 0; i < len; i++) {
            var obj:ObjectView = _objectsContainer.getChildAt(i) as ObjectView;
            if (obj.object == object) {
                obj.destroy();
                obj.removeFromParent(true);
                i--;
                len--;
            }
        }
        _cellsContainer.flatten();
    }

    private function handleUpdate($event:Event):void {
        update();
    }

    protected function onTouchHandler(event:TouchEvent):void {
        var touch:Touch = event.getTouch(stage);
        if (touch) {
            var pos:Point = getPositionByTouchEvent(touch);
            _currentCell = getCellViewByPosition(pos.x, pos.y);
            if (_currentCell) {
                if ((_currentCell.positionX != _lastCellX) || (_currentCell.positionY != _lastCellY)) {
                    onCellRollOut(getCellViewByPosition(_lastCellX, _lastCellY));
                    onCellRollOver(_currentCell);
                }
                _lastCellX = _currentCell.positionX;
                _lastCellY = _currentCell.positionY;
                switch (touch.phase) {
                    case TouchPhase.BEGAN:                                      // press
                        if (_selectMode) {
                            return;
                        }
                        _selectMode = true;
                        onCellMouseDown(_currentCell);
                        break;
                    case TouchPhase.ENDED:                                      // click
                        _selectMode = false;
                        break;
                    default :
                        if (_currentObject) {
                            _currentObject.x = _currentCell.x;
                            _currentObject.y = _currentCell.y;
                        }
                }

                if (_selectMode) {
                    if (uiController.mode == UIControllerMode.EDIT_OBJECTS) {
                        editObjects();
                    }
                    else if (uiController.mode == UIControllerMode.EDIT_PATHS) {
                        editPaths();
                    }
                    else if (uiController.mode == UIControllerMode.EDIT_DEFENDER_POSITIONS) {
                        editDefenderPositions();
                    }
                    else if (uiController.mode == UIControllerMode.EDIT_GENERATORS) {
                        uiController.setGeneratorPosition (new Point (_currentCell.positionX, _currentCell.positionY));
                    }
                    onCellClick(_currentCell);
                }
            }
        } else {
            _isRolledOver = false;

            onCellRollOut(getCellViewByPosition(_lastCellX, _lastCellY));
        }
    }

    private function editObjects():void {
        if (_currentObject) {
            var place:PlaceData = new PlaceData();
            place.place(_currentCell.positionX, _currentCell.positionY);
            place.object = _currentObject.object.name;
            place.realObject = _currentObject.object;

            if (uiController.addObject(place)) {
                if (_shift) {
                    addObject(_currentObject.object);
                } else {
//                    addObject(null);
                    uiController.selectCurrentObject(null);
                }
            }
        } else {
            uiController.selectObject(_currentCell.positionX, _currentCell.positionY);
        }
    }

    private function editPaths():void {
        var points: Vector.<Point> = new <Point>[];
        points.push(new Point (_currentCell.positionX, _currentCell.positionY));
        if (uiController.editPathAreaMode) {
            if (firstSelectedPointForEditingPath) {
                //добавляем все точки, в области, лежащей между двумя выделеными точками:
                var startPositionX: int = Math.min(_currentCell.positionX, firstSelectedPointForEditingPath.x);
                var startPositionY: int = Math.min(_currentCell.positionY, firstSelectedPointForEditingPath.y);
                var endPositionX: int = Math.max(_currentCell.positionX, firstSelectedPointForEditingPath.x);
                var endPositionY: int = Math.max(_currentCell.positionY, firstSelectedPointForEditingPath.y);
                for (var i: int = startPositionX; i <= endPositionX; i++) {
                    for (var j: int = startPositionY; j <= endPositionY; j++) {
                        points.push(new Point (i, j));
                    }
                }
                //очищаем данные о первой выделеной точке:
                firstSelectedPointForEditingPath = null;
            }
            else {
                //добавляем данные о первой выделеной точке:
                firstSelectedPointForEditingPath = new Point (_currentCell.positionX, _currentCell.positionY);
            }
        }
        uiController.editPointToCurrentPath (points);
    }

    private function editDefenderPositions():void {
        if (uiController.editDefenderPositionsMode == EditMode.SET_POINT) {
            uiController.setPositionOfCurrentDefenderPosition(new Point(_currentCell.positionX, _currentCell.positionY));
        }
        else {
            var points: Vector.<Point> = new <Point>[];
            points.push(new Point (_currentCell.positionX, _currentCell.positionY));
            if (uiController.editDefenderZonesAreaMode) {
                if (firstSelectedPointForEditingDefenderZones) {
                    //добавляем все точки, в области, лежащей между двумя выделеными точками:
                    var startPositionX: int = Math.min(_currentCell.positionX, firstSelectedPointForEditingDefenderZones.x);
                    var startPositionY: int = Math.min(_currentCell.positionY, firstSelectedPointForEditingDefenderZones.y);
                    var endPositionX: int = Math.max(_currentCell.positionX, firstSelectedPointForEditingDefenderZones.x);
                    var endPositionY: int = Math.max(_currentCell.positionY, firstSelectedPointForEditingDefenderZones.y);
                    for (var i: int = startPositionX; i <= endPositionX; i++) {
                        for (var j: int = startPositionY; j <= endPositionY; j++) {
                            points.push(new Point (i, j));
                        }
                    }
                    //очищаем данные о первой выделеной точке:
                    firstSelectedPointForEditingDefenderZones = null;
                }
                else {
                    //добавляем данные о первой выделеной точке:
                    firstSelectedPointForEditingDefenderZones = new Point (_currentCell.positionX, _currentCell.positionY);
                }
            }
            uiController.editPointsToCurrentDefenderPosition (points);
        }
    }

    private function onCellRollOver(cellView:CellView):void {
        if (cellView) {
//            cellView.onRollOver();
            uiController.showCellInfo(cellView.cell);
        }
    }

    private function onCellRollOut(cellView:CellView):void {
        if (cellView) {
//            cellView.onRollOut();
        }
    }

    private function onCellMouseDown(cellView:CellView):void {
        if (cellView) {
//            cellView.onMouseDown();
        }
    }

    private function onCellClick(cellView:CellView):void {
        if (cellView) {
//            cellView.onClick();
        }
    }

    private function getPositionByTouchEvent(touch:Touch):Point {
        var point:Point;
        if (touch) {
            var pos:Point = touch.getLocation(_cellsContainer).add(new Point(PositionView.cellWidth * 0.5, PositionView.cellHeight * 0.5));
            var tx:Number = pos.x / PositionView.cellWidth;
            var ty:Number = pos.y / PositionView.cellHeight;
            var cx:int = Math.round(ty - tx);
            var cy:int = Math.round(cx + tx * 2);
            point = new Point(cx, cy);
        }
        return point;
    }

    private function handleKeyDown($event:KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.ESCAPE:
            case Keyboard.DELETE:
//                addObject(null);
                uiController.selectCurrentObject(null);
                break;
            case Keyboard.SHIFT:
                _shift = true;
                break;
        }
    }

    private function handleKeyUp($event:KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.SHIFT:
                _shift = false;
                break;
        }
    }

    private function handleDestroy($event:Event):void {
        var obj:PositionView = $event.target as PositionView;
        obj.destroy();
        obj.removeFromParent(true);
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    private function selectObjectListener(event:SelectObjectEvent):void {
        addObject(event.objectData);
    }

    private function selectObjectsTypeListener(event:SelectObjectsTypeEvent):void {
        _objectsContainer.visible = event.objectsType != ObjectType.ENEMY;
//        addObject(null);
        uiController.selectCurrentObject(null);
    }

    private function backgroundWasChangedListener(event:EditBackgroundEvent):void {
        var objectData:ObjectData = event.objectData;
        if (objectData.type == ObjectType.BACKGROUND) {
            if (_field.levelData) {
                if (!_bg) {
                    _bg = new Image(_assets.getTexture(_field.levelData.bg));
                    _bg.touchable = false;
                    addChildAt(_bg, 0);
                }
                _bg.texture = _assets.getTexture(_field.levelData.bg);
            }
        }
    }

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    private function selectPathListener(event:SelectPathEvent):void {
        redrawPaths(event.pathData);
    }

    /////////////////////////////////////////////
    //GENERATORS:
    /////////////////////////////////////////////

    private function selectGeneratorListener(event:SelectGeneratorEvent):void {
        //очищаем все клетки:
        clearAllCells (true, true, true);
        var generatorData:GeneratorData = event.generatorData;
        var levelData:LevelData = _field.levelData;
        if (generatorData && levelData) {
            var pathData:PathData = levelData.getPathDataById(generatorData.pathId);
            if (pathData) {
                _cellsContainer.unflatten();
                //рисуем путь для текущего выбраного генератора:
                drawPath(pathData);
                //показываем подсветку (штриховку) для всех генераторов:
                var numGenerators:int = levelData.generators.length;
                for (var i:int = 0; i < numGenerators; i++) {
                    var generatorDataForHatching:GeneratorData = levelData.generators [i];
                    var cellViewForHatching:CellView = getCellViewByPosition (generatorDataForHatching.x, generatorDataForHatching.y);
                    if (cellViewForHatching) {
                        cellViewForHatching.showHatching = true;
                    }
                }
                //рисуем флаг в позиции текущего выбраного генератора:
                var cellView:CellView = getCellViewByPosition (generatorData.x, generatorData.y);
                if (cellView) {
                    cellView.showFlag = true;
                }
                _cellsContainer.flatten();
            }
        }
    }

    private function selectDefenderPositionListener(event:SelectDefenderPositionEvent):void {
        redrawDefenderPositions(event.defenderPositionData);
    }

    /////////////////////////////////////////////
    //OTHER:
    /////////////////////////////////////////////

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
//        addObject(null);
        uiController.selectCurrentObject(null);
        clearAllCells(true, true, true);
        _objectsContainer.visible = false;
        switch (event.mode) {
            case UIControllerMode.EDIT_OBJECTS:
                redrawPaths(null);
                _objectsContainer.visible = true;
                break;
            case UIControllerMode.EDIT_PATHS:
                //
                break;
            case UIControllerMode.EDIT_GENERATORS:
                //
                break;
            case UIControllerMode.EDIT_DEFENDER_POSITIONS:
                redrawPaths(null);
                redrawDefenderPositions(null);
                break;
        }
    }

    private function selectEditPathModeListener(event:SelectEditPathModeEvent):void {
        firstSelectedPointForEditingPath = null;
    }

    private function selectEditDefenderPositionModeListener(event:SelectEditDefenderPositionModeEvent):void {
        firstSelectedPointForEditingDefenderZones = null;
    }
}
}
