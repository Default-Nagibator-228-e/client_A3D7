package alternativa.tanks.models.weapon.shared
{
   import alternativa.physics.Body;
   
   public interface ICommonTargetEvaluator
   {
       
      
      function getTargetPriority(param1:Body, param2:Number, param3:Number) : Number;
   }
}
