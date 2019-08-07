package alternativa.tanks.models.sfx.healing
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import utils.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class HealingGunSoundEffect implements ISound3DEffect
   {
      
      private static const NUM_LOOPS:int = 100000;
      
      private static var position:Vector3 = new Vector3();
       
      
      private var sfxData:HealingGunSFXData;
      
      private var object:Object3D;
      
      private var _mode:IsisActionType;
      
      private var _enabled:Boolean;
      
      private var dead:Boolean;
      
      private var currentSound3D:Sound3D;
      
      private var soundChannel:SoundChannel;
      
      private var listener:IHealingGunEffectListener;
      
      public function HealingGunSoundEffect(listener:IHealingGunEffectListener)
      {
         super();
         this.listener = listener;
      }
      
      public function init(mode:IsisActionType, sfxData:HealingGunSFXData, object:Object3D) : void
      {
         this.sfxData = sfxData;
         this.object = object;
         this._mode = mode;
         this.dead = false;
         this._enabled = false;
         this.updateMode();
      }
      
      public function set mode(value:IsisActionType) : void
      {
         if(this._mode == value)
         {
            return;
         }
         this._mode = value;
         this.updateMode();
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         this._enabled = value;
         if(!this._enabled)
         {
            this.currentSound3D.stop();
            this.soundChannel = null;
         }
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         if(this.dead)
         {
            return false;
         }
         if(this.soundChannel == null)
         {
            this.soundChannel = this.currentSound3D.play(0,NUM_LOOPS);
         }
         position.x = this.object.x;
         position.y = this.object.y;
         position.z = this.object.z;
         this.currentSound3D.checkVolume(camera.pos,position,camera.xAxis);
         return true;
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = this.object.x;
         result.y = this.object.y;
         result.z = this.object.z;
      }
      
      public function destroy() : void
      {
         if(this.currentSound3D != null)
         {
            Sound3D.destroy(this.currentSound3D);
            this.currentSound3D = null;
            this.soundChannel = null;
         }
         this.sfxData = null;
         this.object = null;
         this.listener.onEffectDestroyed(this);
      }
      
      public function get numSounds() : int
      {
         return !!this.dead?int(0):int(1);
      }
      
      public function kill() : void
      {
         this.dead = true;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      private function updateMode() : void
      {
         var soundTransform:SoundTransform = null;
         var sound:Sound = null;
         if(this.soundChannel != null)
         {
            soundTransform = this.soundChannel.soundTransform;
            this.soundChannel = null;
         }
         if(this.currentSound3D != null)
         {
            Sound3D.destroy(this.currentSound3D);
         }
         switch(this._mode)
         {
            case IsisActionType.IDLE:
               sound = this.sfxData.idleSound;
               break;
            case IsisActionType.HEAL:
               sound = this.sfxData.healSound;
               break;
            case IsisActionType.DAMAGE:
               sound = this.sfxData.damageSound;
         }
         this.currentSound3D = Sound3D.create(sound,1000,2000,2,1);
         if(soundTransform != null)
         {
            this.soundChannel = this.currentSound3D.play(0,NUM_LOOPS);
            this.soundChannel.soundTransform = soundTransform;
         }
      }
   }
}
