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

import flash.geom.Point;

import starling.events.EventDispatcher;

public class Field extends EventDispatcher {

    public static var TREES: int = 50;
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

    private var _personages: Vector.<Personage>;

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
        var len: int = _personages.length;
        var personage:Zombie;

        var cell: Cell;
        for (var i:int = 0; i < len; i++) {
            personage = _personages[i] as Zombie;
            if (personage) {
                if (!personage.target) {
                    while (!cell || cell.locked) {
                        cell = getRandomCell();
                    }
                    personage.walk(getWay(personage.cell, cell));
                    cell = null;
                }
                personage.step($delta);
            }
        }
        dispatchEventWith(GameEvent.UPDATE);
    }

    private function getWay($start: Cell, $end: Cell):Vector.<Cell> {
        var way: Vector.<Cell> = new <Cell>[];
        _grid.setStartNode($start.x, $start.y);
        _grid.setEndNode($end.x, $end.y);
        var path: Path = PathFinder.findPath(_grid);
        var len: int = path.path.length;
        for (var i:int = 0; i < len; i++) {
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
        createHouse(_width/2, _height/2);

        var cell: Cell;
        for (var i: int = 0; i < TREES; i++) {
            while (!cell || cell.locked) {
                cell = getRandomCell();
            }
            createTree(cell.x, cell.y);
        }
    }

    private function createHouse(x: int, y: int):void {
        var house: House = new House([[0,0,0],[0,1,0],[0,0,0]]);

        var cell: Cell;
        for (var i:int = 0; i < house.size.length; i++) {
            for (var j:int = 0; j < house.size[i].length; j++) {
                cell = getCell(x+i, y+j);
                if (cell) {
                    cell.lock();
                    _grid.setWalkable(cell.x, cell.y, false);
                    if (house.size[i][j]) {
                        cell.object = house;
                        house.place(cell);
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
        _personages = new <Personage>[];

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
            _personages.push(zombie);
        }
    }

    public function destroy():void {
        // TODO: destroy grid
        _grid = null;

        while (_field.length>0) {
            _field.pop().destroy();
        }
        _field = null;
    }
}
}
