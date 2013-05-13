/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.05.13
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data.events {

import com.projectz.utils.objectEditor.data.EnemyData;

import starling.events.Event;

/**
 * Событие, отправляемое при изменении данных в объекте EnemyData.
 *
 * @see com.projectz.utils.objectEditor.data.EnemyData
 */
public class EditEnemyDataEvent extends Event {

    private var _enemyData:EnemyData;

    public static const ENEMY_DATA_WAS_CHANGED:String = "enemy data was changed";

    public function EditEnemyDataEvent(enemyData:EnemyData, type:String = ENEMY_DATA_WAS_CHANGED, bubbles:Boolean = false) {
        this.enemyData = enemyData;
        super(type, bubbles, enemyData);
    }

    public function get enemyData():EnemyData {
        return _enemyData;
    }

    public function set enemyData(value:EnemyData):void {
        _enemyData = value;
    }
}
}
