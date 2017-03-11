package com.bit101.components {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;

public class Tab extends Component {

    function Tab(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0) {
        this._darkness = new ColorMatrixFilter([1, 0, 0, 0, -10, 0, 1, 0, 0, -10, 0, 0, 1, 0, -10, 0, 0, 0, 1, 0]);
        super(param1, param2, param3);
    }

    protected var _color:int = -1;

    protected var _shadow:Boolean = true;

    protected var _draggable:Boolean = false;

    protected var _tabs:Array;

    protected var _contents:Array;

    protected var _labels:Array;

    protected var _labelTexts:Array;

    protected var _current:int = 0;

    protected var _darkness:ColorMatrixFilter;

    override protected function init():void {
        super.init();
        setSize(100, 100);
    }

    override protected function addChildren():void {
        this._tabs = [];
        this._contents = [];
        this._labels = [];
        this._labelTexts = [];
        filters = [getShadow(4, false)];
    }

    override public function addChild(param1:DisplayObject):DisplayObject {
        this.getContent(this._current).addChild(param1);
        return param1;
    }

    public function addRawChild(param1:DisplayObject):DisplayObject {
        super.addChild(param1);
        return param1;
    }

    public function addPage(param1:String, param2:Panel = null):int {
        var _loc3_:Panel = new Panel();
        _loc3_.filters = [];
        _loc3_.buttonMode = true;
        _loc3_.useHandCursor = true;
        _loc3_.mouseChildren = false;
        _loc3_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseGoDown);
        _loc3_.height = 25;
        _loc3_.tag = this._tabs.length;
        super.addChild(_loc3_);
        this._labels.push(new Label(_loc3_.content, 5, 1, param1));
        this._labelTexts.push(param1);
        this._tabs.push(_loc3_);
        if (!param2) {
            param2 = new Panel();
        }
        param2.y = 20;
        this._contents.push(param2);
        invalidate();
        return _loc3_.tag;
    }

    public function removePage(param1:int):void {
        if (this._contents[param1].parent) {
            this._contents[param1].parent.removeChild(this._contents[param1]);
        }
        super.removeChild(this._tabs[param1]);
        this._contents.splice(param1, 1);
        this._tabs[param1].removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseGoDown);
        this._tabs.splice(param1, 1);
        this._labelTexts.splice(param1, 1);
        this._labels.splice(param1, 1);
        var _loc2_:* = 0;
        while (_loc2_ < this._tabs.length) {
            this._tabs[_loc2_].tag = _loc2_;
            _loc2_++;
        }
        if (this._current >= param1) {
            this._current--;
        }
        if (this._current < 0) {
            this._current = 0;
        }
        invalidate();
    }

    public function addChildToPage(param1:int, param2:DisplayObject):DisplayObject {
        this.getContent(param1).addChild(param2);
        return param2;
    }

    override public function draw():void {
        var w:Number = NaN;
        super.draw();
        this._labels.forEach(function (param1:Label, param2:int, ...rest):void {
            param1.text = _labelTexts[param2];
            param1.alpha = param2 == _current ? 1 : 0.4;
        });
        w = (_width - 10) / this._tabs.length;
        this._tabs.forEach(function (param1:Panel, param2:int, ...rest):void {
            param1.x = 5 + param2 * w;
            param1.width = w;
            param1.color = _color;
            param1.filters = param2 == _current ? [] : [_darkness];
            param1.draw();
        });
        this._contents.forEach(function (param1:Panel, ...rest):void {
            param1.color = _color;
            param1.setSize(_width, _height - 20);
            param1.draw();
            if (param1.parent) {
                param1.parent.removeChild(param1);
            }
        });
        super.addChild(this._contents[this._current]);
    }

    protected function onMouseGoDown(param1:MouseEvent):void {
        if (this._draggable) {
            this.startDrag();
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseGoUp);
            parent.addChild(this);
        }
        var _loc2_:Panel = param1.target as Panel;
        if (_loc2_) {
            super.addChild(_loc2_);
            this._current = _loc2_.tag;
            invalidate();
        }
        dispatchEvent(new Event(Event.SELECT));
    }

    protected function onMouseGoUp(param1:MouseEvent):void {
        this.stopDrag();
        stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseGoUp);
    }

    public function set shadow(param1:Boolean):void {
        this._shadow = param1;
        if (this._shadow) {
            filters = [getShadow(4, false)];
        }
        else {
            filters = [];
        }
    }

    public function get shadow():Boolean {
        return this._shadow;
    }

    public function set color(param1:int):void {
        this._color = param1;
        invalidate();
    }

    public function get color():int {
        return this._color;
    }

    public function get content():DisplayObjectContainer {
        return this.getContent(this._current);
    }

    public function getContent(param1:int):DisplayObjectContainer {
        return Panel(this._contents[param1]).content;
    }

    public function set draggable(param1:Boolean):void {
        var b:Boolean = param1;
        this._draggable = b;
        this._tabs.forEach(function (param1:Panel, ...rest):void {
            param1.buttonMode = _draggable;
            param1.useHandCursor = _draggable;
        });
    }

    public function get draggable():Boolean {
        return this._draggable;
    }

    public function get current():int {
        return this._current;
    }
}


}
