package alternativa.tanks.bg
{
   import flash.geom.Rectangle;
   
   public interface IBackgroundService
   {
	   
      function bgCropRect1() :Rectangle;
      
      function showBg() : void;
      
      function hideBg() : void;
      
      function drawBg(param1:Rectangle = null) : void;
   }
}
