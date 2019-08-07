package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import utils.client.models.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.events.Event;
   import flash.media.SoundChannel;
   
   public class Sound3DEffect extends PooledObject implements ISound3DEffect
   {
      
      public static var wrongSoundsCount:int;
       
      
      private var _owner:ClientObject;
      
      private var position:Vector3;
      
      private var sound:Sound3D;
      
      private var playbackDelay:int;
      
      private var startTime:int;
      
      private var channel:SoundChannel;
      
      private var _enabled:Boolean = false;
      
      private var _playing:Boolean = false;
      
      public function Sound3DEffect(objectPool:ObjectPool)
      {
         this.position = new Vector3();
         super(objectPool);
      }
      
      public static function create(objectPool:ObjectPool, owner:ClientObject, position:Vector3, sound:Sound3D, playbackDelay:int = 0, startTime:int = 0) : Sound3DEffect
      {
         var effect:Sound3DEffect = Sound3DEffect(objectPool.getObject(Sound3DEffect));
         effect.init(owner,position,sound,playbackDelay,startTime);
         return effect;
      }
      
      public function init(owner:ClientObject, position:Vector3, sound:Sound3D, playbackDelay:int = 0, startTime:int = 0) : void
      {
         this._owner = owner;
         this.position.vCopy(position);
         this.sound = sound;
         this.playbackDelay = playbackDelay;
         this.startTime = startTime;
         this._enabled = false;
         this._playing = false;
      }
      
      public function get owner() : ClientObject
      {
         return this._owner;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         this.playbackDelay = this.playbackDelay - millis;
         if(this.playbackDelay > 0)
         {
            return this._enabled;
         }
         if(!this._playing)
         {
            this._playing = true;
            this.channel = this.sound.play(this.startTime,1);
            if(this.channel != null)
            {
               this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            }
            else
            {
               return this._enabled = false;
            }
         }
         this.sound.checkVolume(camera.pos,this.position,camera.xAxis);
         return this._enabled;
      }
      
      public function destroy() : void
      {
         this._owner = null;
         Sound3D.destroy(this.sound);
         this.sound = null;
         this.onSoundComplete(null);
         storeInPool();
      }
      
      public function kill() : void
      {
         this._enabled = false;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         if(!(this._enabled = value))
         {
            this.onSoundComplete(null);
         }
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = this.position.x;
         result.y = this.position.y;
         result.z = this.position.z;
      }
      
      public function get numSounds() : int
      {
         return !!this._enabled?int(1):int(0);
      }
      
      private function onSoundComplete(e:Event) : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         this._enabled = false;
         this.channel = null;
      }
      
      override protected function getClass() : Class
      {
         return Sound3DEffect;
      }
   }
}
