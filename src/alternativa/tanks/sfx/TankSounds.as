package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.media.Sound;
   
   public class TankSounds implements ISound3DEffect
   {
      
      private static var _tankPos:Vector3 = new Vector3();
       
      
      private var _owner:ClientObject;
      
      private var _tank:Tank;
      
      private var engineSounds:EngineSounds;
      
      private var turretSound:Sound3D;
      
      private var turretSoundPlaying:Boolean;
      
      private var _engineMode:int = 1;
      
      private var _enabled:Boolean = false;
      
      public function TankSounds(owner:ClientObject, tank:Tank, engineIdleSound:Sound, engineAccelerationSound:Sound, engineMovingSound:Sound, turretSound:Sound)
      {
         super();
         this._owner = owner;
         this._tank = tank;
         this.engineSounds = new EngineSounds(engineIdleSound,engineAccelerationSound,engineMovingSound);
         this.turretSound = Sound3D.create(turretSound,500,2000,5,0.5);
      }
      
      public function get owner() : ClientObject
      {
         return this._owner;
      }
      
      public function setIdleMode() : void
      {
         this._engineMode = EngineSounds.IDLE;
         if(this._enabled)
         {
            this.engineSounds.setIdleMode();
         }
      }
      
      public function setAccelerationMode() : void
      {
         this._engineMode = EngineSounds.ACCELERATING;
         if(this._enabled)
         {
            this.engineSounds.setAccelerationMode();
         }
      }
      
      public function setTurningMode() : void
      {
         this._engineMode = EngineSounds.TURNING;
         if(this._enabled)
         {
            this.engineSounds.setTurningMode();
         }
      }
      
      public function get tank() : Tank
      {
         return this._tank;
      }
      
      public function set tank(value:Tank) : void
      {
         this._tank = value;
      }
      
      public function playTurretSound(play:Boolean) : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(play)
         {
            if(!this.turretSoundPlaying)
            {
               this.turretSoundPlaying = true;
               this.turretSound.play(100,0);
            }
         }
         else if(this.turretSoundPlaying)
         {
            this.turretSound.stop();
            this.turretSoundPlaying = false;
         }
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         if(this._tank == null)
         {
            return false;
         }
         if(!this._enabled)
         {
            return true;
         }
         _tankPos.vCopy(this._tank.state.pos);
         this.engineSounds.update(millis,camera.pos,_tankPos,camera.xAxis);
         this.turretSound.checkVolume(camera.pos,_tankPos,camera.xAxis);
         return true;
      }
      
      public function destroy() : void
      {
         this.engineSounds.stop();
         this.turretSound.stop();
      }
      
      public function kill() : void
      {
      }
      
      public function get numSounds() : int
      {
         return 2;
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.vCopy(this._tank.state.pos);
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         this._enabled = value;
         this.updateSounds();
      }
      
      private function updateSounds() : void
      {
         if(this._enabled)
         {
            switch(this._engineMode)
            {
               case EngineSounds.IDLE:
                  this.engineSounds.setIdleMode();
                  break;
               case EngineSounds.ACCELERATING:
                  this.engineSounds.setAccelerationMode();
                  break;
               case EngineSounds.TURNING:
                  this.engineSounds.setTurningMode();
            }
         }
         else
         {
            this.turretSound.stop();
            this.turretSoundPlaying = false;
            this.engineSounds.setSilentMode();
         }
      }
   }
}
