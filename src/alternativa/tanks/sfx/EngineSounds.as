package alternativa.tanks.sfx
{
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class EngineSounds
   {
      
      public static const SILENT:int = 0;
      
      public static const IDLE:int = 1;
      
      public static const ACCELERATING:int = 2;
      
      public static const MOVING:int = 3;
      
      public static const TURNING:int = 4;
       
      
      private var mode:int = 0;
      
      private var currentSound3D:Sound3D;
      
      private var idleSound3D:Sound3D;
      
      private var accelerationSound3D:Sound3D;
      
      private var movingSound3D:Sound3D;
      
      private var channel:SoundChannel;
      
      private var fading:Boolean;
      
      private var fadeSpeed:Number = 0.001;
      
      private var fadeLimit:Number = 1;
      
      private var nextSound:Sound3D;
      
      public function EngineSounds(idleSound:Sound, accelerationSound:Sound, movingSound:Sound)
      {
         super();
         var near:Number = SoundOptions.nearRadius;
         var far:Number = SoundOptions.farRadius;
         var delim:Number = SoundOptions.farDelimiter;
         var volume:Number = 1;
         this.idleSound3D = Sound3D.create(idleSound,near,far,delim,2);
         this.accelerationSound3D = Sound3D.create(accelerationSound,near,far,delim,volume);
         this.movingSound3D = Sound3D.create(movingSound,near,far,delim,volume);
         this.currentSound3D = this.idleSound3D;
      }
      
      public function update(millis:int, objectPos:Vector3D, soundPos:Vector3D, rightAxis:Vector3D) : void
      {
         if(this.mode == SILENT)
         {
            return;
         }
         if(this.fading)
         {
            this.currentSound3D.volume = this.currentSound3D.volume - this.fadeSpeed * millis;
            if(this.currentSound3D.volume < this.fadeLimit)
            {
               this.fading = false;
               this.stop();
               this.currentSound3D = this.idleSound3D;
               this.currentSound3D.volume = this.mode == IDLE?Number(2):Number(3);
               this.currentSound3D.play(0,10000);
            }
         }
         if(this.nextSound != null)
         {
            this.channel = null;
            this.currentSound3D.stop();
            this.currentSound3D = this.nextSound;
            this.currentSound3D.volume = 1;
            this.currentSound3D.play(0,10000);
            this.nextSound = null;
         }
         this.currentSound3D.checkVolume(objectPos,soundPos,rightAxis);
      }
      
      public function setSilentMode() : void
      {
         if(this.mode == SILENT)
         {
            return;
         }
         this.mode = SILENT;
         this.stop();
      }
      
      public function setIdleMode() : void
      {
         if(this.mode == IDLE)
         {
            return;
         }
         if(this.mode == SILENT)
         {
            this.currentSound3D = this.idleSound3D;
            this.currentSound3D.volume = 1;
            this.currentSound3D.play(0,1000);
         }
         else
         {
            this.fading = true;
            this.fadeLimit = 0.2;
         }
         this.mode = IDLE;
      }
      
      public function setAccelerationMode() : void
      {
         if(this.mode == ACCELERATING || this.mode == MOVING)
         {
            return;
         }
         this.fading = false;
         this.mode = ACCELERATING;
         this.currentSound3D.stop();
         this.currentSound3D = this.accelerationSound3D;
         this.currentSound3D.volume = 1;
         this.channel = this.currentSound3D.play(0,0);
         if(this.channel != null)
         {
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         }
      }
      
      public function setTurningMode() : void
      {
         if(this.mode == TURNING)
         {
            return;
         }
         if(this.mode == IDLE)
         {
            if(!this.fading)
            {
               this.currentSound3D.volume = 3;
            }
         }
         else
         {
            this.fading = true;
         }
         this.fadeLimit = 0.6;
         this.mode = TURNING;
      }
      
      public function stop() : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            this.channel = null;
         }
         this.currentSound3D.stop();
      }
      
      public function destroy() : void
      {
         this.stop();
         Sound3D.destroy(this.idleSound3D);
         this.idleSound3D = null;
         Sound3D.destroy(this.accelerationSound3D);
         this.accelerationSound3D = null;
         Sound3D.destroy(this.movingSound3D);
         this.movingSound3D = null;
      }
      
      private function soundComplete(e:Event) : void
      {
         if(this.channel == null || this.mode != ACCELERATING)
         {
            return;
         }
         this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this.mode = MOVING;
         this.movingSound3D.volume = this.accelerationSound3D.volume;
         this.nextSound = this.movingSound3D;
      }
   }
}
