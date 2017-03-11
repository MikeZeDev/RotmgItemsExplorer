/**
 * Created by MikeZ on 27/01/2015.
 */
package utils {
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import flash.utils.describeType;

public class Utils {
    public static var keyDict:Dictionary = getKeyboardDict();

    public function Utils()
    {

    }


        private static function getKeyboardDict():Dictionary {
            var keyDescription:XML = describeType(Keyboard);
            var keyNames:XMLList = keyDescription..constant.@name;

            var keyboardDict:Dictionary = new Dictionary();

            var len:int = keyNames.length();
            for (var i:int = 0; i < len; i++) {
                keyboardDict[Keyboard[keyNames[i]]] = keyNames[i];
            }

            return keyboardDict;

        }


}
}
