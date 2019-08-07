package alternativa.tanks.engine3d
{
   import flash.display.BitmapData;
   
   public interface IMaterialSequenceRegistry
   {
       
      
      function set timerInterval(param1:int) : void;
      
      function get useMipMapping() : Boolean;
      
      function set useMipMapping(param1:Boolean) : void;
      
      function getSequence(param1:MaterialType, param2:BitmapData, param3:int, param4:Number, param5:Boolean = false, param6:Boolean = false) : MaterialSequence;
      
      function getSquareSequence(param1:MaterialType, param2:BitmapData, param3:Number, param4:Boolean = false, param5:Boolean = false) : MaterialSequence;
      
      function clear() : void;
      
      function getDump() : String;
      
      function disposeSequence(param1:MaterialSequence) : void;
   }
}
