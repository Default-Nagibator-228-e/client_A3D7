package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   
   use namespace alternativa3d;
   
   public class Decal extends Mesh
   {
       
      public var attenuation:Number = 1000000;
      
      public function Decal()
      {
         super();
         //shadowMapAlphaThreshold = 100;
      }
      
      public function createGeometry(param1:Object3D, param2:Boolean = false) : void
      {
		 var ggt:Mesh;
		 var ggt1:BSP;
         if(param1 is Mesh)
         {
            ggt = param1.clone() as Mesh;
			faceList = ggt.faceList;
			 vertexList = ggt.vertexList;
			 ggt.faceList = null;
			 ggt.vertexList = null;
			 var _loc3_:Vertex = vertexList;
			 while(_loc3_ != null)
			 {
				_loc3_.transformId = 0;
				_loc3_.id = null;
				_loc3_ = _loc3_.next;
			 }
			 var _loc4_:Face = faceList;
			 while(_loc4_ != null)
			 {
				_loc4_.id = null;
				_loc4_ = _loc4_.next;
			 }
         }
		 if(false)
         {
            ggt1 = param1.clone() as BSP;
			var _loc6_:Face = new Face();
			for (var yyu:int = 0; yyu < ggt1.faces.length; yyu++)
			{
				if (ggt1.faces[yyu] != null && ggt1.faces[yyu].wrapper.vertex != null)
				{
					_loc6_.next = ggt1.faces[yyu];
				}
			}
			faceList = _loc6_;
			 vertexList = ggt1.vertexList;
			 ggt1.faces = null;
			 ggt1.vertexList = null;
			 var _loc3_1:Vertex = vertexList;
			 while(_loc3_1 != null)
			 {
				_loc3_1.transformId = 0;
				_loc3_1.id = null;
				_loc3_1 = _loc3_1.next;
			 }
			 var _loc41_:Face = faceList;
			 while(_loc41_ != null)
			 {
				_loc41_.id = null;
				_loc41_ = _loc41_.next;
			 }
         }
         this.calculateBounds();
		 this.scaleZ = 0;
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Decal = new Decal();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override protected function clonePropertiesFrom(param1:Object3D) : void
      {
         super.clonePropertiesFrom(param1);
         var _loc2_:Decal = param1 as Decal;
         this.attenuation = _loc2_.attenuation;
      }
      
      override alternativa3d function draw(param1:Camera3D) : void
      {
         var _loc3_:Face = null;
         var _loc4_:Vertex = null;
         if(faceList == null)
         {
            return;
         }
         if(clipping == 0)
         {
            if(culling & 1)
            {
               return;
            }
            culling = 0;
         }
         this.prepareResources();
         useDepth = true;
         if(faceList.material != null)
         {
            param1.addDecal(this);
            transformConst[0] = ma;
            transformConst[1] = mb;
            transformConst[2] = mc;
            transformConst[3] = md;
            transformConst[4] = me;
            transformConst[5] = mf;
            transformConst[6] = mg;
            transformConst[7] = mh;
            transformConst[8] = mi;
            transformConst[9] = mj;
            transformConst[10] = mk;
            transformConst[11] = ml;
         }
         var _loc2_:int = !!param1.debug?int(int(param1.checkInDebug(this))):int(int(0));
         if(_loc2_ & Debug.BOUNDS)
         {
            Debug.drawBounds(param1,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(_loc2_ & Debug.EDGES)
         {
            if(transformId > 500000000)
            {
               transformId = 0;
               _loc4_ = vertexList;
               while(_loc4_ != null)
               {
                  _loc4_.transformId = 0;
                  _loc4_ = _loc4_.next;
               }
            }
            transformId++;
            calculateInverseMatrix();
            _loc3_ = prepareFaces(param1,faceList);
            if(_loc3_ == null)
            {
               return;
            }
            Debug.drawEdges(param1,_loc3_,16777215);
         }
      }
      
      override alternativa3d function getVG(param1:Camera3D) : VG
      {
         this.draw(param1);
         return null;
      }
      
      override alternativa3d function prepareResources() : void
      {
         var _loc1_:Vector.<Number> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vertex = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:int = 0;
         var _loc7_:Face = null;
         var _loc8_:Wrapper = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         if(vertexBuffer == null)
         {
            _loc1_ = new Vector.<Number>();
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = vertexList;
            while(_loc4_ != null)
            {
               _loc1_[_loc2_] = _loc4_.x;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.y;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.z;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.u;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.v;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalX;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalY;
               _loc2_++;
               _loc1_[_loc2_] = _loc4_.normalZ;
               _loc2_++;
               _loc4_.index = _loc3_;
               _loc3_++;
               _loc4_ = _loc4_.next;
            }
            vertexBuffer = new VertexBufferResource(_loc1_,8);
            _loc5_ = new Vector.<uint>();
            _loc6_ = 0;
            numTriangles = 0;
            _loc7_ = faceList;
            while(_loc7_ != null)
            {
               _loc8_ = _loc7_.wrapper;
               _loc9_ = _loc8_.vertex.index;
               _loc8_ = _loc8_.next;
               _loc10_ = _loc8_.vertex.index;
               _loc8_ = _loc8_.next;
               while(_loc8_ != null)
               {
                  _loc11_ = _loc8_.vertex.index;
                  _loc5_[_loc6_] = _loc9_;
                  _loc6_++;
                  _loc5_[_loc6_] = _loc10_;
                  _loc6_++;
                  _loc5_[_loc6_] = _loc11_;
                  _loc6_++;
                  _loc10_ = _loc11_;
                  numTriangles++;
                  _loc8_ = _loc8_.next;
               }
               _loc7_ = _loc7_.next;
            }
            indexBuffer = new IndexBufferResource(_loc5_);
         }
      }
   }
}
