package com.projectz.utils.pathFinding {
	
	/**
	 * @author agnithegreat
	 */
	public class Grid {
		
		private var _startNode: Node;
		public function get startNode():Node {
			return _startNode;
		}
		
		private var _endNode: Node;
		public function get endNode():Node {
			return _endNode;
		}
		
		private var _nodes: Array;
		
		private var _numCols: int;
		public function get numCols():int {
			return _numCols;
		}
		
		private var _numRows: int;
		public function get numRows():int {
			return _numRows;
		}
		
		public function Grid($cols: int, $rows: int) {
			_numCols = $cols;
			_numRows = $rows;
			
			_nodes = [];
			for(var i:int = 0; i < _numCols; i++) {
				_nodes[i] = new Array();
				for(var j:int = 0; j < _numRows; j++) {
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		public function getNode(x:int, y:int):Node {
			return _nodes[x][y] as Node;
		}
		
		public function setEndNode(x:int, y:int):void {
			_endNode = _nodes[x][y] as Node;
		}
		
		public function setStartNode(x:int, y:int):void {
			_startNode = _nodes[x][y] as Node;
		}
		
		public function setWalkable(x:int, y:int, value: Boolean):void {
			(_nodes[x][y] as Node).walkable = value;
		}

        public function setPath(x:int, y:int, path: int):void {
            (_nodes[x][y] as Node).paths[path] = path;
        }

        public function destroy():void {
            _startNode = null;
            _endNode = null;

            var node: Node;
            for(var i:int = 0; i < _numCols; i++) {
                for(var j:int = 0; j < _numRows; j++) {
                    node = _nodes[i][j];
                    node.destroy();
                }
                _nodes[i] = null;
            }
            _nodes = null;
        }
	}
}
