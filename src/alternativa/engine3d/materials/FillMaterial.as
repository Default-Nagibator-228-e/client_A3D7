package alternativa.engine3d.materials
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.gfx.core.VertexBufferResource;
   import flash.display.BitmapData;
   use namespace alternativa3d;
   public class FillMaterial extends TextureMaterial
   {
       
      
      public var color:int;
      
      public var alpha:Number;
      
      public var lineThickness:Number;
      
      public var lineColor:int;
      
      public function FillMaterial(param1:int = 8355711, param2:Number = 1, param3:Number = -1, param4:int = 16777215)
      {
         super();
         this.color = param1;
         this.alpha = param2;
         this.lineThickness = param3;
         this.lineColor = param4;
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         return this.alpha < 1;
      }
      
      override public function clone() : Material
      {
         var _loc1_:FillMaterial = new FillMaterial(this.color,this.alpha,this.lineThickness,this.lineColor);
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
      
      override alternativa3d function drawOpaque(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D) : void
      {
         var _loc7_:uint = (this.alpha * 255 << 24) + this.color;
         var _loc8_:BitmapData = texture;
         if(_loc8_ != null)
         {
            if(_loc7_ != _loc8_.getPixel32(0,0))
            {
               _loc8_.setPixel32(0,0,_loc7_);
            }
            super.drawOpaque(param1,param2,param3,param4,param5,param6);
         }
      }
      
      override alternativa3d function drawTransparent(param1:Camera3D, param2:VertexBufferResource, param3:IndexBufferResource, param4:int, param5:int, param6:Object3D, param7:Boolean = false) : void
      {
         var _loc8_:uint = (this.alpha * 255 << 24) + this.color;
         var _loc9_:BitmapData = texture;
         if(_loc9_ != null)
         {
            if(_loc8_ != _loc9_.getPixel32(0,0))
            {
               _loc9_.setPixel32(0,0,_loc8_);
            }
            super.drawTransparent(param1,param2,param3,param4,param5,param6,param7);
         }
      }
   }
}
