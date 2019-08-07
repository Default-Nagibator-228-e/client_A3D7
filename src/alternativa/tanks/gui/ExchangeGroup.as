package alternativa.tanks.gui
{
   import controls.NumStepper;
   import controls.TankInput;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextFieldType;
   import flash.text.TextFormatAlign;
   
   public class ExchangeGroup extends Sprite
   {
      [Embed(source="ex/1.png")]
      private static const bitmapCrystal:Class;
      
      private static const crystalBd:BitmapData = new bitmapCrystal().bitmapData;
      [Embed(source="ex/2.png")]
      private static const bitmapExchange:Class;
      
      private static const exchangeBd:BitmapData = new bitmapExchange().bitmapData;
       
      
      private var input:NumStepper;
      
      private var output:TankInput;
      
      private var crystalIcon:Bitmap;
      
      private var exchangeIcon:Bitmap;
      
      private var inputMaxValue:int;
      
      private const spaceModule:int = 3;
      
      private var _outputValue:Number;
      
      public function ExchangeGroup(inputMaxValue:int)
      {
         super();
         this.inputMaxValue = inputMaxValue;
         this.input = new NumStepper();
         addChild(this.input);
         this.input.minValue = 0;
         this.input.maxValue = inputMaxValue;
         this.input.addEventListener(Event.CHANGE,this.onInputChange);
         this.input.x = -15;
         this.crystalIcon = new Bitmap(crystalBd);
         addChild(this.crystalIcon);
         this.exchangeIcon = new Bitmap(exchangeBd);
         addChild(this.exchangeIcon);
         this.output = new TankInput();
         this.output.textField.type = TextFieldType.DYNAMIC;
         addChild(this.output);
         this.output.align = TextFormatAlign.RIGHT;
         this.exchangeIcon.y = this.output.height - this.exchangeIcon.height >> 1;
         this.output.textField.text = "—";
      }
      
      public function resize(width:int) : void
      {
         this.crystalIcon.x = 77 + this.spaceModule;
         this.exchangeIcon.x = this.crystalIcon.x + this.crystalIcon.width + this.spaceModule * 2;
         this.output.x = this.exchangeIcon.x + this.exchangeIcon.width + this.spaceModule * 2;
         this.output.width = width - this.output.x - 4;
      }
      
      public function reset() : void
      {
         if(this.input.value != 0)
         {
            this.input.value = 0;
         }
         if(this.output.textField.text != "—")
         {
            this.output.textField.text = "—";
         }
      }
      
      public function get inputValue() : int
      {
         return this.input.value;
      }
      
      public function set inputValue(value:int) : void
      {
         if(this.input.value != value)
         {
            this.input.value = value;
         }
      }
      
      public function get outputValue() : Number
      {
         return Math.round(this._outputValue * 100 + 0.4) / 100;
      }
      
      public function set outputValue(value:Number) : void
      {
         var result:String = null;
         var index:int = 0;
         if(this._outputValue != value)
         {
            this._outputValue = value;
            if(value <= 0)
            {
               this.output.textField.text = "—";
            }
            else
            {
               result = (Math.round(value * 100 + 0.4) / 100).toString();
               index = result.indexOf(".");
               if(index != -1)
               {
                  if(index == result.length - 2)
                  {
                     result = result + "0";
                  }
               }
               else
               {
                  result = result + ".00";
               }
               this.output.textField.text = result;
            }
         }
      }
      
      public function set currency(value:String) : void
      {
         if(value != "")
         {
            this.output.textField.text = this.output.textField.text.split(" ")[0] + " " + value;
         }
         else
         {
            this.output.textField.text = this.output.textField.text.split(" ")[0];
         }
      }
      
      private function onInputChange(e:Event) : void
      {
         if(this.input.value > this.inputMaxValue)
         {
            this.input.value = this.inputMaxValue;
         }
         dispatchEvent(new Event(Event.CHANGE,true,false));
      }
   }
}
