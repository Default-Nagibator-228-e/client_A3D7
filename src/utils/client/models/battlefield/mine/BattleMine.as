package utils.client.models.battlefield.mine
{
   public class BattleMine
   {
       
      
      public var mineId:String;
      
      public var ownerId:String;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var activated:Boolean;
      
      public function BattleMine(activated:Boolean, mineId:String, ownerId:String, x:Number, y:Number, z:Number)
      {
         super();
         this.activated = activated;
         this.mineId = mineId;
         this.ownerId = ownerId;
         this.x = x;
         this.y = y;
         this.z = z;
      }
   }
}
