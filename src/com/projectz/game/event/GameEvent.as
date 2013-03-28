/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 05.03.13
 * Time: 12:02
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.game.event {
public class GameEvent {

    public static const OBJECT_ADDED: String = "object_added_GameEvent";

    public static const CELL_WALK: String = "cell_walk_GameEvent";
    public static const CELL_POS: String = "cell_pos_GameEvent";
    public static const CELL_ATTACK: String = "cell_attack_GameEvent";
    public static const CELL_SIGHT: String = "cell_sight_GameEvent";

    public static const UPDATE: String = "update_GameEvent";
    public static const DAMAGE: String = "damage_GameEvent";
    public static const STATE: String = "state_GameEvent";
    public static const DESTROY: String = "destroy_GameEvent";

    public static const SHOW_EFFECT: String = "show_effect_GameEvent";
}
}
