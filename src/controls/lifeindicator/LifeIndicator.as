package controls.lifeindicator
{
   import controls.resultassets.WhiteFrame;
   
   public class LifeIndicator extends WhiteFrame
   {
       
      
      private var lineCharge:LineCharge;
      
      private var lineLife:LineLife;
      
      private var _charge:Number = 1;
      
      private var _life:Number = 1;
      
      public function LifeIndicator()
      {
         super();
         this.lineCharge = new LineCharge();
         this.lineCharge.x = 6;
         this.lineCharge.y = 22;
         addChild(this.lineCharge);
         this.lineLife = new LineLife();
         addChild(this.lineLife);
         this.lineLife.x = 6;
         this.lineLife.y = 6;
      }
      
      override public function draw() : void
      {
         super.draw();
         this.charge = this._charge;
         this.life = this._life;
      }
      
      public function set charge(value:Number) : void
      {
         if(this._charge == value)
         {
            return;
         }
         this._charge = value;
         this.lineCharge.setWidth((_width - 12) * this._charge);
      }
      
      public function set life(value:Number) : void
      {
         if(this._life == value)
         {
            return;
         }
         this._life = value;
         this.lineLife.setWidth((_width - 12) * this._life);
      }
   }
}
