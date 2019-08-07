package alternativa.tanks.gui
{
   import flash.events.Event;
   
   public class ReferalWindowEvent extends Event
   {
      
      public static const SEND_MAIL:String = "ReferalWindowEventSendMail";
       
      
      public var adresses:String;
      
      public var letterText:String;
      
      public function ReferalWindowEvent(type:String, addresses:String = "", letterText:String = "")
      {
         super(type);
         this.adresses = addresses;
         this.letterText = letterText;
      }
   }
}
