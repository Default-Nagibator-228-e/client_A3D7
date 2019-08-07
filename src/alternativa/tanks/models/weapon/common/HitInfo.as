package alternativa.tanks.models.weapon.common
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public class HitInfo
   {
       
      
      public var distance:Number;
      
      public var body:Body;
      
      public var position:Vector3;
      
      public var direction:Vector3;
      
      public var normal:Vector3;
      
      public function HitInfo()
      {
         this.position = new Vector3();
         this.direction = new Vector3();
         this.normal = new Vector3();
         super();
      }
   }
}
