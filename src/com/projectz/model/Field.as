/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 03.03.13
 * Time: 23:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.model {
import com.projectz.event.GameEvent;
import com.projectz.utils.pathFinding.Grid;
import com.projectz.utils.pathFinding.Path;
import com.projectz.utils.pathFinding.PathFinder;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    public static var CARS: int = 5;
    public static var TREES: int = 0;
    public static var ZOMBIES: int = 50;

    private var _width: int;
    public function get width():int {
        return _width;
    }

    private var _height: int;
    public function get height():int {
        return _height;
    }

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _grid: Grid;

    private var _zombies: Vector.<Zombie>;

    public function Field($width: int, $height: int) {
        _width = $width;
        _height = $height;

        _grid = new Grid(_width, _height);
    }

    public function init():void {
        createField();
        createObjects();
        createPersonages();
    }

    public function step($delta: Number):void {
        updateDepths();

        var len: int = _zombies.length;
        var zombie:Zombie;

        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            zombie = _zombies[i];
            if (zombie.alive && !zombie.target) {
                while (!cell || cell.locked) {
                    cell = getRandomCell();
                }
                zombie.walk(getWay(zombie.cell, cell));
                cell = null;
            }
            zombie.step($delta);
        }
        dispatchEventWith(GameEvent.UPDATE);
    }

    private function updateDepths():void {
        var len: int = _field.length;
        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            cell = _field[i];
            if (cell && cell.object) {
                cell.object.depth = 0;
                cell.object.clearSize();
            }
        }

        var index: int = 0;
        for (i = 0; i < _width+_height; i++) {
            for (var j:int = 0; j <= i; j++) {
                cell = getCell(i-j, j);
                if (cell && cell.object && !cell.object.depth) {
                    cell.object.markSize(cell.x, cell.y);
                    if (cell.object.sizeChecked) {
                        cell.object.depth = ++index;
                    }
                }
            }
        }
    }

    private function getWay($start: Cell, $end: Cell):Vector.<Cell> {
        var way: Vector.<Cell> = new <Cell>[];
        _grid.setStartNode($start.x, $start.y);
        _grid.setEndNode($end.x, $end.y);
        var path: Path = PathFinder.findPath(_grid);
        var len: int = path.path.length;
        for (var i:int = 1; i < len; i++) {
            way.push(getCell(path.path[i].x, path.path[i].y));
        }
        return way;
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};

        var cell: Cell;
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                if (i+j>0.4*_width && i+j<1.6*_width && Math.abs(i-j)<0.4*_height) {
                    cell = new Cell(i, j);
                    _field.push(cell);
                    _fieldObj[i+"."+j] = cell;
                }
            }
        }
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    private function getRandomCell():Cell {
        var rand: int = Math.random()*_field.length;
        return _field[rand];
    }

    private function createObjects():void {
        createCar(_width/2, _height/2);

        var cell: Cell;
        for (var i: int = 0; i < CARS; i++) {
//            while (!cell || cell.locked || cell.object) {
//                cell = getRandomCell();
//            }
//            createCar(cell.x, cell.y);
        }

        for (i = 0; i < TREES; i++) {
            while (!cell || cell.locked || cell.object) {
                cell = getRandomCell();
            }
            createTree(cell.x, cell.y);
        }
    }

    private function createHouse(x: int, y: int):void {
//        var house: House = new House([[1,1,1,1,1],[1,0,0,0,1],[1,0,2,0,1],[1,0,0,0,1],[1,1,0,1,1]]);
        var house: House = new House([[1,1,1],[1,1,1],[1,1,3]]);

        var cell: Cell;
        for (var i:int = 0; i < house.mask.length; i++) {
            for (var j:int = 0; j < house.mask[i].length; j++) {
                cell = getCell(x+i, y+j);
                if (cell) {
                    if (house.mask[i][j]==1 || house.mask[i][j]==3) {
                        cell.lock();
                        _grid.setWalkable(cell.x, cell.y, false);
                    }
                    cell.object = house;
                    if (house.mask[i][j]==2 || house.mask[i][j]==3) {
                        house.place(cell);
                    }
                }
            }
        }
    }

    private function createCar(x: int, y: int):void {
//        var house: House = new House([[1,1,1,1,1],[1,0,0,0,1],[1,0,2,0,1],[1,0,0,0,1],[1,1,0,1,1]]);
        var car: Car = new Car([[1,1],[1,1],[1,3]]);

        var cell: Cell;
        for (var i:int = 0; i < car.mask.length; i++) {
            for (var j:int = 0; j < car.mask[i].length; j++) {
                cell = getCell(x+i, y+j);
                if (cell) {
                    if (car.mask[i][j]==1 || car.mask[i][j]==3) {
                        cell.lock();
                        _grid.setWalkable(cell.x, cell.y, false);
                    }
                    cell.object = car;
                    if (car.mask[i][j]==2 || car.mask[i][j]==3) {
                        car.place(cell);
                    }
                }
            }
        }
    }

    private function createTree(x: int, y: int):void {
        var cell: Cell = getCell(x, y);
        if (cell) {
            var tree: Tree = new Tree();
            cell.lock();
            cell.object = tree;
            _grid.setWalkable(cell.x, cell.y, false);
            tree.place(cell);
        }
    }

    private function createPersonages():void {
        _zombies = new <Zombie>[];

        var zombie: Zombie;
        var cell: Cell;
        for (var i:int = 0; i < ZOMBIES; i++) {
            zombie = new Zombie();
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            cell.lock();
            cell.object = zombie;
            zombie.place(cell);
            cell = null;
            _zombies.push(zombie);
        }
    }

    public function destroy():void {
        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;

        for (var id: String in _fieldObj) {
            delete _fieldObj[id];
        }
        _fieldObj = null;

        _grid.destroy();
        _grid = null;

        while (_zombies.length>0) {
            _zombies.pop().destroy();
        }
        _zombies = null;
    }
}
}
