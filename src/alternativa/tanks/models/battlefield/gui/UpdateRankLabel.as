package alternativa.tanks.models.battlefield.gui
{
   import alternativa.init.Main;
   import controls.Label;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class UpdateRankLabel extends Sprite
   {
       
      
      private var time:int = 0;
      
      private var _alpha:Number = 1.0;
      
      private var welcome:Label;
      
      private var rankNotification:Label;
      
      public function UpdateRankLabel(rankName:String)
      {
         this.welcome = new Label();
         this.rankNotification = new Label();
         super();
         this.welcome.size = 20;
         this.rankNotification.size = 20;
         this.welcome.textColor = 16777011;
         this.rankNotification.textColor = 16777011;
         var glow:GlowFilter = new GlowFilter(0);
         this.filters = [glow];
         this.welcome.text = "Поздравляем!";
         this.rankNotification.text = "Вы получили звание «" + rankName + "»";
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onDeleteFromFrame);
      }
      
      private function onAdded(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.ENTER_FRAME,this.update);
         Main.stage.addEventListener(Event.RESIZE,this.resize);
         addChild(this.welcome);
         addChild(this.rankNotification);
         this.resize(null);
      }
      
      public function resize(e:Event) : void
      {
         this.welcome.x = Main.stage.stageWidth - this.welcome.width >>> 1;
         this.welcome.y = Main.stage.stageHeight / 2 - this.height / 2 - this.rankNotification.height;
         this.rankNotification.x = Main.stage.stageWidth - this.rankNotification.width >>> 1;
         this.rankNotification.y = this.welcome.y + this.rankNotification.height;
      }
      
      private function update(e:Event) : void
      {
         this.time = this.time + 20;
         if(this.time >= 2500)
         {
            this._alpha = this._alpha - 0.05;
            this.alpha = this._alpha;
            if(this._alpha <= 0.01)
            {
               removeEventListener(Event.ENTER_FRAME,this.update);
               removeEventListener(Event.RESIZE,this.resize);
               this.filters = [];
               this.onDeleteFromFrame(null);
            }
         }
      }
      
      private function onDeleteFromFrame(e:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onDeleteFromFrame);
         removeChild(this.welcome);
         removeChild(this.rankNotification);
         Main.contentUILayer.removeChild(this);
      }
   }
}
