package alternativa.gfx.core
{
   import alternativa.engine3d.materials.TextureResourcesRegistry;
   import alternativa.gfx.alternativagfx;
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapTextureResource extends TextureResource
   {
      
      private static const point:Point = new Point();
      
      private static const rectangle:Rectangle = new Rectangle();
      
      private static const matrix:Matrix = new Matrix();
      
      private static var nullTexture:Texture;
      
      private static var nullTextureContext:Context3D;
       
      
      private var referencesCount:int = 1;
      
      private var _bitmapData:BitmapData;
      
      private var _mipMapping:Boolean;
      
      private var _stretchNotPowerOf2Textures:Boolean;
      
      private var _calculateMipMapsUsingGPU:Boolean;
      
      private var _correctionU:Number = 1;
      
      private var _correctionV:Number = 1;
      
      private var correctedWidth:int;
      
      private var correctedHeight:int;
      
      public function BitmapTextureResource(param1:BitmapData, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true)
      {
         super();
		 if (param1 == null)
		 {
			return;
		 }
         this._bitmapData = param1;
         this._mipMapping = param2;
         this._stretchNotPowerOf2Textures = param3;
         this._calculateMipMapsUsingGPU = param4;
         this.correctedWidth = Math.pow(2,Math.ceil(Math.log(this._bitmapData.width) / Math.LN2));
         this.correctedHeight = Math.pow(2,Math.ceil(Math.log(this._bitmapData.height) / Math.LN2));
         if(this.correctedWidth > 2048)
         {
            this.correctedWidth = 2048;
         }
         if(this.correctedHeight > 2048)
         {
            this.correctedHeight = 2048;
         }
         if((this._bitmapData.width != this.correctedWidth || this._bitmapData.height != this.correctedHeight) && !this._stretchNotPowerOf2Textures && this._bitmapData.width <= 2048 && this._bitmapData.height <= 2048)
         {
            this._correctionU = this._bitmapData.width / this.correctedWidth;
            this._correctionV = this._bitmapData.height / this.correctedHeight;
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function get mipMapping() : Boolean
      {
         return this._mipMapping;
      }
      
      public function get stretchNotPowerOf2Textures() : Boolean
      {
         return this._stretchNotPowerOf2Textures;
      }
      
      public function get correctionU() : Number
      {
         return this._correctionU;
      }
      
      public function get correctionV() : Number
      {
         return this._correctionV;
      }
      
      public function get calculateMipMapsUsingGPU() : Boolean
      {
         return this._calculateMipMapsUsingGPU;
      }
      
      public function set calculateMipMapsUsingGPU(param1:Boolean) : void
      {
         this._calculateMipMapsUsingGPU = param1;
      }
      
      public function forceDispose() : void
      {
         this.referencesCount = 1;
         this.dispose();
         this._bitmapData = null;
      }
      
      override public function dispose() : void
      {
         if(this.referencesCount == 0)
         {
            return;
         }
         this.referencesCount--;
         if(this.referencesCount == 0)
         {
            TextureResourcesRegistry.release(this._bitmapData);
            this._bitmapData = null;
            super.dispose();
         }
      }
      
      override public function get available() : Boolean
      {
         return this._bitmapData != null;
      }
      
      override protected function getNullTexture() : Texture
      {
         return nullTexture;
      }
      
      private function freeMemory() : void
      {
         useNullTexture = true;
         this._mipMapping = false;
         this.forceDispose();
      }
      
      override public function create(param1:Context3D) : void
      {
         var context:Context3D = param1;
         super.create(context);
         if(nullTexture == null || nullTextureContext != context)
         {
            nullTexture = context.createTexture(1,1,Context3DTextureFormat.BGRA,true);
            nullTexture.uploadFromBitmapData(new BitmapData(1,1,true,1439485132));
            nullTextureContext = context;
         }
         if(!useNullTexture)
         {
            try
            {
               texture = context.createTexture(this.correctedWidth,this.correctedHeight,Context3DTextureFormat.BGRA,true);
               return;
            }
            catch(e:Error)
            {
               freeMemory();
               return;
            }
            return;
         }
      }
      
      override public function upload() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:BitmapData = null;
         if(useNullTexture)
         {
            return;
         }
         if(this._bitmapData.width == this.correctedWidth && this._bitmapData.height == this.correctedHeight)
         {
            _loc1_ = this._bitmapData;
         }
         else
         {
            _loc1_ = new BitmapData(this.correctedWidth,this.correctedHeight,this._bitmapData.transparent,0);
            if(this._bitmapData.width <= 2048 && this._bitmapData.height <= 2048 && !this._stretchNotPowerOf2Textures)
            {
               _loc1_.copyPixels(this._bitmapData,this._bitmapData.rect,point);
               if(this._bitmapData.width < _loc1_.width)
               {
                  _loc2_ = new BitmapData(1,this._bitmapData.height,this._bitmapData.transparent,0);
                  rectangle.setTo(this._bitmapData.width - 1,0,1,this._bitmapData.height);
                  _loc2_.copyPixels(this._bitmapData,rectangle,point);
                  matrix.setTo(_loc1_.width - this._bitmapData.width,0,0,1,this._bitmapData.width,0);
                  _loc1_.draw(_loc2_,matrix,null,null,null,false);
                  _loc2_.dispose();
               }
               if(this._bitmapData.height < _loc1_.height)
               {
                  _loc2_ = new BitmapData(this._bitmapData.width,1,this._bitmapData.transparent,0);
                  rectangle.setTo(0,this._bitmapData.height - 1,this._bitmapData.width,1);
                  _loc2_.copyPixels(this._bitmapData,rectangle,point);
                  matrix.setTo(1,0,0,_loc1_.height - this._bitmapData.height,0,this._bitmapData.height);
                  _loc1_.draw(_loc2_,matrix,null,null,null,false);
                  _loc2_.dispose();
               }
               if(this._bitmapData.width < _loc1_.width && this._bitmapData.height < _loc1_.height)
               {
                  _loc2_ = new BitmapData(1,1,this._bitmapData.transparent,0);
                  rectangle.setTo(this._bitmapData.width - 1,this._bitmapData.height - 1,1,1);
                  _loc2_.copyPixels(this._bitmapData,rectangle,point);
                  matrix.setTo(_loc1_.width - this._bitmapData.width,0,0,_loc1_.height - this._bitmapData.height,this._bitmapData.width,this._bitmapData.height);
                  _loc1_.draw(_loc2_,matrix,null,null,null,false);
                  _loc2_.dispose();
               }
            }
            else
            {
               matrix.setTo(this.correctedWidth / this._bitmapData.width,0,0,this.correctedHeight / this._bitmapData.height,0,0);
               _loc1_.draw(this._bitmapData,matrix,null,null,null,true);
            }
         }
         if(this._mipMapping > 0)
         {
            this.uploadTexture(_loc1_,0);
            matrix.identity();
            _loc3_ = 1;
            _loc4_ = _loc1_.width;
            _loc5_ = _loc1_.height;
            while(_loc4_ % 2 == 0 || _loc5_ % 2 == 0)
            {
               _loc4_ = _loc4_ >> 1;
               _loc5_ = _loc5_ >> 1;
               if(_loc4_ == 0)
               {
                  _loc4_ = 1;
               }
               if(_loc5_ == 0)
               {
                  _loc5_ = 1;
               }
               _loc6_ = new BitmapData(_loc4_,_loc5_,_loc1_.transparent,0);
               matrix.a = _loc4_ / _loc1_.width;
               matrix.d = _loc5_ / _loc1_.height;
               _loc6_.draw(_loc1_,matrix,null,null,null,false);
               this.uploadTexture(_loc6_,_loc3_++);
               _loc6_.dispose();
            }
         }
         else
         {
            this.uploadTexture(_loc1_,0);
         }
         if(_loc1_ != this._bitmapData)
         {
            _loc1_.dispose();
         }
      }
      
      protected function uploadTexture(param1:BitmapData, param2:uint) : void
      {
         var source:BitmapData = param1;
         var mipLevel:uint = param2;
         try
         {
            if(texture != nullTexture)
            {
               texture.uploadFromBitmapData(source,mipLevel);
            }
            return;
         }
         catch(e:Error)
         {
            freeMemory();
            return;
         }
      }
      
      public function increaseReferencesCount() : void
      {
         this.referencesCount++;
      }
   }
}
