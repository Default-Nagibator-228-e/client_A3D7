package alternativa.tanks.sound {
	import alternativa.math.Vector3;
	import utils.client.models.ClientObject;
	import alternativa.tanks.camera.GameCamera;
	import alternativa.tanks.sfx.ISound3DEffect;

	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class SoundManager implements ISoundManager {

		public static function createSoundManager(testSound:Sound):ISoundManager {
			var channel:SoundChannel = testSound.play(0, 1, new SoundTransform(0));
			if (channel != null) {
				channel.stop();
				return new SoundManager();
			}
			return new DummySoundManager();
		}

		// Квадрат максимального расстояния, на котором слышен любой звук. Звуки, расположенные дальше этого
		// расстояния, деактивируются и могут быть удалены из списка активных эффектов.
		private var maxDistanceSqr:Number;
		// Максимальное количество одновременно проигрываемых звуков
		private var maxSounds:int = 10;
		// Максимальное количество одновременно проигрываемых трёхмерных звуков
		private var maxSounds3D:int = 20;
		// Список эффектов
		private var effects:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
		// Количество эффектов
		private var numEffects:int;
		// Список обычных звуков (SoundChannel => true)
		private var sounds:Dictionary = new Dictionary();
		// Количество активных обычных звуков
		private var numSounds:int;
		private var _position:Vector3 = new Vector3();
		private var sortingStack:Vector.<int> = new Vector.<int>();

		public function set maxDistance(value:Number):void {
			this.maxDistanceSqr = value*value;
		}

		public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel {
			if (numSounds == maxSounds || sound == null)
				return null;
			var channel:SoundChannel = sound.play(startTime, loops, soundTransform);
			if (channel == null)
				return null;
			addSoundChannel(channel);
			return channel;
		}

		public function stopSound(channel:SoundChannel):void {
			if (channel == null || sounds[channel] == null)
				return;
			removeSoundChannel(channel);
		}

		public function stopAllSounds():void {
			for (var channel:* in sounds)
				removeSoundChannel(channel as SoundChannel);
		}

		public function addEffect(effect:ISound3DEffect):void {
			if (getEffectIndex(effect) > -1)
				return;
			effect.enabled = true;
			effects.push(SoundEffectData.create(0, effect));
			numEffects++;
		}

		public function removeEffect(effect:ISound3DEffect):void {
			for (var i:int = 0; i < numEffects; i++) {
				var data:SoundEffectData = effects[i];
				if (data.effect == effect) {
					effect.destroy();
					SoundEffectData.destroy(data);
					effects.splice(i, 1);
					numEffects--;
					return;
				}
			}
		}

		public function removeAllEffects():void {
			while (effects.length > 0) {
				var data:SoundEffectData = effects.pop();
				data.effect.destroy();
				SoundEffectData.destroy(data);
			}
			numEffects = 0;
		}

		public function updateSoundEffects(millis:int, camera:GameCamera):void {
			if (numEffects == 0)
				return;
			// Рассчитываем расстояние до звуков и сортируем в порядке возрастания
			sortEffects(camera.pos);
			var data:SoundEffectData;
			var num:int = 0;
			var i:int;
			for (i = 0; i < numEffects; i++) {
				data = effects[i];
				var numSounds:int = data.effect.numSounds;
				if (numSounds == 0) {
					data.effect.destroy();
					SoundEffectData.destroy(data);
					effects.splice(i, 1);
					numEffects--;
					i--;
				} else {
					if (data.distanceSqr > maxDistanceSqr || (num + numSounds) > maxSounds3D) {
						break;
					} else {
						data.effect.enabled = true;
						data.effect.play(millis, camera);
						num += numSounds;
					}
				}
			}
			for (; i < numEffects; i++) {
				data = effects[i];
				data.effect.enabled = false;
				if (data.effect.numSounds == 0) {
					data.effect.destroy();
					SoundEffectData.destroy(data);
					effects.splice(i, 1);
					numEffects--;
					i--;
				}
			}
		}

		public function killEffectsByOwner(owner:ClientObject):void {
			for (var i:int = 0; i < numEffects; ++i) {
				var soundEffectData:SoundEffectData = effects[i];
				var effect:ISound3DEffect = soundEffectData.effect;
				if (effect.owner == owner)
					effect.kill();
			}
		}

		private function addSoundChannel(channel:SoundChannel):void {
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			sounds[channel] = true;
			numSounds++;
		}

		private function removeSoundChannel(channel:SoundChannel):void {
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			delete sounds[channel];
			numSounds--;
		}

		private function onSoundComplete(e:Event):void {
			stopSound(e.target as SoundChannel);
		}

		private function getEffectIndex(effect:ISound3DEffect):int {
			for (var i:int = 0; i < numEffects; i++)
				if (SoundEffectData(effects[i]).effect == effect)
					return i;
			return -1;
		}

		private function sortEffects(cameraPos:Vector3D):void {
			var i:int;
			var j:int;
			var left:int = 0;
			var right:int = numEffects - 1;
			var sortingStackIndex:int;
			var sortingMedian:Number;
			var data:SoundEffectData;
			var sortingLeft:SoundEffectData;
			var sortingRight:SoundEffectData;

			for (i = 0; i < numEffects; i++) {
				data = effects[i];
				data.effect.readPosition(_position);
				var dx:Number = cameraPos.x - _position.x;
				var dy:Number = cameraPos.y - _position.y;
				var dz:Number = cameraPos.z - _position.z;
				data.distanceSqr = dx*dx + dy*dy + dz*dz;
			}

			if (numEffects == 1) return;

			sortingStack[0] = left;
			sortingStack[1] = right;
			sortingStackIndex = 2;
			while (sortingStackIndex > 0) {
				j = right = sortingStack[--sortingStackIndex];
				i = left = sortingStack[--sortingStackIndex];
				sortingMedian = SoundEffectData(effects[(right + left) >> 1]).distanceSqr;
				do {
					while ((sortingLeft = effects[i]).distanceSqr < sortingMedian) i++;
					while ((sortingRight = effects[j]).distanceSqr > sortingMedian) j--;
					if (i <= j) {
						effects[i++] = sortingRight;
						effects[j--] = sortingLeft;
					}
				} while (i <= j);
				if (left < j) {
					sortingStack[sortingStackIndex++] = left;
					sortingStack[sortingStackIndex++] = j;
				}
				if (i < right) {
					sortingStack[sortingStackIndex++] = i;
					sortingStack[sortingStackIndex++] = right;
				}
			}
		}
	}
}

import alternativa.tanks.sfx.ISound3DEffect;

class SoundEffectData {

	private static var pool:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
	private static var numObjects:int;

	public static function create(distanceSqr:Number, effect:ISound3DEffect):SoundEffectData {
		if (numObjects > 0) {
			var data:SoundEffectData = pool[--numObjects];
			pool[numObjects] = null;
			data.distanceSqr = distanceSqr;
			data.effect = effect;
			return data;
		}
		return new SoundEffectData(distanceSqr, effect);
	}

	public static function destroy(data:SoundEffectData):void {
		data.effect = null;
		pool[numObjects++] = data;
	}

	public var distanceSqr:Number;
	public var effect:ISound3DEffect;

	public function SoundEffectData(distanceSqr:Number, effect:ISound3DEffect) {
		this.distanceSqr = distanceSqr;
		this.effect = effect;
	}
}
