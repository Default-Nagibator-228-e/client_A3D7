package alternativa.tanks.model
{
   import alternativa.tanks.gui.resource.images.ImageResouce;
   
   public interface IGarage
   {
       
      
      function setHull(param1:String) : void;
      
      function setTurret(param1:String) : void;
      
      function setColorMap(param1:ImageResouce) : void;
   }
}
