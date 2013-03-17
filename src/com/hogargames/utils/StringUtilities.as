package com.hogargames.utils {
    import flash.utils.ByteArray;

    /**
     * Утилиты для работы со строками.
     */
    public class StringUtilities {

        /**
         * Преобразование строки в логическое значение.
         *
         * @return Возвращает <code>true</code>, если сторока имеет одно из следующих значений:
         * <code>1</code>, <code>"true"</code>.
         * Возвращает <code>false</code>, если сторока имеет одно из следующих значений:
         * <code>0</code>, <code>"false"</code> или <code>""</code>
         */
        public static function parseToBoolean (value:String):Boolean {
            if (parseInt (value) == 1 || value == "true") {
                return true;
            }
            else if (parseInt (value) == 0 || value == "false" || value == "") {
                return false;
            }
            else {
                return false;
            }
        }

        /**
         * Преобразование строки в массив.
         * В отличие от простого использования <code>Array.split()</code> метод выполняет
         * предварительную проверку строки методом <code>isNotValueString()</code>.
         * В том случае, если строка является пустой, возвращается пустой массив.
         */
        public static function parseToArray (value:String, separator:String = ","):Array {
            if (isNotValueString (value)) {
                return new Array ();
            }
            var arr:Array = value.split (separator);
            return arr;
        }

        /**
         * Определяет, является ли строка пустой (лишенной значения).
         *
         * @return Возвращает <code>true</code>, если сторока имеет одно из следующих значений:
         * <code>""</code>, <code>"undefined"</code> или <code>null</code>.
         */
        public static function isNotValueString (value:String):Boolean {
            return (value == "" || value == "undefined" || value == null);
        }

        public static function utf8ToWindows1251 (data:String):String {
            var b:ByteArray = new ByteArray ();
            b.writeMultiByte (data, "windows-1251");
            return b.toString ();
        }

    }
}