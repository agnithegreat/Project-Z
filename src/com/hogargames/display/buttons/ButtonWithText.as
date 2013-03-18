/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 20.09.11
 * Time: 22:27
 */
package com.hogargames.display.buttons {

    import flash.display.MovieClip;
    import flash.text.TextField;

    /**
     * Базовая кнопка с текстом.
     */
    public class ButtonWithText extends Button {

        private var tf:TextField;

        public function ButtonWithText (mc:MovieClip) {
            super (mc);
        }

        /**
         * Текст кнопки.
         */
        public function get text ():String {
            return tf.htmlText;
        }

        public function set text (value:String):void {
            tf.htmlText = value;
        }

        /**
         * @inheritDoc
         */
        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            tf = TextField (getElement ("tf", mc.tf));
        }
    }
}
