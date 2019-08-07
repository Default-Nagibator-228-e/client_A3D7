package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   
   public interface ISound3DEffect extends ISpecialEffect
   {
       
      
      function set enabled(param1:Boolean) : void;
      
      function readPosition(param1:Vector3) : void;
      
      function get numSounds() : int;
   }
}
