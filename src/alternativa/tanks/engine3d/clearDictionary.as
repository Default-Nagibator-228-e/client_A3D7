package alternativa.tanks.engine3d
{
   import flash.utils.Dictionary;
   
   public function clearDictionary(param1:Dictionary) : void
   {
      var _loc2_:* = undefined;
      for(_loc2_ in param1)
      {
         delete param1[_loc2_];
      }
   }
}
