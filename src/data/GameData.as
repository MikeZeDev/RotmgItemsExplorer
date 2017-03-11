/**
 * Created by MikeZ on 27/01/2015.
 */
package data {

import flash.display.LoaderInfo;


public class GameData {

    //public static var classes:Vector.<String>
    public static var ObjectLibrary:Class;
    public static var EquipXML:XML;

    public function GameData()
    {

    }


    public static function getClasses(ldrInfo:LoaderInfo):void
    {
        var Equip:Class;
        //classes = ldrInfo.applicationDomain.getQualifiedDefinitionNames();
        ObjectLibrary = ldrInfo.applicationDomain.getDefinition("com.company.assembleegameclient.objects.ObjectLibrary") as Class;
        Equip = ldrInfo.applicationDomain.getDefinition("kabam.rotmg.assets::EmbeddedData_EquipCXML") as Class;
        EquipXML = new XML( new Equip());

        Item.getItems();
    }

    public static function clear():void
    {
        ObjectLibrary = null;
    }





}
}
