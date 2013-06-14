/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 12:48
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.popups {

import com.hogargames.errors.SingletonError;
import com.projectz.game.App;
import com.projectz.app.ui.popups.events.PopUpEvent;

import starling.events.Event;

public class PopUpManager {

    private static var _instance:PopUpManager;

    public var screenPopUp:ScreenPopUp;

    private var nextScreenId:String;

    private var allPopUps:Vector.<BasicPopUp>;

    public function PopUpManager (key:SingletonKey = null) {
        if (!key) {
            throw new SingletonError();
        }
        //Создаём все попапы:
        screenPopUp = new ScreenPopUp ();

        //Добавляем все попапы в вектор-хранилище.
        allPopUps = new Vector.<BasicPopUp>();
        allPopUps.push (screenPopUp);

        //add listeners:
        screenPopUp.addEventListener (PopUpEvent.OPEN, openScreenPopUpListener);
    }

    public static function getInstance ():PopUpManager {
        if (!_instance) {
            _instance = new PopUpManager (new SingletonKey ());
        }
        return _instance;
    }

    public function openScreen (nextScreenId:String):void {
        this.nextScreenId = nextScreenId;
        screenPopUp.open ();
    }

    public function closeAllPopUps (exceptPopUp:BasicPopUp = null):void {
        for (var i:int = 0; i < allPopUps.length; i++) {
            var popUp:BasicPopUp = allPopUps [i];
            if (popUp != exceptPopUp) {
                if (popUp.isShowed) {
                    allPopUps [i].close ();
                }
            }
        }
    }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function openScreenPopUpListener (event:Event):void {
            App.openScreen (nextScreenId);
            screenPopUp.close ();
        }



}
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
