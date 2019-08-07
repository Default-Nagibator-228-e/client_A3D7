package utils
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   
   [Event(name="change",type="SWFAddressEvent")]
   [Event(name="init",type="SWFAddressEvent")]
   public class SWFAddress
   {
      
      private static var _init:Boolean = false;
      
      private static var _initChange:Boolean = false;
      
      private static var _strict:Boolean = true;
      
      private static var _value:String = "";
      
      private static var _timer:Timer = null;
      
      private static var _availability:Boolean = ExternalInterface.available;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var onInit:Function;
      
      public static var onChange:Function;
      
      private static var _initializer:Boolean = _initialize();
       
      
      public function SWFAddress()
      {
         super();
         throw new IllegalOperationError("SWFAddress cannot be instantiated.");
      }
      
      private static function _initialize() : Boolean
      {
         if(_availability)
         {
            ExternalInterface.addCallback("getSWFAddressValue",function():String
            {
               return _value;
            });
            ExternalInterface.addCallback("setSWFAddressValue",_setValue);
         }
         if(_timer == null)
         {
            _timer = new Timer(200);
            _timer.addEventListener(TimerEvent.TIMER,_check);
         }
         _timer.start();
         return true;
      }
      
      private static function _check(e:TimerEvent) : void
      {
         if((typeof SWFAddress["onInit"] == "function" || _dispatcher.hasEventListener("init")) && !_init)
         {
            SWFAddress._setValueInit(_getValue());
            SWFAddress._init = true;
         }
         if(typeof SWFAddress["onChange"] == "function" || _dispatcher.hasEventListener("change"))
         {
            SWFAddress._init = true;
            SWFAddress._setValueInit(_getValue());
         }
      }
      
      private static function _strictCheck(value:String, force:Boolean) : String
      {
         if(SWFAddress.getStrict())
         {
            if(force)
            {
               if(value.substr(0,1) != "/")
               {
                  value = "/" + value;
               }
            }
            else if(value == "")
            {
               value = "/";
            }
         }
         return value;
      }
      
      private static function _getValue() : String
      {
         var value:String = null;
         var arr:Array = null;
         var ids:String = null;
         if(_availability)
         {
            value = ExternalInterface.call("SWFAddress.getValue") as String;
            arr = ExternalInterface.call("SWFAddress.getIds") as Array;
            if(arr != null)
            {
               ids = arr.toString();
            }
         }
         if(ids == null || !_availability)
         {
            value = SWFAddress._value;
         }
         else if(value == "undefined" || value == null)
         {
            value = "";
         }
         return _strictCheck(value || "",false);
      }
      
      private static function _setValueInit(value:String) : void
      {
         var change:Boolean = value != SWFAddress._value;
         SWFAddress._value = value;
         if(!_init)
         {
            _dispatchEvent(SWFAddressEvent.INIT);
         }
         else if(change)
         {
            _dispatchEvent(SWFAddressEvent.CHANGE);
         }
         _initChange = true;
      }
      
      private static function _setValue(value:String) : void
      {
         if(value == "undefined" || value == null)
         {
            value = "";
         }
         if(SWFAddress._value == value && SWFAddress._init)
         {
            return;
         }
         if(!SWFAddress._initChange)
         {
            return;
         }
         SWFAddress._value = value;
         if(!_init)
         {
            SWFAddress._init = true;
            if(typeof SWFAddress["onInit"] == "function" || _dispatcher.hasEventListener("init"))
            {
               _dispatchEvent(SWFAddressEvent.INIT);
            }
         }
         _dispatchEvent(SWFAddressEvent.CHANGE);
      }
      
      private static function _dispatchEvent(type:String) : void
      {
         if(_dispatcher.hasEventListener(type))
         {
            _dispatcher.dispatchEvent(new SWFAddressEvent(type));
         }
         type = type.substr(0,1).toUpperCase() + type.substring(1);
         if(typeof SWFAddress["on" + type] == "function")
         {
            SWFAddress["on" + type]();
         }
      }
      
      public static function back() : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.back");
         }
      }
      
      public static function forward() : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.forward");
         }
      }
      
      public static function up() : void
      {
         var path:String = SWFAddress.getPath();
         SWFAddress.setValue(path.substr(0,path.lastIndexOf("/",path.length - 2) + (path.substr(path.length - 1) == "/"?1:0)));
      }
      
      public static function go(delta:int) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.go",delta);
         }
      }
      
      public static function href(url:String, target:String = "_self") : void
      {
         if(_availability && Capabilities.playerType == "ActiveX")
         {
            ExternalInterface.call("SWFAddress.href",url,target);
            return;
         }
         navigateToURL(new URLRequest(url),target);
      }
      
      public static function popup(url:String, name:String = "popup", options:String = "\"\"", handler:String = "") : void
      {
         if(_availability && (Capabilities.playerType == "ActiveX" || ExternalInterface.call("asual.util.Browser.isSafari")))
         {
            ExternalInterface.call("SWFAddress.popup",url,name,options,handler);
            return;
         }
         navigateToURL(new URLRequest("javascript:popup=window.open(\"" + url + "\",\"" + name + "\"," + options + ");" + handler + ";void(0);"),"_self");
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         _dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function) : void
      {
         _dispatcher.removeEventListener(type,listener,false);
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return _dispatcher.dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return _dispatcher.hasEventListener(type);
      }
      
      public static function getBaseURL() : String
      {
         var url:String = null;
         if(_availability)
         {
            url = String(ExternalInterface.call("SWFAddress.getBaseURL"));
         }
         return url == null || url == "null" || !_availability?"":url;
      }
      
      public static function getStrict() : Boolean
      {
         var strict:String = null;
         if(_availability)
         {
            strict = ExternalInterface.call("SWFAddress.getStrict") as String;
         }
         return strict == null?Boolean(_strict):Boolean(strict == "true");
      }
      
      public static function setStrict(strict:Boolean) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.setStrict",strict);
         }
         _strict = strict;
      }
      
      public static function getHistory() : Boolean
      {
         return !!_availability?Boolean(ExternalInterface.call("SWFAddress.getHistory") as Boolean):Boolean(false);
      }
      
      public static function setHistory(history:Boolean) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.setHistory",history);
         }
      }
      
      public static function getTracker() : String
      {
         return !!_availability?ExternalInterface.call("SWFAddress.getTracker") as String:"";
      }
      
      public static function setTracker(tracker:String) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.setTracker",tracker);
         }
      }
      
      public static function getTitle() : String
      {
         var title:String = !!_availability?ExternalInterface.call("SWFAddress.getTitle") as String:"";
         if(title == "undefined" || title == null)
         {
            title = "";
         }
         return title;
      }
      
      public static function setTitle(title:String) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.setTitle",title);
         }
      }
      
      public static function getStatus() : String
      {
         var status:String = !!_availability?ExternalInterface.call("SWFAddress.getStatus") as String:"";
         if(status == "undefined" || status == null)
         {
            status = "";
         }
         return status;
      }
      
      public static function setStatus(status:String) : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.setStatus",status);
         }
      }
      
      public static function resetStatus() : void
      {
         if(_availability)
         {
            ExternalInterface.call("SWFAddress.resetStatus");
         }
      }
      
      public static function getValue() : String
      {
         return _strictCheck(_value || "",false);
      }
      
      public static function setValue(value:String) : void
      {
         if(value == "undefined" || value == null)
         {
            value = "";
         }
         value = _strictCheck(value,true);
         if(SWFAddress._value == value)
         {
            return;
         }
         SWFAddress._value = value;
         if(_availability && SWFAddress._init)
         {
            ExternalInterface.call("SWFAddress.setValue",value);
         }
         _dispatchEvent(SWFAddressEvent.CHANGE);
      }
      
      public static function getPath() : String
      {
         var value:String = SWFAddress.getValue();
         if(value.indexOf("?") != -1)
         {
            return value.split("?")[0];
         }
         return value;
      }
      
      public static function getPathNames() : Array
      {
         var path:String = SWFAddress.getPath();
         var names:Array = path.split("/");
         if(path.substr(0,1) == "/" || path.length == 0)
         {
            names.splice(0,1);
         }
         if(path.substr(path.length - 1,1) == "/")
         {
            names.splice(names.length - 1,1);
         }
         return names;
      }
      
      public static function getQueryString() : String
      {
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         if(index != -1 && index < value.length)
         {
            return value.substr(index + 1);
         }
         return "";
      }
      
      public static function getParameter(param:String) : String
      {
         var params:Array = null;
         var p:Array = null;
         var i:Number = NaN;
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         if(index != -1)
         {
            value = value.substr(index + 1);
            params = value.split("&");
            i = params.length;
            while(i--)
            {
               p = params[i].split("=");
               if(p[0] == param)
               {
                  return p[1];
               }
            }
         }
         return "";
      }
      
      public static function getParameterNames() : Array
      {
         var params:Array = null;
         var i:Number = NaN;
         var value:String = SWFAddress.getValue();
         var index:Number = value.indexOf("?");
         var names:Array = new Array();
         if(index != -1)
         {
            value = value.substr(index + 1);
            if(value != "" && value.indexOf("=") != -1)
            {
               params = value.split("&");
               i = 0;
               while(i < params.length)
               {
                  names.push(params[i].split("=")[0]);
                  i++;
               }
            }
         }
         return names;
      }
   }
}
