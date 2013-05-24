/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 26.03.13
 * Time: 16:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import com.projectz.utils.objectEditor.data.events.EditDefenderDataEvent;

import flash.filesystem.File;

/**
 * Класс для хранения данных о защитнике.
 */
public class DefenderData extends ObjectData {

    override public function get mask():Array {
        if (!_mask) {
            _mask = [[1]];
        }
        return _mask;
    }

    private var _cost: int;
    /**
     * Цена. Количество припасов, которые должен потратить игрок, чтобы поставить данного защитника на карте.
     */
    public function get cost():int {
        return _cost;
    }

    public function set cost(value:int):void {
        _cost = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    private var _strength: int;
    /**
     * Сила. Количество повреждений, наносимых при выстреле\ударе.
     */
    public function get strength():int {
        return _strength;
    }

    public function set strength(value:int):void {
        _strength = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    private var _radius: int;
    /**
     * Радиус атаки. Определяет область, в пределах которой защитник может атаковать.
     */
    public function get radius():int {
        return _radius;
    }

    public function set radius(value:int):void {
        _radius = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    //
    private var _power: int;
    /**
     * Мощность атаки.
     * При установке в 0, повреждения получает только атакуемый противник.
     * При 1 - все противники, стоящие в одной клетке с атакуемым.
     */
    public function get power():int {
        return _power;
    }

    public function set power(value:int):void {
        _power = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    private var _cooldown: int;
    /**
     * Время между ударами\выстрелами.
     */
    public function get cooldown():int {
        return _cooldown;
    }

    public function set cooldown(value:int):void {
        _cooldown = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    private var _ammo: int;
    /**
     * Количество выстрелов до перезарядки.
     */
    public function get ammo():int {
        return _ammo;
    }

    public function set ammo(value:int):void {
        _ammo = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    private var _defence: int;
    /**
     * Защита. Количество повреждений, наносимых противнику при выстреле\ударе в единицу времени.
     */
    public function get defence():int {
        return _defence;
    }

    public function set defence(value:int):void {
        _defence = value;
        dispatchEvent(new EditDefenderDataEvent(this));
    }

    public function DefenderData($name:String, $config:File = null) {
        super($name, $config);
    }

    override public function parse($data: Object):void {
        super.parse($data);

        _cost = $data.hasOwnProperty ("cost") ? $data.cost : 10;
        _radius = $data.hasOwnProperty ("radius") ? $data.radius : 4;
        _strength = $data.hasOwnProperty ("strength") ? $data.strength : 25;
        _power = $data.hasOwnProperty ("power") ? $data.power : 1;
        _cooldown = $data.hasOwnProperty ("cooldown") ? $data.cooldown : 25;
        _ammo = $data.hasOwnProperty ("ammo") ? $data.ammo : 5;
        _defence = $data.hasOwnProperty ("defence") ? $data.defence : 10;
    }

    override public function export():Object {
        var obj: Object = super.export();
        obj.cost = _cost;
        obj.radius = _radius;
        obj.strength = _strength;
        obj.power = _power;
        obj.cooldown = _cooldown;
        obj.ammo = _ammo;
        obj.defence = _defence;
        return obj;
    }

}
}
