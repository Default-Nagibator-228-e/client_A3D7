package alternativa.tanks.models.effectsvisualization
{
   public class ClientBattleEffect
   {
       
      
      public var receiveTime:int;
      
      public var userId:String;
      
      public var effectId:int;
      
      public var duration:int;
      
      public function ClientBattleEffect(receiveTime:int, userId:String, effectId:int, duration:int)
      {
         super();
         this.receiveTime = receiveTime;
         this.userId = userId;
         this.effectId = effectId;
         this.duration = duration;
      }
   }
}
