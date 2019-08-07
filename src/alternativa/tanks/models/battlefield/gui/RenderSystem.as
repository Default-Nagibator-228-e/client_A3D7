package alternativa.tanks.models.battlefield.gui
{
   import alternativa.engine3d.core.Camera3D;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class RenderSystem
   {
       
      
      private var camera:Camera3D;
      
      private var _stage:Stage;
      
      public function RenderSystem(camera:Camera3D, _stage:Stage)
      {
         super();
         this.camera = camera;
         this._stage = _stage;
         //this._stage.addEventListener(Event.ENTER_FRAME,this.enterFrame);
      }
      
      private function enterFrame(e:Event) : void
      {
		 //throw new Error();
         //this.camera.render();
      }
   }
}
