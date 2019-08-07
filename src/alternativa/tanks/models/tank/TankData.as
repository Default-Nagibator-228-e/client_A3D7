package alternativa.tanks.models.tank
{
   import utils.client.models.ClientObject;
   import alternativa.tanks.models.weapon.IWeapon;
   import alternativa.tanks.sfx.TankSounds;
   import alternativa.tanks.utils.CircularObjectBuffer;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.client.models.tank.TankSpawnState;
   import flash.display.BitmapData;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class TankData
   {
      
      public static var EVENT_BUFFER_SIZE:int = 10;
      
      public static var localTankData:TankData;
       
      
      public var battlefield:ClientObject;
      
      public var user:ClientObject;
      
      public var turret:ClientObject;
      
      public var hull:ClientObject;
      
      public var weapon:IWeapon;
      
      public var coloring:BitmapData;
      
      public var deadColoring:BitmapData;
      
      public var local:Boolean;
      
      public var health:int;
      
      public var tank:Tank;
      
      public var ctrlBits:int;
      
      public var enabled:Boolean;
      
      public var teamType:BattleTeamType;
      
      public var userName:String;
      
      public var userRank:int;
      
      public var sounds:TankSounds;
      
      public var tankCollisionCount:int;
      
      public var spawnState:TankSpawnState;
      
      public var mass:Number = 1;
      
      public var power:Number = 0;
      
      public var incarnation:int;
      
      public var deadTime:int;
      
      private var events:CircularObjectBuffer;
      
      public function TankData()
      {
         this.events = new CircularObjectBuffer(EVENT_BUFFER_SIZE);
         super();
      }
      
      public function logEvent(event:Object) : void
      {
         this.events.addObject(event);
      }
      
      public function toString() : String
      {
         var event:Object = null;
         var s:String = "user id=" + this.user.id + "\n" + "user name=" + this.userName + "\n" + "user rank=" + this.userRank + "\n" + "local=" + this.local + "\n" + "team type=" + (this.teamType == null?"none":this.teamType.toString()) + "\n" + "incarnation=" + this.incarnation + "\n" + "health=" + this.health + "\n" + "enabled=" + this.enabled + "\n" + "ctrlBits=" + this.ctrlBits + "\n" + "mass=" + this.mass + "\n" + "power=" + this.power + "\n" + "maxSpeed=" + (this.tank == null?"none":this.tank.maxSpeed) + "\n" + "turret id=" + (this.turret == null?null:this.turret.id) + "\n" + "hull id=" + (this.hull == null?null:this.hull.id) + "\n" + "title.hidden=" + (this.tank == null?"none":this.tank.title.isHidden()) + "\n" + "collisionGroup=" + (this.tank == null?"none":this.tank.collisionGroup) + "\n" + "hullAlpha=" + (this.tank == null?"none":this.tank.skin.hullMesh.alpha) + "\n" + "pos=" + (this.tank == null?"none":this.tank.state.pos) + "\n" + "orientation=" + (this.tank == null?"none":this.tank.state.orientation) + "\n";
         s = s + "Last events: \n";
         for each(event in this.events.getObjects())
         {
            s = s + (event.toString() + "\n");
         }
         return s;
      }
   }
}
