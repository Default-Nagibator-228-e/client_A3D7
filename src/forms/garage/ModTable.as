package forms.garage
{
   import controls.Label;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class ModTable extends Sprite
   { 
      
      private var _maxCostWidth:int;
      
      public var constWidth:int;
      
      public var rows:Array;
      
      public const vSpace:int = 0;
      
      private var selection:Sprite;
      
      public var selectedRowIndex:int = -1;
      
      public function ModTable()
      {
         var row:ModInfoRow = null;
         super();
         this.rows = new Array();
         this.selection = new Sprite();
         addChild(this.selection);
		 this.selection.graphics.clear();
		 this.selection.graphics.beginFill(0x1f9611);
		 this.selection.graphics.drawRoundRect(0, 0, 200, 100, 6, 6);
         this.selection.x = 4;
         for(var i:int = 0; i < 4; i++)
         {
            row = new ModInfoRow();
            addChild(row);
            row.y = (row.h + this.vSpace) * i;
            this.rows.push(row);
            row.upgradeIndicator.value = i;
         }
      }
      
      public function select(index:int) : void
      {
         var row:ModInfoRow = null;
         if(this.selectedRowIndex != -1)
         {
            row = ModInfoRow(this.rows[this.selectedRowIndex]);
            row.unselect();
         }
         this.selectedRowIndex = index;
         this.selection.y = (ModInfoRow(this.rows[0]).h + this.vSpace) * index;
         row = ModInfoRow(this.rows[this.selectedRowIndex]);
         row.select();
      }
      
      public function resizeSelection(w:int) : void
      {
         var width:int = w;
		 this.selection.graphics.clear();
		 this.selection.graphics.beginFill(0x1f9611);
		 this.selection.graphics.drawRoundRect(0, 0, w, 18, 6, 6);
      }
      
      public function correctNonintegralValues() : void
      {
         var n:int = 0;
         var label:Label = null;
         var index:int = 0;
         var nonintegralIndexes:Array = new Array();
         var row:ModInfoRow = this.rows[0] as ModInfoRow;
         var l:int = row.labels.length;
         for(var i:int = 0; i < 4; i++)
         {
            row = this.rows[i] as ModInfoRow;
            for(n = 0; n < l; n++)
            {
               label = row.labels[n] as Label;
               if(label.text.indexOf(".") != -1)
               {
                  nonintegralIndexes.push(n);
               }
            }
         }
         for(i = 0; i < 4; i++)
         {
            row = this.rows[i];
            for(n = 0; n < nonintegralIndexes.length; n++)
            {
               index = nonintegralIndexes[n];
               label = row.labels[index] as Label;
               if(label.text.indexOf(".") == -1)
               {
                  label.text = label.text + ".0";
               }
            }
         }
      }
      
      public function get maxCostWidth() : int
      {
         return this._maxCostWidth;
      }
      
      public function set maxCostWidth(value:int) : void
      {
         this._maxCostWidth = value;
         var row:ModInfoRow = this.rows[0] as ModInfoRow;
         this.constWidth = row.upgradeIndicator.width + row.rankIcon.width + 3 + row.crystalIcon.width + this._maxCostWidth + row.hSpace * 3;
         for(var i:int = 0; i < 4; i++)
         {
            row = this.rows[i] as ModInfoRow;
            row.costWidth = this._maxCostWidth;
         }
      }
   }
}
