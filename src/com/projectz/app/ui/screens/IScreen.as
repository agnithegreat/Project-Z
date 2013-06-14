/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.06.13
 * Time: 10:37
 * To change this template use File | Settings | File Templates.
 */
package com.projectz.app.ui.screens {

/**
 * Интерфейс для экрана приложения.
 */
public interface IScreen {

    /**
     * Метод вызываемый при открытии экрана.
     */
    function onOpen ():void;

    /**
     * Метод вызываемый при закрытии экрана.
     */
    function onClose ():void;
}
}
