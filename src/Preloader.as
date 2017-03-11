/**
 * Created by MikeZ on 27/01/2015.
 */
package {
import data.GameData;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.events.UncaughtErrorEvent;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.LocalConnection;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;

public class Preloader extends  Sprite{

    private var ldrI : LoaderInfo;
    private var Wmain : Object;
    private var ItWin: ItemWindow;
    private var T:Timer;


    public function Preloader(param1:String)
    {
        var _loc3_:String = null;
        var _loc4_:Object = null;
        var _loc6_:Object = null;
        super();

       // this.logo_ = new AnimatedLogo();
      //  addChild(this.logo_);

        this.domain_ = "realmofthemadgodhrd.appspot.com";
        var _loc2_:LocalConnection = new LocalConnection();

        this.swfPrefix_ = param1;
        Security.allowDomain("*");
        _loc4_ = LoaderInfo(this.loaderInfo).parameters;


        /*if(_loc4_.rotmg_loader_protocol == "https:")
        {
            this.protocol_ = _loc4_.rotmg_loader_protocol;
        }
        if(_loc4_.rotmg_loader_port != null)
        {
            this.domain_ = this.domain_ + _loc4_.rotmg_loader_port;
        }*/


        this.status_ = new TextField();
        this.status_.selectable = false;
        var _loc5_:TextFormat = new TextFormat();
        _loc5_.size = 10;
        _loc5_.color = 4.286545791E9;
        this.status_.defaultTextFormat = _loc5_;
        this.status_.width = 800;
        this.status_.y = 360;
        this.setStatus("initializing");
        if(_loc4_.version_timestamp != null)
        {
            _loc6_ = _loc4_.version_timestamp;
            this.loadSWF(_loc6_.toString());
        }
        else
        {
            this.urlLoader_ = new URLLoader();
            this.urlLoader_.addEventListener(Event.COMPLETE,this.onVersionComplete);
            this.urlLoader_.addEventListener(IOErrorEvent.IO_ERROR,this.onVersionIOError);
            this.urlLoader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onVersionSecurityError);
            this.loadVersion();
        }
    }


    private static const DEFAULT_BYTES_TOTAL:int = 1 << 20;

    private var domain_:String;

    private var swfPrefix_:String;

    private var status_:TextField;

    private var urlLoader_:URLLoader;

    private var loader_:Loader;

    private var game_:Sprite;

    private var protocol_:String = "http:";

    private function setStatus(param1:String) : void
    {
        addChild(this.status_);
        this.status_.htmlText = "<p align=\"center\">" + param1 + "</p>";
    }

    private function removeStatus() : void
    {
        //removeChild(this.logo_);
        removeChild(this.status_);
    }

    private function loadVersion() : void
    {
        var _loc1_:* = "";
        _loc1_ = "realmofthemadgodhrd.appspot.com";

        var _loc2_:* = this.protocol_ + "//" + _loc1_ + "/version.txt";
        var _loc3_:URLRequest = new URLRequest(_loc2_);
        _loc3_.data = new URLVariables("time=" + Number(new Date().getTime()));
        this.urlLoader_.load(_loc3_);
        this.setStatus("loading version");
    }

    private function onVersionComplete(param1:Event) : void
    {
        var _loc2_:String = this.urlLoader_.data;
        this.loadSWF(_loc2_);
    }

    private function onVersionIOError(param1:IOErrorEvent) : void
    {
        this.retryLoadVersion();
    }

    private function onVersionSecurityError(param1:SecurityErrorEvent) : void
    {
        this.retryLoadVersion();
    }

    private function retryLoadVersion() : void
    {
        this.setStatus("version loading error, retrying...");
        var _loc1_:Timer = new Timer(1000,1);
        _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onWaitDone);
    }

    private function onWaitDone(param1:TimerEvent) : void
    {
        this.loadVersion();
    }

    private function loadSWF(param1:String) : void
    {
        var _loc2_:* = this.protocol_ + "//" + this.domain_ + "/" + this.swfPrefix_ + param1 + ".swf";
        var _loc3_:URLRequest = new URLRequest(_loc2_);
        var cont:LoaderContext = new LoaderContext(false, null);

        cont.allowCodeImport = true;
        cont.applicationDomain = ApplicationDomain.currentDomain;
        cont.parameters = {"wmode ": "direct"};

        this.loader_ = new Loader();
        this.loader_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onSWFProgress);
        this.loader_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFComplete);
        this.loader_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onSWFIOError);
        this.setStatus("loading SWF");

        this.loader_.load(_loc3_, cont);



    }

    private function onSWFProgress(param1:ProgressEvent) : void
    {
        var _loc2_:Number = param1.bytesTotal == 0?DEFAULT_BYTES_TOTAL:param1.bytesTotal;
        var _loc3_:Number = Math.min(1,param1.bytesLoaded / _loc2_);
        this.setStatus(int(_loc3_ * 100).toString() + "%");
    }

    private function onSWFComplete(param1:Event) : void
    {
        Wmain = loader_.content;
        ldrI = param1.target as LoaderInfo;
        this.removeLoaderListeners();
        this.runSWF();
    }

    private function onSWFIOError(param1:Event) : void
    {
        this.removeLoaderListeners();
        this.restart();
    }

    private function removeLoaderListeners() : void
    {
        this.loader_.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onSWFProgress);
        this.loader_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onSWFComplete);
        this.loader_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onSWFIOError);
    }

    private function runSWF() : void
    {
        this.removeStatus();
        stage.addChild(loader_);

        Sprite(Wmain).visible = false;
        SoundMixer.soundTransform = new SoundTransform(0);

        GameData.getClasses(ldrI);
        ItWin = new ItemWindow();
        stage.addChild(ItWin);
        GameData.clear();

        T = new Timer(1000,5);
        T.addEventListener(TimerEvent.TIMER_COMPLETE,onTimer,false,0,true);
        T.start();

    }

    private function onTimer(param1:Event) : void
    {
        T.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimer);
        loader_.unloadAndStop(true);
        stage.removeChild(loader_);
        loader_ = null;
    }

    private function onGameComplete(param1:Event) : void
    {
        this.restart();
    }


    private function stop():void
    {
        if(this.game_ != null)
        {
            this.game_.removeEventListener(Event.COMPLETE,this.onGameComplete);
            removeChild(this.game_);
            this.game_ = null;
        }
        if(this.loader_ != null)
        {
            try
            {
                this.loader_.unloadAndStop(true);
                stage.removeChild(loader_);
                this.loader_ = null;
            }
            catch(e:Error)
            {

            }
        }
    }

    private function restart() : void
    {
        if(this.game_ != null)
        {
            this.game_.removeEventListener(Event.COMPLETE,this.onGameComplete);
            removeChild(this.game_);
            this.game_ = null;
        }
        if(this.loader_ != null)
        {
            this.loader_.unloadAndStop(true);
            this.loader_ = null;
        }
        this.loadVersion();
    }
}
}

