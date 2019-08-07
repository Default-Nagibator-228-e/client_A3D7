package alternativa.engine3d.materials
{
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.gfx.agal.FragmentShader;
   import alternativa.gfx.agal.SamplerDim;
   import alternativa.gfx.agal.SamplerFilter;
   import alternativa.gfx.agal.SamplerMipMap;
   import alternativa.gfx.agal.SamplerRepeat;
   import alternativa.gfx.agal.SamplerType;
   
   public class TextureMaterialFragmentShader extends FragmentShader
   {
       
      
      public function TextureMaterialFragmentShader(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:Boolean, param16:Boolean, param17:Boolean, param18:Boolean, param19:Boolean)
      {
         var _loc24_:int = 0;
         super();
         var _loc20_:SamplerRepeat = param1?SamplerRepeat.WRAP:SamplerRepeat.CLAMP;
         var _loc21_:SamplerFilter = param2?SamplerFilter.LINEAR:SamplerFilter.NEAREST;
         var _loc22_:SamplerMipMap = param3?param2?SamplerMipMap.LINEAR:SamplerMipMap.NEAREST:SamplerMipMap.NONE;
         var _loc23_:SamplerType = param4?SamplerType.DXT1:SamplerType.RGBA;
         tex(ft0,v0,fs0.dim(SamplerDim.D2).repeat(_loc20_).filter(_loc21_).mipmap(_loc22_).type(_loc23_));
         if(param6)
         {
            sub(ft1.w,ft0,fc[14]);
            kil(ft1.w);
         }
         if(param7)
         {
            add(ft1.w,ft0,fc[18]);
            div(ft0.xyz,ft0,ft1.w);
         }
         if(param8)
         {
            mul(ft0.xyz,ft0,fc[0]);
            add(ft0.xyz,ft0,fc[1]);
         }
         if(param9)
         {
            mul(ft0.w,ft0,fc[0]);
         }
         if(param10)
         {
            abs(ft1,v0.z);
            sat(ft1,ft1);
            sub(ft1,fc[17],ft1);
            mul(ft0.w,ft0,ft1);
         }
         if(param12 || param13 || param14 || param16)
         {
            div(ft4,v1,v1.z);
            mul(ft4.xy,ft4,fc[18]);
            add(ft4.xy,ft4,fc[18]);
         }
         if(param12 || param13 || param14)
         {
            mul(ft3,ft4,fc[4]);
         }
         if(param12 || param13)
         {
            tex(ft1,ft3,fs1.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.LINEAR));
         }
         if(param14)
         {
            tex(ft6,ft3,fs5.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.LINEAR));
         }
         if(param12)
         {
            dp3(ft2,ft1,fc[17]);
            sub(ft2,ft2,v1);
            abs(ft2,ft2);
            div(ft2,ft2,fc[14]);
            sat(ft2,ft2);
            mul(ft0.w,ft0,ft2.z);
         }
         if(param13)
         {
            mul(ft2,fc[12],ft1.w);
            sub(ft2,fc[17].w,ft2);
            mul(ft0.xyz,ft0,ft2);
         }
         if(param16)
         {
            mov(ft5,fc[5]);
            mul(ft5.z,ft5,v2);
            mul(ft3,ft4,fc[7]);
            tex(ft1,ft3,fs3.dim(SamplerDim.D2).repeat(SamplerRepeat.WRAP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.LINEAR));
            mul(ft1.z,ft1,fc[6]);
            mul(ft2,ft1.z,ft1);
            _loc24_ = 0;
            while(_loc24_ < ShadowMap.numSamples)
            {
               if(_loc24_ == 0)
               {
                  //add(ft1,ft2,v2);
                  tex(ft1,ft1,fs2.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.NONE));
                  dp3(ft1,ft1,ft5);
                  sat(ft1,ft1);
                  mov(ft4,ft1);
               }
               else
               {
                  if(_loc24_ % 2 > 0)
                  {
                     dp3(ft3.x,ft2,fc[8]);
                     dp3(ft3.y,ft2,fc[9]);
                     add(ft1,ft3,v2);
                  }
                  else
                  {
                     dp3(ft2.x,ft3,fc[8]);
                     dp3(ft2.y,ft3,fc[9]);
                     add(ft1,ft2,v2);
                  }
                  tex(ft1,ft1,fs2.dim(SamplerDim.D2).repeat(SamplerRepeat.CLAMP).filter(SamplerFilter.LINEAR).mipmap(SamplerMipMap.NONE));
                  dp3(ft1,ft1,ft5);
                  sat(ft1,ft1);
                  add(ft4,ft4,ft1);
               }
               _loc24_++;
            }
			
            mul(ft2,ft4,fc[6]);
            sat(ft1,v2);
            mul(ft2,ft2,ft1);
            mul(ft2.w,ft2,fc[7]);
         }
         if(param11)
         {
            if(param16)
            {
               sat(ft1,v1);
               max(ft2,ft2,ft1);
            }
            else
            {
               sat(ft2,v1);
            }
         }
         if(param16 || param11)
         {
            sub(ft2,fc[17],ft2);
            mul(ft2,fc[10],ft2.w);
            add(ft2,ft2,fc[11]);
            if(param14)
            {
               add(ft6,ft6,ft6);
               add(ft2,ft2,ft6);
            }
            else if(param15)
            {
               add(ft2,ft2,fc[13]);
            }
            mul(ft0.xyz,ft0,ft2);
         }
         else if(param14)
         {
            add(ft2,ft6,ft6);
            mul(ft0.xyz,ft0,ft2);
         }
         else if(param15)
         {
            mul(ft0.xyz,ft0,fc[13]);
         }
         if(param17)
         {
            if(param18)
            {
               mul(ft0.xyz,ft0,fc[13].w);
               add(ft0.xyz,ft0,fc[13]);
            }
            else
            {
               sat(ft1,v0);
               mul(ft1,ft1,fc[2]);
               if(param19)
               {
                  sub(ft1,fc[17],ft1);
                  mul(ft0.w,ft0,ft1);
               }
               else
               {
                  mul(ft1.xyz,fc[2],ft1.w);
                  sub(ft1.w,fc[17],ft1);
                  mul(ft0.xyz,ft0,ft1.w);
                  add(ft0.xyz,ft0,ft1);
               }
            }
         }
         mov(oc,ft0);
      }
   }
}
