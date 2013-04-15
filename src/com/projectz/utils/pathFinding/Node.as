package com.projectz.utils.pathFinding {
	import flash.geom.Point;
	
	/**
	 * @author agnithegreat
	 */
	public class Node extends Point {
		
		public var f:Number;
		public var g:Number;
		public var h:Number;

        public var paths: Object = {};
		public var walkable:Boolean = true;
        public var special: Boolean;
		
		public var parent:Node;
		
		public var costMultiplier: Number = 1;

		public function Node($x:int, $y:int) {
			super($x,$y);
		}

        public function getWalkable(path: int = 0):Boolean {
            return walkable && (!path || paths[path]);
        }

        public function destroy():void {
            parent = null;
        }
	}
}
