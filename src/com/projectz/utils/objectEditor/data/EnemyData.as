/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 26.03.13
 * Time: 16:09
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {

import com.projectz.utils.objectEditor.data.events.EditEnemyDataEvent;

import flash.filesystem.File;

/**
 * Класс для хранения данных о враге.
 */
public class EnemyData extends ObjectData {

    override public function get mask():Array {
        if (!_mask) {
            _mask = [[1]];
        }
        return _mask;
    }

    private var _hp: int;
    /**
     * Количество жизней.
     */
    public function get hp():int {
        return _hp;
    }

    public function set hp(value:int):void {
        _hp = value;
        dispatchEvent(new EditEnemyDataEvent(this));
    }

    private var _speed: int;
    /**
     * Скорость передвижения. Для каждого вида противников свое значение.
     * Если будут позволять ресурсы, то по возможности реализовать скорость не по константному значению,
     * а по диапазону, (чтобы противники не ходили строем).
     */
    public function get speed():int {
        return _speed;
    }

    public function set speed(value:int):void {
        _speed = value;
        dispatchEvent(new EditEnemyDataEvent(this));
    }

    private var _strength: int;
    /**
     * Сила атаки.
     * Параметр показывает сколько единиц повреждений данный противник будет наносить цели атаки.
     */
    public function get strength():int {
        return _strength;
    }

    public function set strength(value:int):void {
        _strength = value;
        dispatchEvent(new EditEnemyDataEvent(this));
    }

    private var _cooldown: int;
    /**
     * Время между ударами.
     */
    public function get cooldown():int {
        return _cooldown;
    }

    public function set cooldown(value:int):void {
        _cooldown = value;
        dispatchEvent(new EditEnemyDataEvent(this));
    }

    // Выпадающие припасы. Список припасов, которые могут выпасть при уничтожении данного типа противника. Что конкретно выпадет выбирается случайным образом из списка.
    private var _reward: int;
    public function get reward():int {
        return _reward;
    }

    public function set reward(value:int):void {
        _reward = value;
        dispatchEvent(new EditEnemyDataEvent(this));
    }

    // TODO: добавить зону эффектов для боссов
    // Зона эффектов. Вокруг боса может быть зона, в пределах которой противники идут быстрее или становятся сильнее, живучей и прочее. См. Игровое поле, пути и зоны.

    public function EnemyData($name:String, $config:File = null) {
        super($name, $config);
    }

    override public function parse($data: Object):void {
        super.parse($data);

        _hp = $data.hp ? $data.hp : 100;
        _speed = $data.speed ? $data.speed : 1;
        _strength = $data.strength ? $data.strength : 1;
        _cooldown = $data.cooldown ? $data.cooldown : 25;
        _reward = $data.reward ? $data.reward : 100;
    }

    override public function export():Object {
        var obj: Object = super.export();
        obj.hp = _hp;
        obj.speed = _speed;
        obj.strength = _strength;
        obj.cooldown = _cooldown;
        obj.reward = _reward;
        return obj;
    }

}
}
