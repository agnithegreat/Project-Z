/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 04.03.13
 * Time: 0:55
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.view {

import com.projectz.game.event.GameEvent;
import com.projectz.utils.levelEditor.controller.EditingMode;
import com.projectz.utils.levelEditor.controller.UIController;
import com.projectz.utils.levelEditor.controller.UIControllerMode;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEditionModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editAssets.SelectAssetPartEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editDefenrerZones.SelectDefenderPositionEditingModeEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editGenerators.SelectGeneratorEvent;
import com.projectz.utils.levelEditor.controller.events.uiController.editPaths.SelectPathEditingModeEvent;
import com.projectz.utils.levelEditor.data.DataUtils;
import com.projectz.utils.levelEditor.data.DefenderPositionData;
import com.projectz.utils.levelEditor.data.GeneratorData;
import com.projectz.utils.levelEditor.data.LevelData;
import com.projectz.utils.levelEditor.data.PathData;
import com.projectz.utils.levelEditor.data.PlaceData;
import com.projectz.utils.levelEditor.data.events.editLevels.EditLevelsEvent;
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
import com.projectz.utils.objectEditor.data.PartData;
import com.projectz.utils.objectEditor.view.FieldObjectView;

import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

public class FieldView extends Sprite {

    private var uiController:UIController;//Ссылка на контроллер (mvc).
    private var _field:Field;//Ссылка на модель (mvc).
    private var _assets:AssetManager;//Менеджер ассетов старлинга.

    //Основные контейнеры:
    private var _levelEditorContainer:Sprite;//Основной контейнер редактора уровней, содержащий контейнер поля, контейнер объектов и т.д.
    private var _editAssetsContainer:Sprite;//Контейнер для отображения редактируемых ассетов.

    //Элементы основного контейнера редактора уровней:
    private var _bg:Image;//Фоновая картинка.
    private var _cellsContainer:Sprite;//Контейнер поля, содержащий клетки.
    private var _cellsViewAsObject:Object = new Object();//Клетки поля в виде объекта. Ключом к клеткам служат их координаты в формате "x_y".
    private var _objectsContainer:Sprite;//Контейнер объектов на карте.
    private var _currentAddingObject:FieldObjectView;//Текущий объект для добавления на карту.
    private var _currentCell:CellView;//Текущая выделенная клетка.

    //Элементы контейнера для редактирования ассетов:
    private var _currentEditingAsset: FieldObjectView;//Текущий редактируемый ассет.

    //
    private var _shift:Boolean;//Параметр, указывающий, нажата ли клавиша shift.
    protected var _isMouseDownMode: Boolean;//Для отслеживания события MouseEvent.MOUSE_DOWN.
    protected var _isRolledOver:Boolean;//Для отслеживания события MouseEvent.ROLL_OVER.
    protected var _lastCellX:int;//Координата x последней выделенной клетки. Для отслеживания перехода в соседнюю клетку.
    protected var _lastCellY:int;//Координата y последней выделенной клетки. Для отслеживания перехода в соседнюю клетку.

    private var firstSelectedPointForEditingPath:Point;//используется при
    //редактировании пути методом редактирования областей по двум точкам.
    //Хранит информацию о первой выбраной точке.

    private var firstSelectedPointForEditingDefenderZones:Point;//используется при
    //редактировании зон защитников методом редактирования областей по двум точкам.
    //Хранит информацию о первой выбраной точке.

    /**
     *
     * @param $field Ссылка на модель (mvc).
     * @param $assets Менеджер ассетов старлинга.
     * @param uiController Ссылка на контроллер (mvc).
     */
    public function FieldView($field:Field, $assets:AssetManager, uiController:UIController) {
        _assets = $assets;

        this.uiController = uiController;
        uiController.addEventListener(SelectObjectEvent.SELECT_OBJECT, selectObjectListener);
        uiController.addEventListener(SelectObjectsTypeEvent.SELECT_OBJECTS_TYPE, selectObjectsTypeListener);
        uiController.addEventListener(SelectUIControllerModeEvent.SELECT_UI_CONTROLLER_MODE, selectUIControllerModeListener);
        uiController.addEventListener(SelectPathEditingModeEvent.SELECT_PATH_EDITING_MODE, selectPathEditingModeListener);
        uiController.addEventListener(SelectDefenderPositionEditingModeEvent.SELECT_DEFENDER_POSITION_EDITING_MODE, selectDefenderPositionEditingModeListener);
        uiController.addEventListener(SelectPathEvent.SELECT_PATH, selectPathListener);
        uiController.addEventListener(SelectGeneratorEvent.SELECT_GENERATOR, selectGeneratorListener);
        uiController.addEventListener(SelectDefenderPositionEvent.SELECT_DEFENDER_POSITION, selectDefenderPositionListener);
        uiController.addEventListener(SelectAssetEvent.SELECT_ASSET, selectAssetListener);
        uiController.addEventListener(SelectAssetPartEvent.SELECT_ASSET_PART, selectAssetPartListener);
        uiController.addEventListener(SelectAssetEditionModeEvent.SELECT_ASSET_EDITING_MODE, selectAssetEditionModeListener);

        _field = $field;
        _field.addEventListener(EditBackgroundEvent.BACKGROUND_WAS_CHANGED, backgroundWasChangedListener);
        _field.addEventListener(GameEvent.UPDATE, updateListener);
        _field.addEventListener(EditObjectEvent.FIELD_OBJECT_WAS_ADDED, objectWasAddedListener);
        _field.addEventListener(EditObjectEvent.FIELD_OBJECT_WAS_REMOVED, objectWasRemovedListener);
        _field.addEventListener(EditPlaceEvent.PLACE_WAS_CHANGED, placeWasChangedListener);
        _field.addEventListener(EditPathEvent.PATH_WAS_CHANGED, pathWasChangedListener);
        _field.addEventListener(EditPathEvent.PATH_COLOR_WAS_CHANGED, pathWasChangedListener);
        _field.addEventListener(EditDefenderPositionEvent.DEFENDER_POSITION_WAS_CHANGED, defenderPositionWasChangedListener);
        _field.addEventListener(EditLevelsEvent.SET_LEVEL, setLevelListener);

        //Создаём основной контейнер редактора уровней:
        _levelEditorContainer = new Sprite();
        _levelEditorContainer.x = (Constants.WIDTH + PositionView.cellWidth) * 0.5;
        _levelEditorContainer.y = (Constants.HEIGHT + (1 - (_field.height + _field.height) * 0.5) * PositionView.cellHeight) * 0.5;
        addChild(_levelEditorContainer);

        //Создаём контейнер поля:
        _cellsContainer = new Sprite();
        _cellsContainer.touchable = false;
        _levelEditorContainer.addChild(_cellsContainer);

        //Создаём клетки поля в контейнере поля:
        var len:int = _field.field.length;
        var cellView:CellView;
        for (var i:int = 0; i < len; i++) {
            cellView = new CellView(
                    _field.field[i],
                    $assets.getTexture("ms-cell-levelEditor"),//Текстура для клетки редактора уровней.
                    $assets.getTexture("ms-cell-levelEditor-lock"),//Текстура для значка блокировки.
                    $assets.getTexture("ms-cell-levelEditor-flag"),//Текстура для значка флага.
                    $assets.getTexture("ms-cell-levelEditor-hatching")//Текстура для штриховки.
            );
            _cellsContainer.addChild(cellView);
            _cellsViewAsObject[cellView.positionX + "_" + cellView.positionY] = cellView;//Добавление клетки в объект-хранилище для клеток.
        }
        _cellsContainer.flatten();

        //Создаём контейнер объектов:
        _objectsContainer = new Sprite();
        _objectsContainer.touchable = false;
        _levelEditorContainer.addChild(_objectsContainer);

        //Создаём контейнер редактирования ассетов:
        _editAssetsContainer = new Sprite();
        addChild(_editAssetsContainer);

        //Добавляем слушатели:
        addEventListener(GameEvent.DESTROY, handleDestroy);
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /**
     * Деактивация.
     */
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

        _levelEditorContainer = null;
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

    /**
     * Установка текущего объекта для добавления на карту.
     * @param $data Объект для добавления на карту.
     */
    private function setCurrentAddingObject($data:ObjectData):void {
        if (_currentAddingObject) {
            _currentAddingObject.destroy();
            _currentAddingObject.removeFromParent(true);
            _currentAddingObject = null;
        }

        if ($data) {
            _currentAddingObject = new FieldObjectView($data, _assets);
            _levelEditorContainer.addChild(_currentAddingObject);

            if (_currentCell) {
                _currentAddingObject.x = _currentCell.x;
                _currentAddingObject.y = _currentCell.y;
            }
        }

        _objectsContainer.alpha = _currentAddingObject ? 0.5 : 1;
    }

    /**
     * Установка текущего ассета для редактирования.
     * @param _objectData Ассет для редактирования.
     */
    private function setCurrentEditingAsset (_objectData:ObjectData):void {
        if (_currentEditingAsset) {
            _currentEditingAsset.destroy();
            _currentEditingAsset.removeFromParent(true);
            _currentEditingAsset = null;
        }

        _currentEditingAsset = new FieldObjectView(_objectData, _assets);
        _currentEditingAsset.editShotableMode = uiController.editAssetShotableMode;
        _currentEditingAsset.editWalkableMode = uiController.editAssetWalkableMode;
        _currentEditingAsset.x = (Constants.WIDTH - 200 + PositionView.cellWidth) / 2;
        _currentEditingAsset.y = (Constants.HEIGHT + 200 + (1 - (_objectData.height + _objectData.width) / 2) * PositionView.cellHeight) / 2;
        _editAssetsContainer.addChild(_currentEditingAsset);
    }

    /**
     * Обновление игрового состояния. Сортировка всех объектов по глубине.
     */
    private function update():void {
        _objectsContainer.sortChildren(sortByDepth);
    }

    /**
     * Аглоритм сортировки по глубине.
     * @param $child1
     * @param $child2
     * @return
     */
    private function sortByDepth($child1:PositionView, $child2:PositionView):int {
        if ($child1.depth > $child2.depth) {
            return 1;
        } else if ($child1.depth < $child2.depth) {
            return -1;
        }
        return 0;
    }

    /**
     * Получение клетки поля по координатам.
     * @param $x Координата <code>x</code>.
     * @param $y Координата <code>y</code>.
     * @return Клетка поля.
     */
    private function getCellViewByPosition($x:int, $y:int):CellView {
        var cellView:CellView = _cellsViewAsObject[$x + "_" + $y];
//        if (!cellView) {
//            trace("ищем перебором");
//            for (var i:int = 0; i < _cellsContainer.numChildren; i++) {
//                var _cellView:CellView = CellView(_cellsContainer.getChildAt(i));
//                if ((_cellView.positionX == $x) && (_cellView.positionY == $y)) {
//                    cellView = _cellView;
//                    break;
//                }
//            }
//        }
        return cellView;
    }

    /**
     * Выделение соответствующим цветом пути всех клеток, которые занимают пути и
     * выделение штриховкой указанного пути.
     * @param pathData Путь для выделения штриховкой.
     */
    private function redrawPaths (pathData:PathData):void {
//        _cellsContainer.unflatten();
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
//        _cellsContainer.flatten();
        updateCellsContainerView();
    }

    /**
     * Выделение цветом пути всех клеток, которые занимает путь.
     * @param pathData Путь.
     * @param showHatching Применение штриховки.
     */
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

    /**
     * Выделение штриховкой всех клеток, которые занимают зоны защитников,
     * и выделение усиленной штриховкой указанной зоны защитников.
     * @param currentDefenderPositionData Зона защитников для выделения усиленной штриховкой.
     */
    private function redrawDefenderPositions (currentDefenderPositionData:DefenderPositionData):void {
        clearAllCells(false, true, true);
        var levelData:LevelData = _field.levelData;
        if (levelData) {
//            _cellsContainer.unflatten();
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
//            _cellsContainer.flatten();
        }
        updateCellsContainerView();
    }

    /**
     * Выделение штриховкой всех клеток, которые занимает зона защитника.
     * @param defenderPositionData Зона защитника.
     * @param showExtraHatching Применение усиленной штриховки.
     */
    private function drawDefenderPosition (defenderPositionData:DefenderPositionData, showExtraHatching:Boolean = false):void {
        if (defenderPositionData) {
//            _cellsContainer.unflatten();
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
//            _cellsContainer.flatten();
        }
    }

    /**
     * Удаление у всех клеток поля указанных значков.
     * @param clearColor Очистка цвета (цвет всех клеток становится белым).
     * @param clearFlag Удаление значка флага у всех клеток поля.
     * @param clearHatching Удаление штриховки у всех клеток поля.
     * @param clearLock Удаление значка блокировки у всех клеток поля.
     */
    private function clearAllCells (clearColor:Boolean = true, clearFlag:Boolean = true, clearHatching:Boolean = true, clearLock:Boolean = false):void {
//        _cellsContainer.unflatten();
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
//        _cellsContainer.flatten();
    }

    private function clearAllObjects ():void {
        while (_objectsContainer.numChildren > 0) {
            var child:DisplayObject = _objectsContainer.getChildAt(0);
            _objectsContainer.removeChild(child);
        }
    }

    /**
     * Редактирование объектов.
     */
    private function editObjects():void {
        if (_currentAddingObject) {
            var place:PlaceData = new PlaceData();
            place.place(_currentCell.positionX, _currentCell.positionY);
            place.object = _currentAddingObject.object.name;
            place.realObject = _currentAddingObject.object;

            if (uiController.addObject(place)) {
                if (_shift) {
                    setCurrentAddingObject(_currentAddingObject.object);
                } else {
                    uiController.selectCurrentEditingObject(null);
                }
            }
        } else {
            uiController.selectAndRemoveObject(_currentCell.positionX, _currentCell.positionY);
        }
    }

    /**
     * Реадактирование путей.
     */
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

    /**
     * Редактирование зон защитников.
     */
    private function editDefenderPositions():void {
        if (uiController.editDefenderPositionsMode == EditingMode.SET_POINT) {
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

    /**
     * Получение позиции (точки) по событию точа.
     * @param touch
     * @return Позиция на игровом поле.
     */
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

    /**
     * Обновление отображения контейнера поля.
     * Метод помогает оптимизировать работу редактора.
     * В обычном состоянии к контейнеру поля применяется flatten().
     * Этот метод времено снимает flatten() и отображает клетки, как отдельные объекты.
     */
    private function updateCellsContainerView ():void {
        _cellsContainer.unflatten();
        var numCells:int = _cellsContainer.numChildren;
        for (var i:int = 0; i < numCells; i++) {
            var cellView:CellView = CellView (_cellsContainer.getChildAt(i));
            cellView.updateView();
        }
        _cellsContainer.flatten();
    }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

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
                        if (_isMouseDownMode) {
                            return;
                        }
                        _isMouseDownMode = true;
                        onCellMouseDown(_currentCell);
                        break;
                    case TouchPhase.ENDED:                                      // click
                        _isMouseDownMode = false;
                        break;
                    default :
                        if (_currentAddingObject) {
                            _currentAddingObject.x = _currentCell.x;
                            _currentAddingObject.y = _currentCell.y;
                        }
                }

                if (_isMouseDownMode) {
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
            _currentCell = null;
            onCellRollOut(getCellViewByPosition(_lastCellX, _lastCellY));
        }
    }

    private function handleAddedToStage($event:Event):void {
        stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
    }

    private function handleKeyDown($event:KeyboardEvent):void {
        switch ($event.keyCode) {
            case Keyboard.ESCAPE:
            case Keyboard.DELETE:
                uiController.selectCurrentEditingObject(null);
                break;
            case Keyboard.SHIFT:
                _shift = true;
                break;
        }
        if (_currentEditingAsset) {
            var toX:int = 0;
            var toY:int = 0;
            switch ($event.keyCode) {
                case Keyboard.LEFT:
                    toX = 1;
                    break;
                case Keyboard.RIGHT:
                    toX = -1;
                    break;
                case Keyboard.UP:
                    toY = 1;
                    break;
                case Keyboard.DOWN:
                    toY = -1;
                    break;
            }
            uiController.moveAsset (toX, toY);
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

    private function selectUIControllerModeListener(event:SelectUIControllerModeEvent):void {
        uiController.selectCurrentEditingObject(null);
        clearAllCells(true, true, true);
        _objectsContainer.visible = false;
        _levelEditorContainer.visible = true;
        _editAssetsContainer.visible = false;
        switch (event.mode) {
            case UIControllerMode.EDIT_OBJECTS:
            case UIControllerMode.EDIT_UNITS:
            case UIControllerMode.EDIT_LEVELS:
            case UIControllerMode.EDIT_SETTINGS:
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
            case UIControllerMode.EDIT_ASSETS:
                _levelEditorContainer.visible = false;
                _editAssetsContainer.visible = true;
                break;
        }
        updateCellsContainerView();
    }

    /**
     * Слушатель события обновления игры.
     */
    private function updateListener($event:Event):void {
        update();
    }

    /////////////////////////////////////////////
    //OBJECTS:
    /////////////////////////////////////////////

    /**
     * Слушатель события выбора объекта для добавления на карту.
     */
    private function selectObjectListener(event:SelectObjectEvent):void {
        setCurrentAddingObject(event.objectData);
    }

    /**
     * Слушатель события выбора типа объектов для добавления объекта на карту.
     */
    private function selectObjectsTypeListener(event:SelectObjectsTypeEvent):void {
        _objectsContainer.visible = event.objectsType != ObjectType.ENEMY;
        uiController.selectCurrentEditingObject(null);
    }

    /**
     * Слушатель события изменения фоновой картинки.
     */
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

    /**
     * Слушатель события изменения места на карте.
     */
    private function placeWasChangedListener($event:EditPlaceEvent):void {
        setCurrentAddingObject($event.objectData);
    }

    /**
     * Слушатель события добавления объекта на карту.
     */
    private function objectWasAddedListener($event:EditObjectEvent):void {
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

    /**
     * Слушатель события удаления объекта с карты.
     */
    private function objectWasRemovedListener($event:EditObjectEvent):void {
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

    /////////////////////////////////////////////
    //PATHS:
    /////////////////////////////////////////////

    /**
     * Слушатель события выбора пути для редактирования.
     */
    private function selectPathListener(event:SelectPathEvent):void {
        redrawPaths(event.pathData);
    }

    /**
     * Слушатель события изменения пути.
     */
    private function pathWasChangedListener($event:EditPathEvent):void {
        redrawPaths ($event.pathData);
    }

    /**
     * Слушатель события выбора режима редактирования путей.
     */
    private function selectPathEditingModeListener(event:SelectPathEditingModeEvent):void {
        firstSelectedPointForEditingPath = null;
    }

    /////////////////////////////////////////////
    //GENERATORS:
    /////////////////////////////////////////////

    /**
     * Слушатель события выбора генератора для редактирования.
     */
    private function selectGeneratorListener(event:SelectGeneratorEvent):void {
        //очищаем все клетки:
        clearAllCells (true, true, true);
        var generatorData:GeneratorData = event.generatorData;
        var levelData:LevelData = _field.levelData;
        if (generatorData && levelData) {
            var pathData:PathData = levelData.getPathDataById(generatorData.pathId);
            if (pathData) {
//                _cellsContainer.unflatten();
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
//                _cellsContainer.flatten();
            }
        }
        updateCellsContainerView();
    }

    /////////////////////////////////////////////
    //DEFENDER POSITIONS:
    /////////////////////////////////////////////

    /**
     * Слушатель события выбора зоны защитников для редактирования.
     */
    private function selectDefenderPositionListener(event:SelectDefenderPositionEvent):void {
        redrawDefenderPositions(event.defenderPositionData);
    }

    /**
     * Слушатель события изменения зоны защитников.
     */
    private function defenderPositionWasChangedListener($event:EditDefenderPositionEvent):void {
        redrawDefenderPositions($event.defenderPositionData);
    }
    /**
     * Слушатель события выбора режима редактирования зон защитников.
     */
    private function selectDefenderPositionEditingModeListener(event:SelectDefenderPositionEditingModeEvent):void {
        firstSelectedPointForEditingDefenderZones = null;
    }

    /////////////////////////////////////////////
    //LEVELS:
    /////////////////////////////////////////////

    /**
     * Слушатель события выбора текущего уровня.
     */
    private function setLevelListener($event:EditLevelsEvent):void {
        clearAllCells(true, true, true, true);
        updateCellsContainerView();
        clearAllObjects ();
    }

    /////////////////////////////////////////////
    //ASSETS:
    /////////////////////////////////////////////

    private function selectAssetListener (event:SelectAssetEvent):void {
        setCurrentEditingAsset(event.objectData);
    }

    private function selectAssetPartListener (event:SelectAssetPartEvent):void {
        if (_currentEditingAsset) {
            _currentEditingAsset.showPart(event.partData);
        }
    }

    private function selectAssetEditionModeListener (event:SelectAssetEditionModeEvent):void {
        if (_currentEditingAsset) {
            _currentEditingAsset.editShotableMode = uiController.editAssetShotableMode;
            _currentEditingAsset.editWalkableMode = uiController.editAssetWalkableMode;
        }
    }

}
}
