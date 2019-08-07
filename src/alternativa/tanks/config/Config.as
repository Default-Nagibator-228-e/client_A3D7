package alternativa.tanks.config
{
   import alternativa.proplib.PropLibRegistry;
   import utils.TaskSequence;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="complete",type="flash.events.Event")]
   public class Config extends EventDispatcher
   {
       
      
      public var xml:XML;
      
      public var map:TanksMap;
      
      public var textureLibrary:TextureLibrary;
      
      public var propLibRegistry:PropLibRegistry;
      
      private var taskSequence:TaskSequence;
      
      public function Config()
      {
         super();
      }
      
      public function load(url:String, mapId:String) : void
      {
         this.taskSequence = new TaskSequence();
         this.taskSequence.addTask(new ConfigXMLLoader(url,this));
         this.taskSequence.addTask(new PropLibsLoader(this));
         this.map = new TanksMap(this,mapId);
         this.taskSequence.addTask(this.map);
         this.taskSequence.addEventListener(Event.COMPLETE,this.onSequenceComplete);
         this.taskSequence.run();
      }
      
      private function onSequenceComplete(event:Event) : void
      {
         this.taskSequence = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function getNumber(path:String, defaultValue:Number = 0) : Number
      {
         var option:String = this.getOption(path);
         var result:Number = Number(option);
         return !!isNaN(result)?Number(Number(defaultValue)):Number(Number(result));
      }
      
      public function getOption(optionPath:String) : String
      {
         var parts:Array = optionPath.split(".");
         return this.getXmlElement(parts).toString();
      }
      
      private function getXmlElement(parts:Array) : XMLList
      {
         var result:XMLList = this.xml.elements(parts.shift());
         while(parts.length > 0)
         {
            result = result.elements(parts.shift());
         }
         return result;
      }
   }
}

import alternativa.tanks.config.Config;
import utils.Task;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

class ConfigXMLLoader extends Task
{
    
   
   private var config:Config;
   
   private var loader:URLLoader;
   
   private var url:String;
   
   function ConfigXMLLoader(url:String, config:Config)
   {
      super();
      this.url = url;
      this.config = config;
   }
   
   override public function run() : void
   {
      this.loader = new URLLoader();
      this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
      this.loader.load(new URLRequest(this.url));
   }
   
   private function onLoadingComplete(event:Event) : void
   {
      this.config.xml = XML(this.loader.data);
      this.loader = null;
      completeTask();
   }
}
