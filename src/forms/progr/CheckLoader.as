package forms.progr
{
   import alternativa.init.Main;
   import controls.TankWindow;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import forms.progr.CProg;
   import forms.progr.Progress;
   
   public class CheckLoader extends Sprite
   {
	  
      private var image:Bitmap = IS.getRandomPict();
      
      private var layer:DisplayObjectContainer;
      
      private var statusLabel:TextField;
      
      private const tubeR:Number = 10.5;
      
      private var tubeL:Number = 7000;
      
      private var showTimer:Timer;
      
      private var hideTimer:Timer;
      
      private var showDelay:int = 0;
      
      private var hideDelay:int = 10000;
      
      private var currentProcessId:Array;
      
      private var lock:Boolean = false;
      
      private var window:TankWindow = new TankWindow(610,290);
      
      private var newType:Boolean;
      
      private var g:Sprite;
      
      private var _prog:Number = 0;
	  
	  private var prog:int = 0;
      
      private var t:Number = 0;
	  
	  private var j1:CProg = new CProg();
      
      public function CheckLoader()
      {
		 super();
		 this.newType = false;
		 this.currentProcessId = new Array();
		 //j.redrawProgressLineAndBlick(200);
		 this.layer = Main.systemUILayer;
		 var tf:TextFormat = new TextFormat("Tahoma",10,16777215);
		 this.statusLabel = new TextField();
		 this.statusLabel.text = "Status";
		 this.statusLabel.defaultTextFormat = tf;
		 this.statusLabel.wordWrap = true;
		 this.statusLabel.multiline = true;
		 this.statusLabel.y = 38;
		 this.statusLabel.x = 70;
		 this.statusLabel.width = 172;
		 var filters:Array = new Array();
		 filters.push(new BlurFilter(3,0,BitmapFilterQuality.LOW));
		 this.showTimer = new Timer(this.showDelay,1);
		 this.hideTimer = new Timer(this.hideDelay,1);
		 this.changeProgress(0, 0);
		 this.onShowTimerComplemete(null);
		 this.unlockLoaderWindow();
		 addChild(this.window);
		this.image.x = 10;
		this.image.y = 11;
		addChild(this.image);
		addChild(j1);
		j1.start();
		var t_i:Timer = new Timer(Math.random() * 7000,1);
		t_i.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChangeImage);
		t_i.reset();
		t_i.start();
      }
      
      private function onChangeImage(t:TimerEvent) : void
      {
         var time:Number = NaN;
		 if (this.image != null)
		 {
			removeChild(this.image);
		 }
         this.image = IS.getRandomPict();
         this.image.x = 10;
         this.image.y = 11;
         addChild(this.image);
         var tu:Timer = new Timer((time = Number(Math.random() * 7000)) <= 2000?Number(7000):Number(time),1);
         tu.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChangeImage);
         tu.start();
      }
      
      public function focusIn(focusedObject:Object) : void
      {
      }
      
      public function focusOut(exfocusedObject:Object) : void
      {
      }
      
      public function deactivate() : void
      {
         if(!this.lock)
         {
            this.hideLoaderWindow();
            this.lockLoaderWindow();
         }
      }
      
      public function activate() : void
      {
         if(this.lock)
         {
            this.unlockLoaderWindow();
         }
      }
      
      public function changeStatus(processId:int, value:String) : void
      {
         var s:String = null;
         if(value.length > 100)
         {
            s = value.slice(0,99) + "...";
         }
         else
         {
            s = value;
         }
         this.statusLabel.text = value;
      }
      
      public function changeProgress(processId:int, value:Number) : void
      {
		 
         var index:int = 0;
         if(value == 0)
         {
            this.hideTimer.stop();
            this.currentProcessId.push(processId);
            if(!this.lock && !this.showTimer.running && !this.layer.contains(this))
            {
               this.showTimer.reset();
               this.showTimer.start();
            }
         }
         else if(value == 1)
         {
            index = this.currentProcessId.indexOf(processId);
            if(index != -1)
            {
               this.currentProcessId.splice(index,1);
            }
            if(this.currentProcessId.length == 0)
            {
               if(this.showTimer.running)
               {
                  this.showTimer.stop();
               }
               else if(!this.hideTimer.running)
               {
                  if(!this.lock)
                  {
                     this.hideTimer.reset();
                     this.hideTimer.start();
                  }
               }
               else if(this.lock)
               {
                  this.hideTimer.stop();
               }
            }
         }
      }
      
      public function hideLoaderWindow() : void
      {
         this.showTimer.stop();
         this.onHideTimerComplemete();
      }
      
      public function lockLoaderWindow() : void
      {
         if(!this.lock)
         {
            this.lock = true;
            this.showTimer.stop();
            this.hideTimer.stop();
         }
      }
      
      public function unlockLoaderWindow() : void
      {
         if(this.lock)
         {
            this.lock = false;
         }
      }
      
      private function onShowTimerComplemete(e:TimerEvent) : void
      {
         this.show();
      }
      
      private function onHideTimerComplemete(e:TimerEvent = null) : void
      {
         this.hideTimer.stop();
         this.hide();
      }
      
      private function show() : void
      {
		  this.visible = true;
			 if(!this.layer.contains(this))
			 {
				this.layer.addChild(this);
				Main.stage.addEventListener(Event.RESIZE,this.align);
				this.align();
			 }
      }
      
      private function hide() : void
      {
			 if(this.layer.contains(this))
			 {
				Main.stage.removeEventListener(Event.RESIZE,this.align);
				this.layer.removeChild(this);
			 }
      }
      
      public function setFullAndClose(e:Event) : void
      {
         if(this.t <= 500 && this.t > 0)
         {
			 this.visible = false;
			prog = 0;
			j1.forciblyFinish();
			j1.forciblyStop();
         }
         else
         {
			this.visible = true;
			j1.redrawProgressLineAndBlick(0);
			j1.start();
			 this.hideLoaderWindow();
         }
      }
      
      private function align(e:Event = null) : void
      {
			j1.x = 10;
			if (image != null)
			{
				j1.y = 20 + image.height;
			}
			this.x = Main.stage.stageWidth - this.window.width >>> 1;
			this.y = Main.stage.stageHeight - this.window.height >>> 1;
      }
      
      public function addProgress(p:Number) : void
      {
		 this.show();
		 prog += p;
		j1.start();
		j1.redrawProgressLineAndBlick(prog);
         this.t = this._prog;
         this._prog = this._prog + p;
         this.tubeL = 7000;
      }
      
      public function setProgress(p:Number) : void
      {
         this.show();
		 prog = p;
		j1.start();
		j1.redrawProgressLineAndBlick(prog);
		 this._prog = p;
         this.tubeL = 7000;
         this.t = 0;
      }
   }
}
