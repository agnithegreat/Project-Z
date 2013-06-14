/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 11:13
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {
import com.hogargames.errors.SingletonError;

/**
 * Класс для хранения экранов приложения.
 */
public class ScreensStorage {

    private static var _instance:ScreensStorage;

    private var screenStorage:Object = new Object ();

    public static const GAME_SCREEN:String = "game screen";
    public static const LEVEL_MENU_SCREEN:String = "level menu screen";

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

    /**
     * Получение экрана приложения по указанному id.
     * @param screenId
     * @return
     */
    public function getScreen (screenId:String):IScreen {
        var screen:IScreen = screenStorage [screenId];
        if (screen) {
            return screen;
        }
        else {
            throw new Error ('Screen "' + screenId + '" not found.');
        }
    }

    public function addScreen (screen:IScreen, screenId:String):void {
        screenStorage [screenId] = screen;
    }

}
}