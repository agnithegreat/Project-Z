package com.projectz.utils.pathFinding {
	
	/**
	 * @author agnithegreat
	 */
	public class Path {
		
		public var path: Vector.<Node>;
		
		public function get rate():int {
			return path[path.length-1].g;
		}
		
		public function Path() {
			path = new Vector.<Node>();
		}
	}
}
