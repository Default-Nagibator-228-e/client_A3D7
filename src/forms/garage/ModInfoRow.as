package forms.garage
{
   import alternativa.init.Main;
   import assets.Diamond;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import forms.garage.UpgradeIndicator;
   
   public class ModInfoRow extends Sprite
   {
       
      
      private const labelNormalColor:uint = 16777215;//59156;
      
      private const labelSelectedColor:uint = 0x71ea07;//676865;
      
      public var labels:Array;
      
      public var costLabel:Label;
      
      public var crystalIcon:Diamond;
      
      public var rankIcon:RangIconSmall;
      
      public var upgradeIndicator:UpgradeIndicator;
      
      public const h:int = 17;
      
      public const hSpace:int = 10;
      
      public var costWidth:int;
      
      public function ModInfoRow()
      {
         var label:Label = null;
         super();
         this.labels = new Array();
         for(var i:int = 0; i < 8; i++)
         {
            label = new Label();
            label.color = this.labelNormalColor;
            label.align = TextFormatAlign.CENTER;
            label.text = "ABC123";
            addChild(label);
            this.labels.push(label);
            label.y = this.h - label.height >> 1;
         }
         this.costLabel = new Label();
         this.costLabel.color = this.labelNormalColor;
         this.costLabel.align = TextFormatAlign.RIGHT;
         this.costLabel.text = "ABC123";
         addChild(this.costLabel);
         this.costLabel.y = this.h - this.costLabel.height >> 1;
         this.crystalIcon = new Diamond();
         addChild(this.crystalIcon);
         this.crystalIcon.y = this.h - this.crystalIcon.height >> 1;
         this.rankIcon = new RangIconSmall();
         addChild(this.rankIcon);
         this.rankIcon.y = (this.h - this.rankIcon.height >> 1) + 1;
         this.upgradeIndicator = new UpgradeIndicator();
         addChild(this.upgradeIndicator);
         this.upgradeIndicator.y = (this.h - this.upgradeIndicator.height >> 1) + 1;
      }
      
      public function select() : void
      {
         var label:Label = null;
         for(var i:int = 0; i < 8; i++)
         {
            label = this.labels[i] as Label;
            label.color = this.labelSelectedColor;
            label.sharpness = -25;
            label.thickness = 25;
         }
         //this.costLabel.color = this.labelSelectedColor;
         //this.costLabel.sharpness = -100;
         //this.costLabel.thickness = 100;
      }
      
      public function unselect() : void
      {
         var label:Label = null;
         for(var i:int = 0; i < 8; i++)
         {
            label = this.labels[i] as Label;
            label.color = this.labelNormalColor;
            label.sharpness = 25;
            label.thickness = -25;
         }
         //this.costLabel.color = this.labelNormalColor;
         this.costLabel.sharpness = 50;
         this.costLabel.thickness = -50;
      }
      
      public function setLabelsNum(num:int) : void
      {
         for(var i:int = 0; i < this.labels.length; i++)
         {
            if(i < num)
            {
               (this.labels[i] as Label).visible = true;
            }
            else
            {
               (this.labels[i] as Label).visible = false;
            }
         }
      }
      
      public function setLabelsText(text:Array) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","setLabelsText: %1",text);
         for(var i:int = 0; i < text.length; i++)
         {
            if(text[i] != null && text[i] != "" && text[i] != "null")
            {
               (this.labels[i] as Label).text = text[i];
            }
            else
            {
               (this.labels[i] as Label).text = "—";
            }
         }
      }
      
      public function setLabelsPos(coords:Array) : void
      {
         var l:Label = null;
         for(var i:int = 0; i < coords.length; i++)
         {
            l = this.labels[i] as Label;
            l.x = coords[i] - Math.round(l.textWidth * 0.5) - 3;
         }
      }
      
      public function setConstPartCoord(value:int,vd:int) : void
      {
         this.costLabel.x = vd - this.crystalIcon.width - costLabel.textWidth;
		 this.upgradeIndicator.x = value;//this.rankIcon.x - this.hSpace*3;
		 this.rankIcon.x = this.upgradeIndicator.x + this.upgradeIndicator.width + 10;
         this.crystalIcon.x = vd;//this.rankIcon.x + this.rankIcon.width + this.hSpace + this.costWidth + 3;
      }
   }
}
