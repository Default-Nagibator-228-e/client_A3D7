package alternativa.tanks.gui
{
   import controls.TankWindowHeader;
   import flash.events.Event;
   import forms.Alert;
   
   public class ExternalLinkAlert extends Alert
   {
       
      
      public function ExternalLinkAlert()
      {
         super();
      }
      
      override protected function doLayout(e:Event) : void
      {
         //bgWindow.header = TankWindowHeader.ATTANTION;
         super.doLayout(e);
      }
   }
}
