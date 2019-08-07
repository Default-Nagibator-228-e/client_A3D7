package alternativa.tanks.models.battlefield.gui.statistics.fps
{
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import controls.Label;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   import utils.FontParamsUtil;
   
   public class FPSText extends Sprite
   {
       
      
      private const OFFSET_X:int = 55;
      
      private const OFFSET_Y:int = 90;
      
      private const FPS_OFFSET_X:int = 45;
      
      private const NUM_FRAMES:int = 30;
      
      public static var fps:Label;
      
      private var label:Label;
      
      private var tfDelay:int = 0;
      
      private var tfTimer:int;
	  
	  private var tf:int = 0;
      
      public function FPSText()
      {
         fps = new Label();
         this.label = new Label();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(e:Event) : void
      {
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.color = 16777215;
         this.label.text = "FPS: ";
         this.label.selectable = false;
		 label.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
         label.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
         addChild(this.label);
         fps.autoSize = TextFieldAutoSize.RIGHT;
		 fps.filters = [new GlowFilter(0,0.8,4,4,3)];
		 fps.bold = true;
		 fps.sharpness = FontParamsUtil.SHARPNESS_LABEL_BASE;
         fps.thickness = FontParamsUtil.THICKNESS_LABEL_BASE;
         addChild(fps);
         this.tfTimer = getTimer();
         this.onResize(null);
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(Event.RESIZE, this.onResize);
		 removeChild(label);
		 removeChild(fps);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var delta:uint = 0;
         if(++this.tfDelay >= this.NUM_FRAMES)
         {
            delta = this.tfTimer;
            this.tfTimer = getTimer();
            delta = this.tfTimer - delta;
			tf = int(Number(1000 * this.tfDelay / delta).toFixed(2));
            fps.text = "" + tf;
			fps.textColor = 0xFF0000;//Меняет цвет на красный, если FPS меньше 10. 
			 if(tf>20) 
			 { 
			  fps.textColor = 0xFFFF00; //Меняет цвет на желтый, если FPS больше 10, но меньше 25 
			 } 
			 if(tf>35) 
			 { 
			  fps.textColor = 0x33FF00; //Меняет цвет на зеленый, если FPS больше 25. 
			 } 
            this.tfDelay = 0;
         }
		 if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
		 {
			 if (fps != null && Main.contentUILayer.contains(fps))
			 {
				Main.contentUILayer.removeChild(fps);
			 }
			 return;
		 }
      }
      
      private function onResize(e:Event) : void
      {
         x = stage.stageWidth - this.OFFSET_X;
         y = stage.stageHeight - this.OFFSET_Y;
         fps.x = this.FPS_OFFSET_X - fps.width;
      }
   }
}
