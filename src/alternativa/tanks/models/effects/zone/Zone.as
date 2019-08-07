package alternativa.tanks.models.effects.zone 
{
	import alternativa.engine3d.containers.KDContainer;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.init.Main;
	import alternativa.math.Vector3;
	import alternativa.tanks.models.battlefield.BattlefieldModel;
	import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
	import alternativa.tanks.models.sfx.SimplePlane;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class Zone 
	{
		
		[Embed(source="arm.png")]
		private var a:Class;
		[Embed(source="cry.png")]
		private var c:Class;
		[Embed(source="dam.png")]
		private var d:Class;
		[Embed(source="hea.png")]
		private var h:Class;
		[Embed(source="nit.png")]
		private var n:Class;
		private var ar:TextureMaterial = new TextureMaterial(new a().bitmapData);
		private var cr:TextureMaterial = new TextureMaterial(new c().bitmapData);
		private var dr:TextureMaterial = new TextureMaterial(new d().bitmapData);
		private var hr:TextureMaterial = new TextureMaterial(new h().bitmapData);
		private var nr:TextureMaterial = new TextureMaterial(new n().bitmapData);
		
		public function Zone() 
		{
			
		}
		
		public function ded(p:Vector3, t:String) :void
		{
			var f:Object3DContainer = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport._mapContainer;
			var me:SimplePlane = new SimplePlane(ar.texture.width*2,ar.texture.height*2,1,1);
			me.x = p.x;
			me.y = p.y;
			me.z = p.z;
			me.setMaterialToAllFaces(t == "arm"?ar:t == "cry"?cr:t == "dam"?dr:t == "hea"?hr:nr);
			KDContainer(f).addChildAt(me,0);
		}
	}

}