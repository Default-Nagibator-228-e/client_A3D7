package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.engine3d.UVFrame;
   
   public class AnimatedPlane extends Mesh
   {
       
      
      private var a:Vertex;
	  
	  private var h:TextureAnimation;
      
      private var b:Vertex;
      
      private var c:Vertex;
      
      private var d:Vertex;
      
      private var uvFrames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var framesPerTimeUnit:Number = 0;
      
      public function AnimatedPlane(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0, param5:Number = 10)
      {
         super();
         this.createFaces(param1,param2,param3,param4,param5);
         sorting = Sorting.DYNAMIC_BSP;
         calculateBounds();
         calculateFacesNormals();
         this.writeVertices();
         this.softAttenuation = 130;
		 this.useDepth = false;
		 this.useLight = false;
		 this.useShadowMap = false;
      }
      
      private function createFaces(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Number = param1 / 2;
         var _loc7_:Number = param2 / 2;
         var _loc8_:Vector.<Number> = Vector.<Number>([param3 - _loc6_,param4 + _loc7_,param5,param3 - _loc6_,param4 - _loc7_,param5,param3 + _loc6_,param4 - _loc7_,param5,param3 + _loc6_,param4 + _loc7_,param5]);
         var _loc9_:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var _loc10_:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(_loc8_,_loc9_,_loc10_,true);
      }
      
      private function writeVertices() : void
      {
         var _loc1_:Vector.<Vertex> = this.vertices;
         this.a = _loc1_[0];
         this.b = _loc1_[1];
         this.c = _loc1_[2];
         this.d = _loc1_[3];
      }
      
      public function init(param1:TextureAnimation, param2:Number) : void
      {
		 h = param1;
         setMaterialToAllFaces(param1.material[0]);
         this.uvFrames = param1.frames;
         this.numFrames = this.uvFrames.length;
         this.framesPerTimeUnit = param2;
      }
      
      public function setTime(param1:Number) : void
      {
         var _loc2_:int = param1 * this.framesPerTimeUnit;
         if(_loc2_ >= this.numFrames)
         {
            _loc2_ = this.numFrames - 1;
         }
         this.setFrame(this.uvFrames[_loc2_]);
		 setMaterialToAllFaces(h.material[_loc2_]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.uvFrames = null;
         this.numFrames = 0;
      }
      
      public function getOneLoopTime() : Number
      {
         return this.numFrames / this.framesPerTimeUnit;
      }
      
      private function setFrame(param1:UVFrame) : void
      {
         //this.a.u = param1.topLeftU;
         //this.a.v = param1.topLeftV;
         //this.b.u = param1.topLeftU;
         //this.b.v = param1.bottomRightV;
         //this.c.u = param1.bottomRightU;
         //this.c.v = param1.bottomRightV;
         //this.d.u = param1.bottomRightU;
         //this.d.v = param1.topLeftV;
      }
   }
}
