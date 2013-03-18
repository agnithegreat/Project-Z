/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 23.03.12
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.errors {

    public class SingletonError extends Error {

        public function SingletonError (message:String = "Class is singleton", id:int = 0) {
            super (message, id);
        }

    }
}

