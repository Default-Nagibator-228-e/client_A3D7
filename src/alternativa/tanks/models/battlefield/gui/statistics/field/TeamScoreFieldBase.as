package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import controls.Label;
   import controls.resultassets.WhiteFrame;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextFieldAutoSize;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class TeamScoreFieldBase extends Sprite
   {
      
      private static const LABEL_Y:int = 6;
      
      protected static const BG_COLOR_RED:uint = 9249024;
      
      protected static const FONT_COLOR_RED:uint = 16742221;
      
      protected static const BG_COLOR_BLUE:uint = 16256;
      
      protected static const FONT_COLOR_BLUE:uint = 4760319;
       
      
      protected var _scoreRed:int;
      
      protected var _scoreBlue:int;
      
      protected var labelRed:Label;
      
      protected var labelBlue:Label;
      
      private var background:Shape;
      
      protected var border:WhiteFrame;
      
      public function TeamScoreFieldBase()
      {
         super();
         addChild(this.background = new Shape());
         addChild(this.border = new WhiteFrame());
         this.labelRed = this.createLabel(FONT_COLOR_RED);
         this.labelBlue = this.createLabel(FONT_COLOR_BLUE);
      }
      
      public function setScore(scoreRed:int, scoreBlue:int) : void
      {
         this._scoreRed = scoreRed;
         this.labelRed.text = scoreRed.toString();
         this._scoreBlue = scoreBlue;
         this.labelBlue.text = scoreBlue.toString();
         this.update();
      }
      
      public function setTeamScore(teamType:BattleTeamType, score:int) : void
      {
         switch(teamType)
         {
            case BattleTeamType.RED:
               this.scoreRed = score;
               break;
            case BattleTeamType.BLUE:
               this.scoreBlue = score;
         }
         this.update();
      }
      
      public function get scoreRed() : int
      {
         return this._scoreRed;
      }
      
      public function set scoreRed(value:int) : void
      {
         this._scoreRed = value;
         this.labelRed.text = value.toString();
         this.update();
      }
      
      public function get scoreBlue() : int
      {
         return this._scoreBlue;
      }
      
      public function set scoreBlue(value:int) : void
      {
         this._scoreBlue = value;
         this.labelBlue.text = value.toString();
         this.update();
      }
      
      public function update() : void
      {
         this.updateBgAndBorder(this.calculateWidth());
      }
      
      protected function calculateWidth() : int
      {
         return 0;
      }
      
      private function updateBgAndBorder(width:int) : void
      {
         this.border.width = width;
         var fillType:String = GradientType.LINEAR;
         var colors:Array = [BG_COLOR_RED,BG_COLOR_BLUE];
         var alphas:Array = [1,1];
         var r:int = 8 / width * 255;
         var ratios:Array = [127 - r,127 + r];
         var borderWidth:int = 2;
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(width - borderWidth,this.border.height - borderWidth,0,0,0);
         var spreadMethod:String = SpreadMethod.PAD;
         var g:Graphics = this.background.graphics;
         g.clear();
         g.beginGradientFill(fillType,colors,alphas,ratios,matrix,spreadMethod);
         g.drawRect(borderWidth,borderWidth,width - 2 * borderWidth,this.border.height - borderWidth - 1);
         g.endFill();
      }
      
      private function createLabel(color:uint) : Label
      {
         var label:Label = new Label();
         label.color = color;
         label.size = 18;
         label.bold = true;
         label.autoSize = TextFieldAutoSize.CENTER;
         label.y = LABEL_Y;
         addChild(label);
         return label;
      }
   }
}
