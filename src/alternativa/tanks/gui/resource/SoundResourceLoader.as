package alternativa.tanks.gui.resource
{
   import alternativa.init.Main;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class SoundResourceLoader
   {
       
      
      private var path:String;
      
      public var list:SoundResourcesList;
      
      public var status:int = 0;
      
      public function SoundResourceLoader(path:String)
      {
         super();
         this.path = path;
         this.list = new SoundResourcesList();
         this.load();
      }
      
      private function load() : void
      {
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(this.path));
      }
      
      private function parse(e:Event) : void
      {
         var prefix:String = null;
         var config:Object = null;
         var obj:Object = null;
         try
         {
            prefix = Game.local?"":"resources/";
            config = JSON.parse(e.target.data);
            if(config.id == "SOUNDS")
            {
               for each(obj in config.items)
               {
                  this.list.add(new SoundResource(new Sound(new URLRequest(prefix + obj.src)),obj.name));
               }
               this.status = 1;
               ResourceUtil.onCompleteLoading();
            }
            else
            {
			   Main.debug.showAlert("Типовая ошибка загрузчика: " + obj.src);
               throw new Error("Ошибка");
            }
         }
         catch(e:Error)
         {
            Main.debug.showAlert("Невозможно загрузить: " + obj.src);
            throw new Error("Ошибка");
         }
      }
   }
}
