package alternativa.tanks.models.battlefield.spectator
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.vehicles.tanks.Tank;
   import utils.client.models.tank.TankSpawnState;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import utils.client.battleservice.model.team.BattleTeamType;
   
   public class PlayerCamera implements KeyboardHandler
   {
       
      
      private var battlefield:BattlefieldModel;
      
      private var focusedUser:TankData;
      
      private var spectatorController:SpectatorCameraController;
      
      public function PlayerCamera(param1:SpectatorCameraController)
      {
         super();
         this.spectatorController = param1;
         this.battlefield = BattlefieldModel(Main.osgi.getService(IBattleField));
      }
      
      private function onFocusOnUser(param1:Object) : void
      {
         var _loc2_:TankData = this.findTank(param1.userId);
         this.focusOnTank(_loc2_);
      }
      
      private function findTank(id:String) : TankData
      {
         var tank:TankData = null;
         var key:* = undefined;
         for each(key in this.battlefield.bfData.activeTanks)
         {
            if(TankData(key).userName == id)
            {
               tank = key;
            }
         }
         return tank;
      }
      
      public function handleBattleEvent(param1:Tank) : void
      {
         var _loc2_:Tank = param1;
         if(this.focusedUser.tank == _loc2_)
         {
            this.unfocus();
         }
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         this.onKey(param1);
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         var _loc2_:TankData = null;
         if(param1.keyCode == Keyboard.F)
         {
            _loc2_ = this.findNearestUser(BattleTeamType.NONE);
         }
         if(param1.keyCode == Keyboard.R)
         {
            _loc2_ = this.findNearestUser(BattleTeamType.RED);
         }
         if(param1.keyCode == Keyboard.B)
         {
            _loc2_ = this.findNearestUser(BattleTeamType.BLUE);
         }
         if(param1.keyCode == Keyboard.U)
         {
            this.unfocus();
         }
         if(_loc2_)
         {
            this.focusOnTank(_loc2_);
         }
         if(this.focusedUser)
         {
            switch(param1.keyCode)
            {
               case Keyboard.RIGHT:
                  this.nextPlayer();
                  break;
               case Keyboard.LEFT:
                  this.prevPlayer();
            }
         }
      }
      
      private function findNearestUser(param1:BattleTeamType) : TankData
      {
         var key:* = undefined;
         var _loc6_:TankData = null;
         var _loc7_:Tank = null;
         var _loc8_:Number = NaN;
         var _loc2_:Tank = null;
         var _loc3_:Number = 100000000000000000000;
         var _loc4_:GameCamera = this.battlefield.bfData.viewport.camera;
         var _loc5_:Vector3 = new Vector3(_loc4_.x,_loc4_.y,_loc4_.z);
         for(key in this.battlefield.bfData.activeTanks)
         {
            _loc6_ = TankData(key);
            _loc7_ = this.getTank(_loc6_);
            if(_loc6_.teamType == param1 && _loc6_.spawnState == TankSpawnState.ACTIVE)
            {
               _loc8_ = _loc7_.state.pos.distanceTo(_loc5_);
               if(_loc8_ < _loc3_)
               {
                  _loc3_ = _loc8_;
                  _loc2_ = _loc7_;
                  break;
               }
            }
            else
            {
               _loc6_ = null;
            }
         }
         return _loc6_;
      }
      
      private function focusOnTank(param1:TankData) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.spawnState != TankSpawnState.ACTIVE)
         {
            return;
         }
         if(this.focusedUser == null)
         {
            this.battlefield.activateFollowCamera();
         }
         else
         {
            this.onUnfocus();
         }
         this.focusedUser = param1;
         this.battlefield.setCameraTarget(param1.tank);
      }
      
      public function unfocus() : void
      {
         if(this.focusedUser)
         {
            this.onUnfocus();
            this.focusedUser = null;
            this.spectatorController.activate();
            this.spectatorController.setPositionFromCamera();
            this.battlefield.activateSpectatorCamera();
         }
      }
      
      private function onUnfocus() : void
      {
      }
      
      private function nextPlayer() : void
      {
         this.focusOnTank(this.nextPlayerInDirection(1));
      }
      
      private function prevPlayer() : void
      {
         this.focusOnTank(this.nextPlayerInDirection(-1));
      }
      
      private function nextPlayerInDirection(param1:int) : TankData
      {
         var _loc5_:TankData = null;
         var _loc2_:Vector.<TankData> = this.getUsers();
         var _loc3_:int = _loc2_.indexOf(this.focusedUser);
         if(_loc3_ == -1)
         {
            return null;
         }
         var _loc4_:int = _loc3_;
         while(true)
         {
            _loc4_ = _loc4_ + param1;
            if(_loc4_ == -1)
            {
               _loc4_ = _loc2_.length - 1;
            }
            else if(_loc4_ == _loc2_.length)
            {
               _loc4_ = 0;
            }
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.teamType == this.focusedUser.teamType && _loc5_.spawnState == TankSpawnState.ACTIVE)
            {
               break;
            }
            if(_loc3_ == _loc4_)
            {
               return null;
            }
         }
         return _loc5_;
      }
      
      private function getUsers() : Vector.<TankData>
      {
         var key:* = undefined;
         var vector:Vector.<TankData> = new Vector.<TankData>();
         for(key in this.battlefield.bfData.activeTanks)
         {
            vector.push(TankData(key));
         }
         return vector;
      }
      
      private function getTank(param1:TankData) : Tank
      {
         return param1.tank;
      }
      
      [Obfuscation(rename="false")]
      public function close() : void
      {
      }
   }
}
