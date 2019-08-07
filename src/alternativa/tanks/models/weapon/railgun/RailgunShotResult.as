package alternativa.tanks.models.weapon.railgun
{
   import alternativa.math.Vector3;
   
   public class RailgunShotResult
   {
       
      
      public var targets:Array;
      
      public var hitPoints:Array;
      
      public var dir:Vector3;
      
      public function RailgunShotResult()
      {
         this.targets = [];
         this.hitPoints = [];
         this.dir = new Vector3();
         super();
      }
   }
}
