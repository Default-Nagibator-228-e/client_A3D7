package alternativa.physics.rigid
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   
   public class SkinnedBody3D extends Body3D
   {
      
      private static var _v:Vector3 = new Vector3();
      
      private static var _o:Quaternion = new Quaternion();
       
      
      protected var _skin:Object3D;
      
      public function SkinnedBody3D(invMass:Number, invInertia:Matrix3)
      {
         super(invMass,invInertia);
      }
      
      public function get skin() : Object3D
      {
         return this._skin;
      }
      
      public function set skin(value:Object3D) : void
      {
         this._skin = value;
      }
      
      override public function updateSkin(t:Number) : void
      {
         interpolate(t,_v,_o);
         this._skin.x = _v.x;
         this._skin.y = _v.y;
         this._skin.z = _v.z;
         _o.normalize();
         _o.getEulerAngles(_v);
         this._skin.rotationX = _v.x;
         this._skin.rotationY = _v.y;
         this._skin.rotationZ = _v.z;
      }
   }
}
