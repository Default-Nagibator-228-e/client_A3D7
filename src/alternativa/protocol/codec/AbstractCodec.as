package alternativa.protocol.codec
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AbstractCodec implements ICodec
   {
       
      
      protected var nullValue:Object = null;
      
      public function AbstractCodec()
      {
         super();
      }
      
      public function encode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         if(!notnull)
         {
            nullmap.addBit(object == this.nullValue);
         }
         if(object != this.nullValue)
         {
            this.doEncode(dest,object,nullmap,notnull);
         }
         else if(notnull)
         {
            throw new Error("Object is null, but notnull expected.");
         }
      }
      
      public function decode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         return !notnull && nullmap.getNextBit()?this.nullValue:this.doDecode(reader,nullmap,notnull);
      }
      
      protected function doDecode(reader:IDataInput, nullmap:NullMap, notnull:Boolean) : Object
      {
         throw new Error("Method not implementated.");
      }
      
      protected function doEncode(dest:IDataOutput, object:Object, nullmap:NullMap, notnull:Boolean) : void
      {
         throw new Error("Method not implementated.");
      }
   }
}
