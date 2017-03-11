/**
 * PushButton.as
 * Keith Peters
 * version 0.9.10
 *
 * A basic button component with a label.
 *
 * Copyright (c) 2011 Keith Peters
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.components {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class PushButton extends Component {
    //   var Z : Component
    protected var _borderColor:uint = 0x000000;
    protected var _borderSize:int = 0;
    protected var _back:Sprite;
    protected var _face:Sprite;
    protected var _label:Label;
    protected var _labelText:String = "";
    protected var _over:Boolean = false;
    protected var _down:Boolean = false;
    protected var _selected:Boolean = false;
    protected var _toggle:Boolean = false;
    protected var _color:uint = Style.BUTTON_FACE;
    protected var _blank:Sprite = new Sprite();

    protected var _useToolTip:Boolean = false;
    protected var _toolTipMessage:String = "";

    private var _toolTipPanel:Panel;
    private var _toolTipLabel:Label;

    private var _toolTipWidth:int = 100;
    private var _toolTipHeight:int = 50;
    private var _tooltipAlpha:Number = 0.75;


    /**
     * Constructor
     * @param parent The parent DisplayObjectContainer on which to add this PushButton.
     * @param xpos The x position to place this component.
     * @param ypos The y position to place this component.
     * @param label The string to use for the initial label of this component.
     * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
     */
    public function PushButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null, useToolTip:Boolean = false, toolTipMessage:String = "") {
        super(parent, xpos, ypos);
        if (defaultHandler != null) {
            addEventListener(MouseEvent.CLICK, defaultHandler, false, 0, true);
        }
        this.label = label;
        _useToolTip = useToolTip;
        _toolTipMessage = splitTwoLine(toolTipMessage, 36);


    }

    /**
     * Initializes the component.
     */
    override protected function init():void {
        super.init();
        buttonMode = true;
        useHandCursor = true;
        setSize(125, 20);

        _toolTipPanel = new Panel(this, 0, 0);
        _toolTipPanel.visible = false;
        _toolTipPanel.color = Style.DROPSHADOW;
        _toolTipPanel.shadow = true;
        _toolTipPanel.alpha = _tooltipAlpha;
        _toolTipLabel = new Label(_toolTipPanel, 0, 0, "");
        _toolTipLabel.visible = false;

    }

    /**
     * Creates and adds the child display objects of this component.
     */
    override protected function addChildren():void {
        _back = new Sprite();
        _back.filters = [getShadow(2, true)];
        _back.mouseEnabled = false;
        addChild(_back);

        _face = new Sprite();
        _face.mouseEnabled = false;
        _face.filters = [getShadow(1)];
        _face.x = 1;
        _face.y = 1;
        addChild(_face);

        _label = new Label();
        addChild(_label);
        addChild(_blank);

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown, false, 0, true);
        addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
         addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    /**
     * Draws the face of the button, color based on state.
     */
    protected function drawFace():void {
        _face.graphics.clear();
        if (_down) {
            _face.graphics.beginFill(Style.BUTTON_DOWN);
        }
        else {
            _face.graphics.beginFill(_color);
        }
        _face.graphics.drawRect(0, 0, _width - 2, _height - 2);
        _face.graphics.endFill();

    }


    ///////////////////////////////////
    // public methods
    ///////////////////////////////////

    /**
     * Draws the visual ui of the component.
     */
    override public function draw():void {
        super.draw();
        _back.graphics.clear();
        _back.graphics.lineStyle(_borderSize, _borderColor);
        _back.graphics.beginFill(Style.BACKGROUND);
        _back.graphics.drawRect(0, 0, _width, _height);

        _back.graphics.endFill();

        drawFace();

        _label.text = _labelText;
        _label.autoSize = true;
        _label.draw();
        if (_label.width > _width - 4) {
            _label.autoSize = false;
            _label.width = _width - 4;
        }
        else {
            _label.autoSize = true;
        }
        _label.draw();
        _label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);

    }

    /*
     public function updateToolTip():void
     {
     if(_useToolTip)
     {
     if(_over)
     {
     showTooltip();

     }
     else
     {
     hideTooltip();
     }

     }


     }
     */
    public function showTooltip(X:Number, Y:Number):void {
        if (_toolTipMessage == "") {
            return;
        }
        parent.setChildIndex(this, parent.numChildren - 1);

        if (_toolTipPanel.visible == false)
            _toolTipPanel.visible = true;

        _toolTipPanel.width = _toolTipWidth;
        _toolTipPanel.height = _toolTipHeight;

        _toolTipPanel.x = X + 15;
        _toolTipPanel.y = Y + 20;

        var total:Number = _toolTipPanel.x + this.x + _toolTipPanel.width;
        while (total > 800) {
            //trace("Toobig");
            _toolTipPanel.x = _toolTipPanel.x - _toolTipPanel.width;
            total = _toolTipPanel.x + this.x + _toolTipPanel.width;
        }

        _toolTipLabel.text = _toolTipMessage;
        _toolTipLabel.x = 6;
        _toolTipLabel.y = 6.5;

        if (_toolTipLabel.visible == false)
            _toolTipLabel.visible = true;

        /*
         _toolTipLabel.x = _face.x- (_toolTipPanel.width - _face.width)/2;
         if(this.y <= 45)
         _toolTipLabel.y = _toolTipPanel.y + 5;
         else
         _toolTipLabel.y = _toolTipPanel.y - 5;
         _toolTipLabel.visible = true;
         */

        //setTimeout(hideTooltip,2000);
    }

    public function hideTooltip():void {
            _toolTipPanel.visible = false;
            _toolTipLabel.visible = false;

    }


    ///////////////////////////////////
    // event handlers
    ///////////////////////////////////


     protected function onMouseMove(event:MouseEvent):void
     {

     _toolTipPanel.x = event.localX + 10;
     _toolTipPanel.y = event.localY+10;

         if (_toolTipPanel.x + _toolTipPanel.width > this.width)
             _toolTipPanel.x -= _toolTipPanel.width;

     _toolTipPanel.draw();


     }



    /**
     * Internal mouseOver handler.
     * @param event The MouseEvent passed by the system.
     */
    protected function onMouseOver(event:MouseEvent):void {
        // trace("OVER");
        _over = true;
        _face.graphics.beginFill(Style.BUTTON_OVER);
        //updateToolTip();
        addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
    }

    /**
     * Internal mouseOut handler.
     * @param event The MouseEvent passed by the system.
     */
    protected function onMouseOut(event:MouseEvent):void {
        // trace("OUT");
        _over = false;
        _face.graphics.beginFill(Style.BUTTON_FACE);
        if (!_down) {
            _face.filters = [getShadow(1)];
        }
        //updateToolTip();
        removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
    }

    /**
     * Internal mouseOut handler.
     * @param event The MouseEvent passed by the system.
     */
    protected function onMouseGoDown(event:MouseEvent):void {
        _down = true;
        drawFace();
        _face.filters = [getShadow(1, true)];
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp, false, 0, true);

    }

    /**
     * Internal mouseUp handler.
     * @param event The MouseEvent passed by the system.
     */
    protected function onMouseGoUp(event:MouseEvent):void {
        if (_toggle && _over) {
            _selected = !_selected;
        }
        _down = _selected;
        drawFace();
        _face.filters = [getShadow(1, _selected)];
        parent.stage.focus = null;
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);

    }


    ///////////////////////////////////
    // getter/setters
    ///////////////////////////////////

    /**
     * Sets / gets the label text shown on this Pushbutton.
     */
    public function set label(str:String):void {
        _labelText = str;
        draw();
    }

    public function get label():String {
        return _labelText;
    }

    public function set selected(value:Boolean):void {
        if (!_toggle) {
            value = false;
        }

        _selected = value;
        _down = _selected;
        _face.filters = [getShadow(1, _selected)];
        drawFace();
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set toggle(value:Boolean):void {
        _toggle = value;
    }

    public function get toggle():Boolean {
        return _toggle;
    }

    public function set color(color:uint):void {
        _face.graphics.beginFill(color);
        _back.graphics.beginFill(color);
        drawFace();
    }

    public function set borderColor(value:uint):void {
        _borderColor = value;
        draw();
    }

    public function get borderColor():uint {
        return _borderColor;
    }

    public function set borderSize(value:uint):void {
        _borderSize = value;
        draw();
    }

    public function get borderSize():uint {
        return _borderSize;
    }

    public function set useToolTip(value:Boolean):void {
        _useToolTip = value;
    }

    public function set toolTipMessage(value:String):void {
        var txt:String = splitTwoLine(value, 28);
        _toolTipMessage = txt;
    }

    public static function splitTwoLine(s:String, i:int):String {
        var sLen:int = s.length;

        if (sLen <= i) return s;

        var sArray:Array = s.split("");

        while (i >= 0) {
            if (sArray[i] === " ") break;
            i--;
        }

        return s.slice(0, i) + "\n" + s.slice(i, sLen);
    }
}
}