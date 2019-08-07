package alternativa.tanks.models.ctf
{
   public class CTFFlagState
   {
      
      public static const AT_BASE:CTFFlagState = new CTFFlagState(0,"AT_BASE");
      
      public static const DROPPED:CTFFlagState = new CTFFlagState(1,"DROPPED");
      
      public static const CARRIED:CTFFlagState = new CTFFlagState(2,"CARRIED");
       
      
      private var _value:int;
      
      private var _stringValue:String;
      
      public function CTFFlagState(value:int, stringValue:String)
      {
         super();
         this._value = value;
         this._stringValue = stringValue;
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function toString() : String
      {
         return "CTFFlagState [" + this._stringValue + "]";
      }
   }
}
