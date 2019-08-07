package alternativa.tanks.gui.resource.images
{
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.resource.ImageResource;
   import alternativa.tanks.models.battlefield.decals.Queue;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
   import alternativa.tanks.gui.resource.ResourceUtil;
   
   public class ImageResourceLoader extends Sprite
   {
       
      
      public var path:String;
      
      public var list:ImageResourceList;
      
      public var queue:Vector.<ImageResouce>;
      
      public var status:int = 0;
      
      private var length:int = 0;
	  
	  public var time:uint = 0;
	  
	  public var timeFps:uint;
      
      private var fps:int = 0;
	  
	  private var fp:int = 30;
	  
	  private var storage:SharedObject = SharedObject.getLocal("zaoop");
	  
	  private var dt:Array = new Array();
	  
	  private var lob:String = "ImageResourceLoader";
	  
	  private var prefix:String = Game.local?"":"resources/";
      
      public function ImageResourceLoader(path:String)
      {
         super();
         this.path = path;
         this.list = new ImageResourceList();
         this.queue = new Vector.<ImageResouce>();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(path));
      }
      
      private function parse(e:Event) : void
      {
         var obj:Object = null;
         var multiframed:Boolean = false;
         var multiframeInfo:MultiframeResourceData = null;
         var config:Object = JSON.parse(e.target.data);
         if(config.id == "IMAGES")
         {
            for each(obj in config.items)
            {
               multiframed = obj.multiframe == null?Boolean(false):Boolean(obj.multiframe);
               multiframeInfo = null;
               if(multiframed)
               {
                  multiframeInfo = new MultiframeResourceData();
                  multiframeInfo.fps = obj.fps;
                  multiframeInfo.heigthFrame = obj.frame_heigth;
                  multiframeInfo.widthFrame = obj.frame_width;
                  multiframeInfo.numFrames = obj.num_frames;
               }
               this.queue.push(new ImageResouce(obj.src,obj.name,multiframed,multiframeInfo));
            }
			Main.stage.addEventListener(Event.ENTER_FRAME, rorty);
			//loadQueue();
         }
      }
	  
	  private function rorty(param1:Event) : void
      {
		  if (getTimer() - time > fp)
		  {
			  fp++;
		  }else{
			  fp--;
		  }
		  while (getTimer() - time < fp)
		  {
			if (this.queue.length > fps)
			{
				loadImage(this.queue[fps],length);
				length++;
			}else{
				Main.stage.removeEventListener(Event.ENTER_FRAME, rorty);
				status = 1;
				ResourceUtil.onCompleteLoading();
				return;
			}
			this.fps++;
		  }
		  time = getTimer();
      }
      
      private function loadQueue() : void
      {
         var obj:ImageResouce = null;
		 for each(obj in this.queue)
		 {
			loadImage(obj,length);
			length++;
		 }
		 /*
		 if(this.storage.data.zaoop == null)
         {
            for each(obj in this.queue)
			 {
				loadImage(obj);
				length++;
			 }
		 }else{
			 dt = this.storage.data.zaoop;
			 for each(obj in this.queue)
			 {
				obj.bitmapData = (dt[length] as Bitmap).bitmapData as BitmapData;
				if (obj.bitmapData == null)
				{
					for each(obj in this.queue)
					 {
						loadImage(obj);
						length++;
					 }
				}else{
					list.add(obj);
				}
				if(length + 1 == dt.length)
				{
					storage.data.zaoop = dt;
					status = 1;
					ResourceUtil.onCompleteLoading();
				}
				length++;
			 }
		 }
		 */
      }
      
      private function loadImage(img:ImageResouce, pf:int) : void
      {
		 //var tim:Timer = new Timer(length*10,1);
		 //tim.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:Event):void
		 //{
			 var loader:Loader = new Loader();
			 loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void
			 {
					//var tim:Timer = new Timer(length*10,1);
					//tim.addEventListener(TimerEvent.TIMER_COMPLETE, function(param1:Event):void
					//{
					//var info:LoaderInfo = LoaderInfo(event.target);
					//var bitmapData:BitmapData = new BitmapData(info.width,info.height,true,16777215);
					//bitmapData.draw(info.loader);
					//list.add(new ImageResouce(bitmapData, img.id, img.animatedMaterial, img.multiframeData));
					//dt.push(loader.content as Bitmap);
					img.bitmapData = (loader.content as Bitmap).bitmapData;
					//var brr:ByteArray = PNGEncoder.encode((loader.content as Bitmap).bitmapData);
					//var f:String = new String("");
					//brr.writeUTFBytes(f);
					//dt.push(f);
					list.add(img);
					if(length == 1)
					{
						//storage.data.zaoop = dt;
						//Main.stage.removeEventListener(Event.ENTER_FRAME,tick);
						/*
						if(storage.data.emailUser == null)
						 {
							storage.setProperty("emailUser",email);
						 }
						 */
						//status = 1;
						//ResourceUtil.onCompleteLoading();
					}
					length--;
					//});
					//tim.start();
			 });
			 loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
			 {
				Main.debug.showAlert("Невозможно загрузить: " + img.bitmapData);
			 });
			 loader.load(new URLRequest(prefix + img.bitmapData as String));
		 //});
		 //tim.start();
      }
   }
}
