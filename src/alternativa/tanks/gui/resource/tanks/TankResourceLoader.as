package alternativa.tanks.gui.resource.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class TankResourceLoader
   {
       
      
      private var path:String;
      
      public var list:TankResourceList;
      
      private var queue:Vector.<TankResource>;
      
      private var length:int = 0;
      
      public var status:int = 0;
      
      public function TankResourceLoader(path:String)
      {
         super();
         this.path = path;
         this.list = new TankResourceList();
         this.queue = new Vector.<TankResource>();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(path));
      }
      
      private function parse(e:Event) : void
      {
         var obj:Object = null;
         var config:Object = JSON.parse(e.target.data);
         if(config.id == "MODELS")
         {
            for each(obj in config.items)
            {
               this.queue.push(new TankResource(null,obj.name,obj.src));
               this.length++;
            }
            this.loadQueue();
         }
      }
      
      private function loadQueue() : void
      {
         var file:TankResource = null;
         for each(file in this.queue)
         {
            this.loadModel(file);
         }
      }
      
      private function loadModel(str:TankResource) : void
      {
         var prefix:String = null;
         var loader:URLLoader = null;
         prefix = Game.local?"":"resources/";
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(Event.COMPLETE,function(e:Event):void
         {
            var flagMount:Vector3D = null;
            var turretMount:Vector3D = null;
            var obj:Object3D = null;
            var tnk:TankResource = null;
            var bytes:ByteArray = ByteArray(e.currentTarget.data);
            var parser:Parser3DS = new Parser3DS();
            var muzzles:Vector.<Vector3D> = new Vector.<Vector3D>();
            parser.parse(bytes);
            for each(obj in parser.objects)
            {
               if(obj.name.split("0")[0] == "muzzle")
               {
                  muzzles.push(new Vector3D(obj.x,obj.y,obj.z));
               }
               if(obj.name.indexOf("fmnt") >= 0)
               {
                  flagMount = new Vector3D(obj.x,obj.y,obj.z);
               }
               if(obj.name == "mount")
               {
                  turretMount = new Vector3D(obj.x,obj.y,obj.z);
               }
            }
            tnk = new TankResource(Mesh(parser.objects[0]),str.id,null,muzzles,flagMount,turretMount);
            tnk.objects = parser.objects;
            list.add(tnk);
            if(length != 1)
            {
               length--;
            }
            else
            {
               status = 1;
               ResourceUtil.onCompleteLoading();
            }
            muzzles = null;
         });
         loader.load(new URLRequest(prefix + (str.next as String)));
         loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
         {
            Main.debug.showAlert("Невозможно загрузить: " + (str.next as String));
         });
      }
   }
}
