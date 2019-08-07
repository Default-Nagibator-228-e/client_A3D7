package alternativa.gfx.agal
{
   public class VertexShader extends Shader
   {
      
      public static const va0:CommonRegister = new CommonRegister(0,0);
      
      public static const va1:CommonRegister = new CommonRegister(1,0);
      
      public static const va2:CommonRegister = new CommonRegister(2,0);
      
      public static const va3:CommonRegister = new CommonRegister(3,0);
      
      public static const va4:CommonRegister = new CommonRegister(4,0);
      
      public static const va5:CommonRegister = new CommonRegister(5,0);
      
      public static const va6:CommonRegister = new CommonRegister(6,0);
      
      public static const va7:CommonRegister = new CommonRegister(7,0);
      
      public static const vt0:CommonRegister = new CommonRegister(0,2);
      
      public static const vt1:CommonRegister = new CommonRegister(1,2);
      
      public static const vt2:CommonRegister = new CommonRegister(2,2);
      
      public static const vt3:CommonRegister = new CommonRegister(3,2);
      
      public static const vt4:CommonRegister = new CommonRegister(4,2);
      
      public static const vt5:CommonRegister = new CommonRegister(5,2);
      
      public static const vt6:CommonRegister = new CommonRegister(6,2);
      
      public static const vt7:CommonRegister = new CommonRegister(7,2);
      
      public static const vc:Vector.<CommonRegister> = getConsts();
      
      public static const op:CommonRegister = new CommonRegister(0,3);
       
      
      public function VertexShader()
      {
         super();
         data.writeByte(0);
      }
      
      private static function getConsts() : Vector.<CommonRegister>
      {
         var _loc1_:Vector.<CommonRegister> = new Vector.<CommonRegister>();
         var _loc2_:int = 0;
         while(_loc2_ < 127)
         {
            _loc1_[_loc2_] = new CommonRegister(_loc2_,1);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
