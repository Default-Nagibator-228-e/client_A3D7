package alternativa.tanks.loader
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ProcessBlock extends Sprite
   {
       
      
      public var processId:Object;
      
      public var progressBar:ProgressBar;
      
      public var statusLabel:TextField;
      
      public function ProcessBlock(processId:Object)
      {
         super();
         this.processId = processId;
         var tf:TextFormat = new TextFormat("Tahoma",10,16777215);
         this.statusLabel = new TextField();
         this.statusLabel.text = "Status";
         this.statusLabel.defaultTextFormat = tf;
         this.statusLabel.wordWrap = true;
         this.statusLabel.multiline = true;
         this.statusLabel.selectable = false;
         addChild(this.statusLabel);
         this.statusLabel.x = 43;
         this.statusLabel.width = 192;
         this.progressBar = new ProgressBar();
         addChild(this.progressBar);
         this.progressBar.y = 15;
      }
   }
}
