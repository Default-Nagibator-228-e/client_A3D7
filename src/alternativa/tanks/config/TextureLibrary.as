package alternativa.tanks.config
{
   import utils.StringUtils;
   import utils.TaskSequence;
   import flash.display.BitmapData;
   import flash.events.Event;
   
   public class TextureLibrary extends ResourceLoader
   {
       
      
      private var textures:Object;
      
      private var dummyTexture:BitmapData;
      
      private var sequence:TaskSequence;
      
      public function TextureLibrary(config:Config)
      {
         this.textures = {};
         super("Texture library loader",config);
      }
      
      public function getTexture(textureId:String) : BitmapData
      {
         return this.textures[textureId] || this.getDummyTexture();
      }
      
      public function addTexture(id:String, bitmapData:BitmapData) : void
      {
         this.textures[id] = bitmapData;
      }
      
      override public function run() : void
      {
         var elem:XML = null;
         var texuresXml:XML = config.xml.textures[0];
         var baseUrl:String = StringUtils.makeCorrectBaseUrl(texuresXml.@baseUrl);
         this.sequence = new TaskSequence();
         for each(elem in texuresXml.texture)
         {
            this.sequence.addTask(new TextureLoader(elem.@id,baseUrl + elem.@url,this));
         }
         this.sequence.addEventListener(Event.COMPLETE,this.onSequenceComplete);
         this.sequence.run();
      }
      
      private function onSequenceComplete(event:Event) : void
      {
         this.sequence = null;
         completeTask();
      }
      
      private function getDummyTexture() : BitmapData
      {
         var SIZE:int = 0;
         var color:uint = 0;
         var i:int = 0;
         var j:int = 0;
         if(this.dummyTexture == null)
         {
            SIZE = 100;
            color = 16711935;
            this.dummyTexture = new BitmapData(SIZE,SIZE,false,0);
            for(i = 0; i < SIZE; i++)
            {
               for(j = 0; j < SIZE; j = j + 2)
               {
                  this.dummyTexture.setPixel(!!Boolean(i % 2)?int(int(j)):int(int(j + 1)),i,color);
               }
            }
         }
         return this.dummyTexture;
      }
   }
}

import alternativa.tanks.config.TextureLibrary;
import utils.Task;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;

class TextureLoader extends Task
{
    
   
   private var id:String;
   
   private var url:String;
   
   private var library:TextureLibrary;
   
   private var loader:Loader;
   
   function TextureLoader(id:String, url:String, library:TextureLibrary)
   {
      super();
      this.id = id;
      this.url = url;
      this.library = library;
   }
   
   override public function run() : void
   {
      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadingComplete);
      this.loader.load(new URLRequest(this.url));
   }
   
   private function onLoadingComplete(event:Event) : void
   {
      this.library.addTexture(this.id,Bitmap(this.loader.content).bitmapData);
      completeTask();
   }
}
