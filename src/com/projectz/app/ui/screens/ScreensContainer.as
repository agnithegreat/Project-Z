/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 10:37
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

    /**
     * Класс для работы с экранами приложения.
     * В приложении всегда отображается лишь один экран.
     */
    public class ScreensContainer {

        private var container:DisplayObjectContainer;
        private var _currentScreen:IScreen;
        private var screens:Vector.<IScreen> = new Vector.<IScreen> ();

        /**
         * @param container Контейнер в котором отображаются экраны.
         */
        public function ScreensContainer (container:DisplayObjectContainer) {
            if (container == null) {
                throw new Error ("ScreensContainer has null container");
            }
            this.container = container;
        }

//////////////////////////////////
//PUBLIC:
//////////////////////////////////

        /**
         * Отображение экрана в контейнере. Скрытие остальных экранов.
         *
         * @param screen Экран для открытия.
         */
        public function open (screen:IScreen):void {
            if (!screen) {
                throw new Error ("Open null screen.");
            }
            //close other screens:
            for (var i:int = 0; i < screens.length; i++) {
                var currentScreen:IScreen = screens [i];
                if (screen != currentScreen) {
                    close (currentScreen);
                }
            }
            _currentScreen = screen;
            //open screen:
            register (screen);
            if (screen is DisplayObject) {
                container.addChild (DisplayObject (screen));
            }
            screen.onOpen ();
        }

        /**
         * Скрытие всех экранов контейнера.
         */
        public function closeAll ():void {
            for (var i:int = 0; i < screens.length; i++) {
                var currentScreen:IScreen = screens [i];
                close (currentScreen);
            }
        }

        /**
         * Текущий отображаемый экран приложения.
         */
        public function get currentScreen ():IScreen {
            return _currentScreen;
        }

//////////////////////////////////
//PRIVATE:
//////////////////////////////////

        private function close (screen:IScreen):void {
            //close current screen:
            if (screen is DisplayObject) {
                var screenAsDisplayObject:DisplayObject = DisplayObject (screen);
                if (container.contains (screenAsDisplayObject)) {
                    screen.onClose ();
                    container.removeChild (screenAsDisplayObject);
                }
            }
        }

        private function register (screen:IScreen):void {
            if (screens.indexOf (screen) == -1) {
                screens.push (screen);
            }
        }
    }
}
