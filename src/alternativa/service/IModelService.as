package alternativa.service
{
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.protocol.codec.NullMap;
   import flash.utils.IDataInput;
   
   public interface IModelService
   {
       
      
      function register(param1:String, param2:String) : void;
      
      function add(param1:IModel) : void;
      
      function remove(param1:String) : void;
      
      function registerModelsParamsStruct(param1:String, param2:Class) : void;
      
      function getModelsParamsStruct(param1:String) : Class;
      
      function invoke(param1:ClientObject, param2:String, param3:IDataInput, param4:NullMap) : void;
      
      function getModel(param1:String) : IModel;
      
      function getModelsByInterface(param1:Class) : Vector.<IModel>;
      
      function getModelForObject(param1:ClientObject, param2:Class) : IModel;
      
      function getModelsForObject(param1:ClientObject, param2:Class) : Vector.<IModel>;
      
      function getInterfacesForModel(param1:String) : Vector.<Class>;
      
      function get modelsList() : Vector.<IModel>;
   }
}
