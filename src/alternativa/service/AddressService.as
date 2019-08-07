package alternativa.service
{
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import utils.SWFAddress;
   
   public class AddressService implements IAddressService
   {
       
      
      public function AddressService()
      {
         super();
      }
      
      public function reload() : void
      {
         var url:String = SWFAddress.getBaseURL().split("?")[0] + "?" + "rnd=" + Math.random().toString() + "#" + SWFAddress.getValue();
         var request:URLRequest = new URLRequest(url);
         navigateToURL(request,"_self");
      }
      
      public function back() : void
      {
         SWFAddress.back();
      }
      
      public function forward() : void
      {
         SWFAddress.forward();
      }
      
      public function up() : void
      {
         SWFAddress.up();
      }
      
      public function go(delta:int) : void
      {
         SWFAddress.go(delta);
      }
      
      public function href(url:String, target:String = "_self") : void
      {
         SWFAddress.href(url,target);
      }
      
      public function popup(url:String, name:String = "popup", options:String = "\"\"", handler:String = "") : void
      {
         SWFAddress.popup(url,name,options,handler);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         SWFAddress.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function) : void
      {
         SWFAddress.removeEventListener(type,listener);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return SWFAddress.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return SWFAddress.hasEventListener(type);
      }
      
      public function getBaseURL() : String
      {
         return SWFAddress.getBaseURL();
      }
      
      public function getStrict() : Boolean
      {
         return SWFAddress.getStrict();
      }
      
      public function setStrict(strict:Boolean) : void
      {
         SWFAddress.setStrict(strict);
      }
      
      public function getHistory() : Boolean
      {
         return SWFAddress.getHistory();
      }
      
      public function setHistory(history:Boolean) : void
      {
         SWFAddress.setHistory(history);
      }
      
      public function getTracker() : String
      {
         return SWFAddress.getTracker();
      }
      
      public function setTracker(tracker:String) : void
      {
         SWFAddress.setTracker(tracker);
      }
      
      public function getTitle() : String
      {
         return SWFAddress.getTitle();
      }
      
      public function setTitle(title:String) : void
      {
         SWFAddress.setTitle(title);
      }
      
      public function getStatus() : String
      {
         return SWFAddress.getStatus();
      }
      
      public function setStatus(status:String) : void
      {
         SWFAddress.setStatus(status);
      }
      
      public function resetStatus() : void
      {
         SWFAddress.resetStatus();
      }
      
      public function getValue() : String
      {
         return SWFAddress.getValue();
      }
      
      public function setValue(value:String) : void
      {
         SWFAddress.setValue(value);
      }
      
      public function getPath() : String
      {
         return SWFAddress.getPath();
      }
      
      public function getPathNames() : Array
      {
         return SWFAddress.getPathNames();
      }
      
      public function getQueryString() : String
      {
         return SWFAddress.getQueryString();
      }
      
      public function getParameter(param:String) : String
      {
         return SWFAddress.getParameter(param);
      }
      
      public function getParameterNames() : Array
      {
         return SWFAddress.getParameterNames();
      }
   }
}
