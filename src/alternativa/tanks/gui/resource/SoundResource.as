package alternativa.tanks.gui.resource
{
   import flash.media.Sound;
   
   public class SoundResource
   {
       
      
      public var sound:Sound;
      
      public var nameID:String;
      
      public function SoundResource(sound:Sound, id:String)
      {
         super();
         this.nameID = id;
         this.sound = sound;
      }
   }
}
