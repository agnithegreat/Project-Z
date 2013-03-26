/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 26.03.13
 * Time: 16:17
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.objectEditor.data {
import flash.filesystem.File;

public class DefenderData extends ObjectData {

    override public function get mask():Array {
        if (!_mask) {
            _mask = [[1]];
        }
        return _mask;
    }

    // Цена. Количество припасов, которые должен потратить игрок, чтобы поставить данного защитника на карте.
    private var _cost: int;
    public function get cost():int {
        return _cost;
    }

    // Сила. Количество повреждений, наносимых при выстреле\ударе.
    private var _strength: int;
    public function get strength():int {
        return _strength;
    }

    // Радиус атаки. Определяет область, в пределах которой защитник может атаковать.
    private var _radius: int;
    public function get radius():int {
        return _radius;
    }

    // Мощность атаки. При установке в 0, повреждения получает только атакуемый противник. При 1 - все противники, стоящие в одной клетке с атакуемым.
    private var _power: int;
    public function get power():int {
        return _power;
    }

    // Время между ударами\выстрелами.
    private var _cooldown: int;
    public function get cooldown():int {
        return _cooldown;
    }

    // Количество выстрелов до перезарядки.
    private var _ammo: int;
    public function get ammo():int {
        return _ammo;
    }

    // Защита. Количество повреждений, наносимых противнику при выстреле\ударе в единицу времени.
    private var _defence: int;
    public function get defence():int {
        return _defence;
    }

    // TODO: добавить зону эффектов для боссов

    public function DefenderData($name:String, $config:File = null) {
        super($name, $config);
    }

    override public function parse($data: Object):void {
        super.parse($data);

        _cost = $data.cost;
        _radius = $data.radius;
        _strength = $data.strength;
        _power = $data.power;
        _cooldown = $data.cooldown;
        _ammo = $data.ammo;
        _defence = $data.defence;
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
