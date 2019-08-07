package alternativa.tanks.sound {
	import utils.client.models.ClientObject;
	import alternativa.tanks.camera.GameCamera;
	import alternativa.tanks.sfx.ISound3DEffect;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public interface ISoundManager {

		function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel;

		function stopSound(channel:SoundChannel):void;

		function stopAllSounds():void;

		function addEffect(effect:ISound3DEffect):void;

		function removeEffect(effect:ISound3DEffect):void;

		function removeAllEffects():void;

		function updateSoundEffects(millis:int, camera:GameCamera):void;

		function killEffectsByOwner(owner:ClientObject):void;

		/**
		 * Максималное расстояние, на котором слышны звуки.
		 */
		function set maxDistance(value:Number):void;
	}
}
