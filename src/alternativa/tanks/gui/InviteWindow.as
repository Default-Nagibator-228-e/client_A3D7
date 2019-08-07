package alternativa.tanks.gui
{
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class InviteWindow extends Sprite
   {
       
      
      private var windowSize:Point;
      
      private const windowMargin:int = 11;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const inputWidth:int = 300;
      
      private var window:TankWindow;
      
      private var label:Label;
      
      private var input:TankInput;
      
      private var okButton:DefaultButton;
      
      public function InviteWindow()
      {
         super();
         this.window = new TankWindow();
         addChild(this.window);
         this.window.width = this.inputWidth + this.windowMargin * 2;
         this.label = new Label();
         addChild(this.label);
         this.label.bold = true;
         this.label.text = "Please, enter your invite code and keep it:";
         this.label.x = Math.round((this.window.width - this.label.textWidth) * 0.5) - 7;
         this.label.y = this.windowMargin;
         this.input = new TankInput();
         addChild(this.input);
         this.input.width = this.inputWidth;
         this.input.x = Math.round((this.window.width - this.input.width) * 0.5) + 5;
         this.input.y = this.label.y + this.label.textHeight + 5;
         this.okButton = new DefaultButton();
         addChild(this.okButton);
         this.okButton.label = "Ok";
         this.okButton.x = Math.round((this.window.width - this.buttonSize.x) * 0.5);
         this.okButton.y = this.input.y + this.input.height + 5;
         this.okButton.addEventListener(MouseEvent.CLICK,this.onOkButtonClick);
         this.window.height = this.okButton.y + this.buttonSize.y + this.windowMargin;
      }
      
      private function onOkButtonClick(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get code() : String
      {
         return this.input.textField.text;
      }
      
      public function showInviteError() : void
      {
         this.label.text = "Invite code is not valid";
         this.label.color = 6684672;
         this.label.thickness = 100;
         this.label.sharpness = -100;
         this.label.x = Math.round((this.window.width - this.label.textWidth) * 0.5) - 7;
      }
   }
}
