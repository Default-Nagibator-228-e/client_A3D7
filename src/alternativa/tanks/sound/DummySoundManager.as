package alternativa.tanks.sound {
	import utils.client.models.ClientObject;
	import alternativa.tanks.camera.GameCamera;
	import alternativa.tanks.sfx.ISound3DEffect;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class DummySoundManager implements ISoundManager {

		public function set maxDistance(value:Number):void {
		}

		public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel {
			return null;
		}

		public function stopSound(channel:SoundChannel):void {
		}

		public function stopAllSounds():void {
		}

		public function addEffect(effect:ISound3DEffect):void {
		}

		public function removeEffect(effect:ISound3DEffect):void {
		}

		public function removeAllEffects():void {
		}

		public function updateSoundEffects(millis:int, camera:GameCamera):void {
		}

		public function killEffectsByOwner(owner:ClientObject):void {
		}

	}
}
