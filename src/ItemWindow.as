/**
 * Created by MikeZ on 27/01/2015.
 */
package {
import com.bit101.components.ComboBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.ScrollPane;


import data.GameData;

import data.Item;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;

import flash.events.KeyboardEvent;

import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Keyboard;

import utils.Assets;

import utils.XMLCodeHinting;

public class ItemWindow extends Panel {

    private var panelItem:ScrollPane;
    private var itemFilter:InputText;
    private var itemCombo:ComboBox;
    private var btnSearch:PushButton;


    private var panelInfos:Panel;

    private var lblID:Label;
    private var txtId:InputText;

    private var lblName:Label;
    private var txtName:InputText;

    private var lblSB:Label;
    private var txtSB:InputText;

    private var lblItemIcon:Label;
    private var itemIcon:Bitmap;

    private var lblbag:Label;
    private var bagIcon:Bitmap;

    private var lblTier:Label;
    private var txtTier:InputText;

    private var lblSet:Label;
    private var txtSet:TextField;

    private var lblFeed:Label;
    private var txtFeed:InputText;

    private var lblFame:Label;
    private var txtFame:InputText


    private var xmlfield:TextField;
    private var Xmlsource:ScrollPane;


    private static const TYPETHENAME:String = "Type the name Or the ID of an Item";
    private static const ITEMTYPES:Array = new Array("All Items", "Armors", "Abilities", "Weapons", "Rings", "Consumable", "Eggs", "Skins", "Potions");

    private static const BrownBag:Bitmap = new Assets.PNG_Brown();
    private static const PinkBag:Bitmap = new Assets.PNG_Pink();
    private static const PurpleBag:Bitmap = new Assets.PNG_Purple();
    private static const CyanBag:Bitmap = new Assets.PNG_Cyan();
    private static const BlueBag:Bitmap = new Assets.PNG_Blue();
    private static const EggBag:Bitmap = new Assets.PNG_EggBag();
    private static const WhiteBag:Bitmap = new Assets.PNG_White();

    public function ItemWindow() {
        this.width = 800;
        this.height = 600;

        //********************************************************************
        //COMBO
        //*********************************************************************

        itemCombo = new ComboBox(this, 0, 0, "All Items", "Item Type", ITEMTYPES);
        itemCombo.width = 250;
        itemCombo.selectedIndex = 0;
        itemCombo.addEventListener(Event.SELECT, itemComboSelect), false, 0, true;


        //********************************************************************
        //PANEL ITEMS
        //*********************************************************************
        panelItem = new ScrollPane(this, 0, itemCombo.y + itemCombo.height + 5);
        panelItem.autoHideScrollBar = true;
        panelItem.name = "panelItem";
        panelItem.width = 250;
        panelItem.height = this.height - itemCombo.height - 10;
        panelItem.addEventListener(MouseEvent.CLICK, onPanelClick, false, 0, true);


        //********************************************************************
        //FILTER
        //*********************************************************************
        itemFilter = new InputText(this, panelItem.width + 5, 25, TYPETHENAME);
        itemFilter.width = 250;
        itemFilter.height = 40;
        itemFilter.addEventListener(KeyboardEvent.KEY_DOWN, onFilterChange, false, 0, true);
        itemFilter.addEventListener(MouseEvent.CLICK, onFilterClick, false, 0, true);

        btnSearch = new PushButton(this, itemFilter.x + itemFilter.width + 10, 25, "Search", onSearchClick);
        btnSearch.height = 40;
        var icon:Bitmap = new Assets.PNG_Find();
        icon.x = 3;
        icon.y = 5;
        icon.width = 32;
        icon.height = 32;
        btnSearch.addChild(icon);

        //********************************************************************
        //PANEL INFOS
        //*********************************************************************

        panelInfos = new Panel(this, itemFilter.x, itemFilter.y + itemFilter.height + 5);
        panelInfos.width = this.width - panelInfos.x - 5 - 5;
        panelInfos.height = this.height - itemFilter.y - itemFilter.height - 10;

        //ID
        lblID = new Label(panelInfos, 5, 5, "Item ID : ");
        txtId = new InputText(panelInfos, lblID.x + lblID.width + 5, lblID.y + 3, "Id")
        txtId.height = 20;
        txtId.textField.type = TextFieldType.DYNAMIC;
        txtId.textField.selectable = true;

        //Name
        lblName = new Label(panelInfos, 5, txtId.y + txtId.height + 5, "Item Name : ");
        txtName = new InputText(panelInfos, lblName.x + lblName.width + 5, lblName.y + 3, "Name")
        txtName.width = 400;
        txtName.height = 20;
        txtName.textField.type = TextFieldType.DYNAMIC;
        txtName.textField.selectable = true;

        //item Icon
        lblItemIcon = new Label(panelInfos, 5, txtName.y + txtName.height + 10, "Item Icon :");
        setItemIcon(-1);

        //item Set
        lblSet = new Label(panelInfos, itemIcon.x + itemIcon.width + 30, lblItemIcon.y, "Item Set :");
        txtSet = new TextField();
        txtSet.x = lblSet.x + lblSet.width + 5;
        txtSet.y = lblSet.y + 3;
        txtSet.autoSize = "left";
        panelInfos.addChild(txtSet);


        //Bag
        lblbag = new Label(panelInfos, 5, itemIcon.y + itemIcon.height + 32, "Bag Type :");
        setBagIcon(-1);

        //Tier
        lblTier = new Label(panelInfos, 5, lblbag.y + lblbag.height + 10, "Tier : ");
        txtTier = new InputText(panelInfos, lblTier.x + lblTier.width + 5, lblTier.y + 3, "0")
        txtTier.width = 25;
        txtTier.height = 20;
        txtTier.textField.type = TextFieldType.DYNAMIC;
        txtTier.textField.selectable = true;

        //Soulbound
        lblSB = new Label(panelInfos, txtTier.x + txtTier.width + 5, lblbag.y + lblbag.height + 10, "Soulbound :");
        txtSB = new InputText(panelInfos, lblSB.x + lblSB.width + 5, lblSB.y + 3, "")
        txtSB.width = 30;
        txtSB.height = 20;
        txtSB.textField.type = TextFieldType.DYNAMIC;
        txtSB.textField.selectable = true;

        //Feedpower
        lblFeed = new Label(panelInfos, 5, txtTier.y + txtTier.height + 5, "FeedPower :");
        txtFeed = new InputText(panelInfos, lblFeed.x + lblFeed.width + 5, lblFeed.y + 3, "0");
        txtFeed.height = 20;
        txtFeed.textField.type = TextFieldType.DYNAMIC;
        txtFeed.textField.selectable = true;

        //FameBonus
        lblFame = new Label(panelInfos, 5, txtFeed.y + txtFeed.height + 5, "Fame Bonus :");
        txtFame = new InputText(panelInfos, lblFame.x + lblFame.width + 5, lblFame.y + 3, "");
        txtFame.height = 20;
        txtFame.width = 30;
        txtFame.textField.type = TextFieldType.DYNAMIC;
        txtFame.textField.selectable = true;

        //MpCost Cooldown Effects

        Xmlsource = new ScrollPane(panelInfos, 5, txtFame.y + txtFame.height + 5);
        Xmlsource.width = panelInfos.width - 10;
        Xmlsource.height = panelInfos.height- Xmlsource.y -5 ;

        //xmlfield = new InputText(panelInfos,5,lblbag.y + lblbag.height + 5);
        xmlfield = new TextField();
        xmlfield.autoSize = "left";
        xmlfield.text = "<Object id=\"Big Bag of Dildoes\">";

        Xmlsource.addChild(xmlfield);


        GetItems();




    }



    private function GetItems():void {

        Sprite(panelItem.getChildAt(2)).removeChildren();
        var itemCount:int = 0;
        var itemId:int = -1;
        var isNumeric:Boolean = false;
        var itemOk:Boolean = false;
        var radix:int = 0;

        var Num:Number = Number(itemFilter.text);
        isNumeric = !isNaN(Num);
        if (isNumeric) {
            itemId = int(Num);

        }

        for (var item:int = 0; item < Item.items.length; item++) {


            switch (itemCombo.selectedIndex) {
                case 0:
                    break;
                case 1:
                    if (!Item.items[item].isArmor) continue;
                    break;
                case 2:
                    if (!Item.items[item].isAbility) continue;
                    break;
                case 3:
                    if (!Item.items[item].isWeapon) continue;
                    break;
                case 4:
                    if (!Item.items[item].isRing) continue;
                    break;

                case 5:
                    if (!Item.items[item].isConsumable) continue;
                    break;
                case 6:
                    if (!Item.items[item].isEgg) continue;
                    break;
                case 7:
                    if (!Item.items[item].isSkin) continue;
                    break;
                case 8:
                    if (!Item.items[item].isPotion) continue;
                    break;


            }

            //Item filter
            if (itemFilter.text != TYPETHENAME && itemFilter.text != "") {

                if (isNumeric) {

                    if (int(Item.items[item].id) != itemId) {
                        continue
                    }
                    else {
                        itemOk = true;
                    }


                }
                else {
                    if (String(Item.items[item].Name).toLowerCase().indexOf(itemFilter.text.toLowerCase()) == -1) {
                        continue;
                    }
                }
            }

            var str:String = Item.items[item].Tier;
            if (str == "") {
                str = Item.items[item].Name;
            }
            else {
                str = "[T" + Item.items[item].Tier + "] " + Item.items[item].Name
            }

            var button:PushButton = new PushButton(panelItem, 0, 0 + itemCount * 35, str);
            var icon:Bitmap = Item.items[item].icon;
            button.height = 35;
            button.width = 250;
            button.addChild(icon);
            button.toolTipMessage = Item.items[item].id + ": 0x" + Item.items[item].id.toString(16);
            icon.x = 5;
            icon.y = 3;
            button.name = Item.items[item].id;
            button.addEventListener(MouseEvent.MOUSE_OVER, onScrollOver, false, 0, true);
            button.addEventListener(MouseEvent.MOUSE_OUT, onScrollOut, false, 0, true);
            itemCount++;
            if (isNumeric && itemOk) {
                break;
            }

        }
        panelItem.update();

    }

    private function ShowItemInfos(itemId:int):void {
        trace("ITEM ID : " + itemId);

        var itm:Object = Item.getItemById(itemId);
        if (itm == null) {
            return;
        }

        txtId.text = itm.id;
        txtName.text = itm.Name;
        txtTier.text = itm.Tier;

        if (txtTier.text == "") {
            if (itm.isWeapon || itm.isArmor || itm.isRing || itm.isAbility) {
                txtTier.text = "UT";
            }

        }

        setBagIcon(itm.BagType);
        setItemIcon(itm.id);
        txtFeed.text = itm.feedPower;
        txtSB.text = (itm.isSoulBound) ? "YES" : "NO";
        txtFame.text = (itm.FameBonus.toString() != "") ? itm.FameBonus + "%" : "";
        txtSet.text = (itm.setName.toString() != "") ? itm.setName : "None";
        txtSet.textColor = (itm.setName.toString() != "") ? 0xFF8C00 : lblSet.textField.textColor;

        //Xml

        var hexId:String = "0x" + itemId.toString(16);
        var xml:XML = GameData.EquipXML;
        var list:XMLList = xml.Object.(@type == hexId);
        if (list.length() == 0) {
            list = xml.Object.(@type == "0x" + itemId.toString(16).toUpperCase());
        }
        if (list.length() == 0) {
            list = xml.Object.(@type == "0x" + itemId.toString(16).toLowerCase());
        }

        var obj:XML = list[0];
        //trace(obj);

        xmlfield.text = obj.toString();
        XMLCodeHinting.defaultFormat = 0x000000;
        XMLCodeHinting.commentFormat = 0x999999;
        XMLCodeHinting.tagFormat = 0xCC0000;
        XMLCodeHinting.cdataFormat = 0x00CC00;
        XMLCodeHinting.attributeFormat = 0x0000CC;

        XMLCodeHinting.colorize(xmlfield);
        Xmlsource.update();


    }

    private function setItemIcon(id:int):void {
        if (itemIcon != null) {
            panelInfos.content.removeChild(itemIcon);
        }
        else
        {
            itemIcon = new Bitmap();
        }

        var itm:Object = Item.getItemById(id);

        if (itm != null) {
            itemIcon.bitmapData = itm.icon.bitmapData.clone();
        }
        itemIcon.width = 25
        itemIcon.height = 25;
        itemIcon.x = lblItemIcon.x + lblItemIcon.width + 5;
        itemIcon.y = lblItemIcon.y;
        panelInfos.addChild(itemIcon);
    }

    private function setBagIcon(bagid:int):void {

        if (bagIcon != null) {
            panelInfos.content.removeChild(bagIcon);
        }

        switch (bagid) {
            case -1:
                bagIcon = new Bitmap();
                break;
            case 0:
                bagIcon = BrownBag
                break;
            case 1:
                bagIcon = PinkBag;
                break;
            case 2:
                bagIcon = PurpleBag;
                break;
            case 3:
                bagIcon = EggBag;
                break;
            case 4:
                bagIcon = CyanBag;
                break;
            case 5:
                bagIcon = BlueBag;
                break;
            case 6:
                bagIcon = WhiteBag;
                break;

        }

        bagIcon.width = 32;
        bagIcon.height = 32;
        bagIcon.name = "bagIcon";
        bagIcon.x = lblbag.x + lblbag.width + 5;
        bagIcon.y = lblbag.y;
        panelInfos.addChild(bagIcon);


    }


    //*********************************************
    // EVENTS
    //******************************************

    private function onPanelClick(e:Event):void {
        if (isNaN(Number(e.target.name))) {
            return;
        }

        if (e.target is PushButton) {
            ShowItemInfos(parseInt(e.target.name));
        }
    }

    private function onSearchClick(e:Event):void {
        GetItems();
    }

    private function itemComboSelect(e:Event):void {
        GetItems();
    }

    private function onScrollOver(e:MouseEvent):void {
        //trace("MOVE OVER ON WINDOW : " + e.target.name);

        if (e.target is PushButton) {
            PushButton(e.target).showTooltip(e.localX, e.localY);
        }

    }

    private function onScrollOut(e:MouseEvent):void {
        //trace("MOVE OUT ON WINDOW : " + e.target.name);

        if (e.target is PushButton) {
            PushButton(e.target).hideTooltip();
        }

    }


    private function onFilterClick(e:MouseEvent):void {
        if (itemFilter.text == TYPETHENAME) {
            itemFilter.text = "";
        }
    }

    private function onFilterChange(e:KeyboardEvent):void {

        if (e.keyCode == Keyboard.ENTER) {
            GetItems();
        }

        /*   var key:String = "";


         var old:String = e.currentTarget.text;
         var finalWord:String = old + key;

         var result:Array = [];

         //if backslash just remove one letter from final, else add the correct keycode
         if (e.keyCode == Keyboard.BACKSLASH) {
         finalWord.substr(0, finalWord.length - 1);
         }
         else {
         key = Utils.keyDict[e.keyCode]
         }*/

        /*
         //for each item found add it to the result array
         for (var i:int = 0; i < GameData.items.length; i++) {
         if (String(GameData.items[i].name).toLowerCase().indexOf(finalWord.toLowerCase()) != -1) {
         result.push(GameData.items[i]);
         }
         }



         var sp:Sprite;
         var button:PushButton;
         var icon:Bitmap;

         //if we found something, add it to the panelItem
         if (result.length > 0) {
         //remove buttons from panelItem
         sp = panelItem.getChildAt(2) as Sprite;
         sp.removeChildren();

         for (var item:int = 0; item < result.length; item++) {
         button = new PushButton(panelItem, 0, 0 + item * 35, "[T" + result[item].tier + "] " + result[item].name, findPlayerHoldItemById);
         icon = result[item].icon;
         button.height = 35;
         button.width = 250;
         button.addChild(icon);
         icon.x = 5;
         icon.y = 3;
         button.name = result[item].id;
         }
         panelItem.update();
         }
         else {

         }

         //check if empty, so put back the initial items
         if (old.length == 1 && e.keyCode == Keyboard.BACKSPACE) {
         // trace("should be empty");

         sp = panelItem.getChildAt(2) as Sprite;
         sp.removeChildren();
         for (var k:int = 0; k < result.length; k++) {
         button = new PushButton(panelItem, 0, 0 + item * 35, "[T" + result[k].tier + "] " + result[k].name, findPlayerHoldItemById);
         icon = result[k].icon;
         button.height = 35;
         button.width = 250;
         button.addChild(icon);
         icon.x = 5;
         icon.y = 3;
         button.name = result[k].id;
         }
         panelItem.update();
         }
         //trace(old);

         */

    }


}


}
