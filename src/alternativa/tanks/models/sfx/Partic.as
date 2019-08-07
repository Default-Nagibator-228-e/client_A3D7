package alternativa.tanks.models.sfx 
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.math.Vector3;
	import alternativa.tanks.engine3d.AnimatedSprite3D;
	import alternativa.tanks.engine3d.TextureAnimation;
	import alternativa.tanks.models.sfx.SimplePlane;
	import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
	import flash.geom.ColorTransform;
	
	public class Partic 
	{
		
		private static var INITIAL_POOL_SIZE:int = 20;
      
	   private static var poolIndex:int = -1;
		
	   
	   public var velocity:Vector3;
	   
	   public var distance:Number = 0;
	   
	   public var currFrame:Number = 0;
	   
	   private var light:OmniLight;
		  
	   private var framesPerMillisecond:Number;
	   
	   private var aData:TextureAnimation;
	   
	   public var sprite:SimplePlane;
		
		public function Partic(animData:TextureAnimation)
	   {
		  this.velocity = new Vector3();
		  aData = animData;
		  this.sprite = new SimplePlane(100,300,1,0);
		  this.sprite.useDepth = false;
		  this.sprite.useLight = false;
		  this.sprite.useShadowMap = false;
		  this.sprite.softAttenuation = 140;
		  this.framesPerMillisecond = 0.001 * animData.fps;
		  this.light = new OmniLight(16745512, 500, 1000);
		  var fdgdfsss:Number = Math.random();
		  fdgdfsss > 0.75 ? this.light.attenuationBegin = 500 * fdgdfsss : this.light.attenuationBegin = 375;
		  fdgdfsss > 0.75 ? this.light.attenuationEnd = 1000 * fdgdfsss : this.light.attenuationEnd = 750;
	   }
	   
	   public function dispose() : void
	   {
		  this.light.alternativa3d::removeFromParent();
		  sprite.material = null;
	   }
	   
	   public function updateC(millis:int) : void
	   {
		  while (this.currFrame >= aData.material.length)
		  {
			  this.currFrame -= aData.material.length;
		  }
		  this.sprite.material = aData.material[int(this.currFrame)];
		  this.currFrame += this.framesPerMillisecond * millis;
	   }
		
	}

}