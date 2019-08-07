package alternativa.osgi.service
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.protocol.codec.NullMap;
   import alternativa.protocol.factory.ICodecFactory;
   import flash.utils.IDataInput;
   
   public class Base implements IModel
   {
       
      
      public var _interfaces:Vector.<Class>;
      
      public function Base()
      {
         super();
         this._interfaces = new Vector.<Class>();
      }
      
      public function _initObject(clientObject:ClientObject, params:Object) : void
      {
      }
      
      public function invoke(clientObject:ClientObject, methodId:String, codecFactory:ICodecFactory, dataInput:IDataInput, nullMap:NullMap) : void
      {
      }
      
      public function get id() : String
      {
         return "";
      }
      
      public function get interfaces() : Vector.<Class>
      {
         return this._interfaces;
      }
   }
}
