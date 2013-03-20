/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 18.03.13
 * Time: 10:15
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.utils.levelEditor.events {
import starling.events.Event;

public class LevelEditorEvent extends Event {

    public function LevelEditorEvent (type:String, bubbles:Boolean = false, data:Object = null):void {
        super (type, bubbles, data);
    }

    public static const REMOVE_ALL_OBJECTS: String = "remove_all_objects_GameEvent";

    public static const OBJECT_ADDED: String = "object_added_GameEvent";
    public static const SHADOW_ADDED: String = "shadow_added_GameEvent";
    public static const OBJECT_REMOVED: String = "object_removed_GameEvent";
    public static const ALL_OBJECTS_REMOVED: String = "all_objects_removed_GameEvent";
    public static const PLACE_ADDED: String = "place_added_GameEvent";

    public static const SELECT_EDITOR_MODE:String = "select mode";
    public static const SAVE:String = "save";
    public static const EXPORT:String = "export";

}
}
