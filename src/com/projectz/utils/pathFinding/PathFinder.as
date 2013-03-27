package com.projectz.utils.pathFinding {

	/**
	 * @author agnithegreat
	 */
	public class PathFinder {
		
		private static var _open : Array;
		private static var _closed : Array;
		
		private static var _grid : Grid;
		public static function get grid():Grid {
			return _grid;
		}
		
		private static var _endNode : Node;
		private static var _startNode : Node;
		
		private static var _path : Path;
		
		// private static var _heuristic:Function = manhattan;
		// private static var _heuristic:Function = euclidian;
		private static var _heuristic : Function = diagonal;
		
		private static var _straightCost : Number = 1.0;
		private static var _diagCost : Number = Math.SQRT2;

		public static function findPath(grid : Grid, path: int = 0) : Path {
			_grid = grid;
			_open = new Array();
			_closed = new Array();

			_startNode = _grid.startNode;
			_endNode = _grid.endNode;

			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;

            search(path);
            buildPath();

			return _path;
		}

		private static function search(path: int = 0) : Boolean {
			var node : Node = _startNode;
			while (node != _endNode) {
				var startX : int = Math.max(0, node.x - 1);
				var endX : int = Math.min(_grid.numCols - 1, node.x + 1);
				var startY : int = Math.max(0, node.y - 1);
				var endY : int = Math.min(_grid.numRows - 1, node.y + 1);

				for (var i : int = startX; i <= endX; i++) {
					for (var j : int = startY; j <= endY; j++) {
						var test : Node = _grid.getNode(i, j);
                        if (test != _endNode) {
						    if (test == node || !test.getWalkable(path) || !_grid.getNode(node.x, test.y).walkable || !_grid.getNode(test.x, node.y).walkable) {
    							continue;
    						}
                        }

						var cost : Number = _straightCost;
						if (!((node.x == test.x) || (node.y == test.y))) {
							cost = _diagCost;
						}
						var g : Number = node.g + cost * test.costMultiplier;
						var h : Number = _heuristic(test);
						var f : Number = g + h;
						if (isOpen(test) || isClosed(test)) {
							if (test.f > f) {
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						} else {
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push(test);
						}
					}
				}
				_closed.push(node);
				if (_open.length == 0) {
					return false;
				}
				_open.sortOn("f", Array.NUMERIC);
				node = _open.shift() as Node;
			}
			return true;
		}

		private static function buildPath() : void {
			_path = new Path();
			var node : Node = _endNode;
			_path.path.push(node);
			while (node != _startNode) {
				node = node.parent;
				_path.path.unshift(node);
			}
		}

		private static function isOpen(node : Node) : Boolean {
			for (var i : int = 0; i < _open.length; i++) {
				if (_open[i] == node) {
					return true;
				}
			}
			return false;
		}

		private static function isClosed(node : Node) : Boolean {
			for (var i : int = 0; i < _closed.length; i++) {
				if (_closed[i] == node) {
					return true;
				}
			}
			return false;
		}

		private static function manhattan(node : Node) : Number {
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}

		private static function euclidian(node : Node) : Number {
			var dx : Number = node.x - _endNode.x;
			var dy : Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}

		private static function diagonal(node : Node) : Number {
			var dx : Number = Math.abs(node.x - _endNode.x);
			var dy : Number = Math.abs(node.y - _endNode.y);
			var diag : Number = Math.min(dx, dy);
			var straight : Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}

        private static function get visited() : Array {
			return _closed.concat(_open);
		}
	}
}
