package alternativa.tanks.models.battlefield
{
   import alternativa.engine3d.objects.SkyBox;
   import utils.client.models.ClientObject;
   import alternativa.physics.PhysicsScene;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import flash.display.DisplayObjectContainer;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;
   
   public class BattlefieldData
   {
       
      
      public var bfObject:ClientObject;
      
      public var localUser:ClientObject;
      
      public var guiContainer:DisplayObjectContainer;
      
      public var viewport:BattleView3D;
      
      public var tanks:Dictionary;
      
      public var activeTanks:Dictionary;
      
      public var graphicEffects:Dictionary;
      
      public var bonuses:Dictionary;
      
      public var bonusTakenSound:Sound;
      
      public var battleFinishSound:Sound;
      
      public var ambientSound:Sound;
      
      public var ambientChannel:SoundChannel;
      
      public var killSound:Sound;
      
      public var physicsScene:PhysicsScene;
      
      public var collisionDetector:TanksCollisionDetector;
      
      public var physTime:int;
      
      public var time:int;
      
      public var skybox:SkyBox;
      
      public var respawnInvulnerabilityPeriod:int;
      
      public var idleKickPeriod:int;
      
      public function BattlefieldData()
      {
         this.tanks = new Dictionary();
         this.activeTanks = new Dictionary();
         this.graphicEffects = new Dictionary();
         this.bonuses = new Dictionary();
         super();
      }
   }
}
