/**
 * Created by MikeZ on 27/01/2015.
 */
package data {
import flash.display.Bitmap;
import flash.display.BitmapData;

import utils.Assets;

public class Item {

    public static const SlotSword:int = 1;
    public static const SlotDagger:int = 2
    public static const SlotBow:int = 3;
    public static const SlotTome:int = 4;
    public static const SlotShield:int = 5;
    public static const SlotMediumArmor:int = 6;
    public static const SlotHeavyArmor:int = 7;
    public static const SlotWand:int = 8;
    public static const SlotRing:int = 9;
    public static const SlotConsumable:int = 10;
    public static const SlotSpell:int = 11;
    public static const SlotSeal:int = 12;
    public static const SlotCloak:int = 13;
    public static const SlotRobe:int = 14;
    public static const SlotQuiver:int = 15;
    public static const SlotHelm:int = 16;
    public static const SlotStaff:int = 17;
    public static const SlotPoison:int = 18;
    public static const SlotSkull:int = 19;
    public static const SlotTrap:int = 20;
    public static const SlotOrb:int = 21;
    public static const SlotPrism:int = 22;
    public static const SlotScepter:int = 23;
    public static const SlotKatana:int = 24;
    public static const SlotShuriken:int = 25;
    public static const SlotEgg:int = 26;


    public static var items:Array;


    public static function isArmor(type:int):Boolean
    {
        return (type == SlotRobe || type == SlotMediumArmor || type == SlotHeavyArmor  );
    }

    public static function isWeapon(type:int):Boolean
    {
        return (type == SlotBow || type == SlotDagger || type == SlotKatana ||type == SlotStaff || type == SlotWand   || type == SlotSword );
    }

    public static function isAbility(type:int):Boolean
    {
        return (type == SlotShield || type == SlotTome || type == SlotCloak ||type == SlotQuiver || type == SlotSeal   || type == SlotShuriken
         || type == SlotSpell || type == SlotHelm || type == SlotPoison || type == SlotSkull || type == SlotScepter || type == SlotPrism
        || type == SlotTrap || type == SlotOrb
        );
    }

    public static function isRing(type:int):Boolean
    {
        return (type == SlotRing  );
    }


    public static function isEgg(type:int):Boolean
    {
        return (type == SlotEgg );
    }

    public static function isConsumable(type:int):Boolean
    {
        return (type == SlotConsumable  );
    }

    public static function isSkin(obj: Object): Boolean
    {
        return (obj.hasOwnProperty("Activate") &&obj.Activate == "UnlockSkin" );
    }
    public static function isPotion(obj: Object): Boolean
{
    return (obj.hasOwnProperty("Potion"));
}

    public static function isSoulbound(obj: Object): Boolean
    {
        return (obj.hasOwnProperty("Soulbound"));
    }

    public static function isTreasure(obj: Object): Boolean
    {
        return (obj.hasOwnProperty("Treasure"));
    }


    public static function getItems():void {
        trace("Parsing Items..");
        items = [];


        /*
         var Nodez = new Array();
         var attrz:XMLList = xml.Object.children();

         for (var i:int = 0;i < attrz.length();i++)
         {
         if (Nodez.indexOf(attrz[i].localName()) == -1)
         {
         Nodez.push(attrz[i].localName());
         }
         }
         trace(Nodez);
         */

        for each(var obj:Object in GameData.EquipXML..Object) {

            var icon:Bitmap = new Bitmap(getItemIconById(parseInt(obj.@type, 16)));
            icon.width = 25;
            icon.height = 25;
            //trace("Tier:"+tier+" Item:"+obj.@id+" ID:"+id+" MpCost:"+mpCost);
            items.push({
                Name: obj.@id,
                id: parseInt(obj.@type, 16),
                BagType:obj.BagType,
                Tier: obj.Tier,
                slotType: obj.SlotType,
                feedPower:obj.feedPower,
                Cooldown: obj.Cooldown,
                icon: icon,
                mpCost: obj.MpCost,
                isSkin:Item.isSkin(obj),
                isArmor: Item.isArmor(obj.SlotType),
                isRing: Item.isRing(obj.SlotType),
                isConsumable: Item.isConsumable(obj.SlotType),
                isWeapon: Item.isWeapon(obj.SlotType),
                isAbility: Item.isAbility(obj.SlotType),
                isEgg: Item.isEgg(obj.SlotType),
                isPotion: Item.isPotion(obj),
                isSoulBound:Item.isSoulbound(obj),
                isTreasure:Item.isTreasure(obj),
                setType:obj.@setType,
                setName:obj.@setName,
                FameBonus:obj.FameBonus


            });

            //trace (name + " : " + Item.isEgg(slotType) );
        }
        trace("Sorting items......");
        items.sort(customsort)

        trace("Parsing Items done!");
    }

    public static  function customsort ( a : *, b : * ) : int {
        /*

         A negative return value specifies that A appears before B in the sorted sequence.
         A return value of 0 specifies that A and B have the same sort order.
         A positive return value specifies that A appears after B in the sorted sequence.

         */
        if (a.id < b.id)
        {
            return -1;
        }
        if (a.id > b.id)
        {
            return 1;
        }
        return 0;
    }

    public static function getItemIconById(id:int):BitmapData {
        if (id == -1) {
            return Assets.emptySlot.bitmapData;
        }
        return GameData.ObjectLibrary["getBitmapData"](id);
    }

    public static function getItemById(id:int):Object {
        for each(var obj:Object in items)
        {
            if (obj.id == id)
            {
                return (obj);
            }
        }
        return null;
    }



}




}
