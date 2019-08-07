package alternativa.tanks.sfx
{
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class Sound3D
   {
      
      private static var poolHead:Sound3D;
       
      
      public var nextInPool:Sound3D;
      
      private var nearRadius:Number;
      
      private var farRadius:Number;
      
      private var farDelimiter:Number;
      
      private var volumeCoefficient:Number;
      
      private var sound:Sound;
      
      private var channel:SoundChannel;
      
      private var transform:SoundTransform;
      
      private var _volume:Number = 1;
      
      private var _baseVolume:Number = 1;
      
      private var effectiveVolume:Number = 1;
      
      public function Sound3D(sound:Sound, nearRadius:Number, farRadius:Number, farDelimiter:Number, baseVolume:Number)
      {
         this.transform = new SoundTransform(0);
         super();
         this.init(sound,nearRadius,farRadius,farDelimiter,baseVolume);
      }
      
      public static function create(sound:Sound, nearRadius:Number, farRadius:Number, farDelimiter:Number, baseVolume:Number) : Sound3D
      {
         var object:Sound3D = null;
         if(poolHead == null)
         {
            return new Sound3D(sound,nearRadius,farRadius,farDelimiter,baseVolume);
         }
         object = poolHead;
         object.init(sound,nearRadius,farRadius,farDelimiter,baseVolume);
         poolHead = object.nextInPool;
         object.nextInPool = null;
         return object;
      }
      
      public static function destroy(object:Sound3D) : void
      {
         object.clear();
         if(poolHead == null)
         {
            poolHead = object;
         }
         else
         {
            object.nextInPool = poolHead;
            poolHead = object;
         }
      }
      
      public function init(sound:Sound, nearRadius:Number, farRadius:Number, farDelimiter:Number, baseVolume:Number) : void
      {
         this.sound = sound;
         this.nearRadius = nearRadius;
         this.farRadius = farRadius;
         this.farDelimiter = Math.sqrt(farDelimiter);
         this._baseVolume = baseVolume;
         this.volumeCoefficient = (Math.sqrt(farDelimiter) - 1) / (farRadius - nearRadius);
         this.volume = 1;
      }
      
      public function clear() : void
      {
         this.stop();
         this.sound = null;
      }
      
      public function get baseVolume() : Number
      {
         return this._baseVolume;
      }
      
      public function set baseVolume(value:Number) : void
      {
         this._baseVolume = value;
         this.updateEffectiveVolume();
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         this._volume = value;
         this.updateEffectiveVolume();
      }
      
      public function getSoundProperties(objectCoords:Vector3D, soundCoords:Vector3D, normal:Vector3D, soundTransform:SoundTransform) : void
      {
         var k:Number = NaN;
         var x:Number = soundCoords.x - objectCoords.x;
         var y:Number = soundCoords.y - objectCoords.y;
         var z:Number = soundCoords.z - objectCoords.z;
         var len:Number = Math.sqrt(x * x + y * y + z * z);
         if(len < this.nearRadius)
         {
            soundTransform.volume = 1;
            soundTransform.pan = 0;
         }
         else
         {
            k = 1 + this.volumeCoefficient * (len - this.nearRadius);
            k = 1 / (k * k);
            soundTransform.volume = k;
            len = 1 / len;
            x = x * len;
            y = y * len;
            z = z * len;
            soundTransform.pan = (x * normal.x + y * normal.y + z * normal.z) * (1 - k);
         }
      }
      
      public function checkVolume(objectPos:Vector3D, soundPos:Vector3D, rightAxis:Vector3D) : void
      {
         if(this.channel == null)
         {
            return;
         }
         this.getSoundProperties(objectPos,soundPos,rightAxis,this.transform);
         this.transform.volume = this.transform.volume * this.effectiveVolume;
         this.channel.soundTransform = this.transform;
      }
      
      public function play(startTime:int, loops:int) : SoundChannel
      {
         if(this.channel != null)
         {
            this.channel.stop();
         }
         return this.channel = this.sound.play(startTime,loops);
      }
      
      public function stop() : void
      {
         if(this.channel != null)
         {
            this.channel.stop();
            this.channel = null;
         }
      }
      
      private function updateEffectiveVolume() : void
      {
         this.effectiveVolume = this._baseVolume * this._volume;
      }
   }
}
