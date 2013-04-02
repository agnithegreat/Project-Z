/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 01.04.13
 * Time: 15:45
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.ui.controls {

    import fl.controls.CheckBox;
    import fl.controls.listClasses.ICellRenderer;
    import fl.controls.listClasses.ListData;

    public class ProjectZCellRender extends CheckBox implements ICellRenderer {

        private var _listData:ListData;
        private var _data:Object;

        public function ProjectZCellRender() {

        }

        public function set data(data:Object):void {
            _data = data;
            label = data.label;
        }

        public function get data():Object {
            return _data;
        }

        public function set listData(listData:ListData):void {
            _listData = listData;
        }

        public function get listData():ListData {
            return _listData;
        }

        public override function set selected(val_bool:Boolean):void
        {


            _selected = val_bool
                super.selected = _selected ;



        }

        public override function get  selected():Boolean
        {
            return _selected ;


        }
    }
}