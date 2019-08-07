package alternativa.register
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.protocol.codec.NullMap;
   import alternativa.service.IModelService;
   import alternativa.service.Logger;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   
   public class ModelsRegister implements IModelService
   {
       
      
      private var modelInstances:Dictionary;
      
      private var modelInstancesByInterface:Dictionary;
      
      private var modelInterfaces:Dictionary;
      
      private var modelByMethod:Dictionary;
      
      private var modelsParamsStruct:Dictionary;
      
      private var _modelsList:Vector.<IModel>;
      
      public function ModelsRegister()
      {
         super();
         this.modelInterfaces = new Dictionary();
         this.modelInstances = new Dictionary();
         this.modelByMethod = new Dictionary();
         this.modelInstancesByInterface = new Dictionary();
         this.modelsParamsStruct = new Dictionary();
         this._modelsList = new Vector.<IModel>();
      }
      
      public function register(modelId:String, methodId:String) : void
      {
         this.modelByMethod[methodId] = modelId;
         Main.writeVarsToConsoleChannel("MODEL REGISTER","Метод %1 (модель %2) зарегистрирован",methodId,modelId);
      }
      
      public function registerModelsParamsStruct(modelId:String, paramsStruct:Class) : void
      {
         this.modelsParamsStruct[modelId] = paramsStruct;
      }
      
      public function unregisterModelsParamsStruct(modelId:String) : void
      {
         this.modelsParamsStruct[modelId] = null;
      }
      
      public function getModelsParamsStruct(modelId:String) : Class
      {
         return this.modelsParamsStruct[modelId];
      }
      
      public function add(modelInstance:IModel) : void
      {
         var key:Class = null;
         var record:Vector.<IModel> = null;
         Main.writeVarsToConsoleChannel("MODEL REGISTER","add model %1",modelInstance);
         this._modelsList.push(modelInstance);
         var modelId:String = modelInstance.id;
         this.modelInstances[modelId] = modelInstance;
         var interfaces:Vector.<Class> = modelInstance.interfaces;
         this.modelInterfaces[modelId] = interfaces;
         for(var i:int = 0; i < interfaces.length; i++)
         {
            key = interfaces[i];
            record = this.modelInstancesByInterface[key];
            if(record == null)
            {
               this.modelInstancesByInterface[key] = record = new Vector.<IModel>();
            }
            record.push(modelInstance);
         }
         Main.writeVarsToConsoleChannel("MODEL REGISTER","Реализация модели id: %1 %2 добавлена в реестр",modelId,modelInstance);
      }
      
      public function remove(modelId:String) : void
      {
         var methodId:* = undefined;
         var instance:IModel = null;
         var interfaces:Vector.<Class> = null;
         var i:int = 0;
         var id:String = null;
         var key:Class = null;
         var modelsArray:Vector.<IModel> = null;
         var index:int = 0;
         Main.writeVarsToConsoleChannel("MODEL REGISTER","remove model id: %1",modelId);
         this._modelsList.splice(this._modelsList.indexOf(this.modelInstances[modelId]),1);
         for(methodId in this.modelByMethod)
         {
            id = this.modelByMethod[methodId];
            if(id == modelId)
            {
               delete this.modelByMethod[methodId];
            }
         }
         instance = IModel(this.modelInstances[modelId]);
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   model instance: %1",instance);
         interfaces = this.modelInterfaces[modelId] as Vector.<Class>;
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   model interfaces: %1",interfaces);
         for(i = 0; i < interfaces.length; i++)
         {
            key = interfaces[i];
            modelsArray = this.modelInstancesByInterface[key] as Vector.<IModel>;
            Main.writeVarsToConsoleChannel("MODEL REGISTER","   models for interface %1: %2",key,modelsArray);
            index = modelsArray.indexOf(instance);
            modelsArray.splice(index,1);
         }
         delete this.modelInterfaces[modelId];
         delete this.modelInstances[modelId];
         Main.writeVarsToConsoleChannel("MODEL REGISTER","Реализация модели id: %1 удалена из реестра",modelId);
      }
      
      public function invoke(clientObject:ClientObject, methodId:String, params:IDataInput, nullMap:NullMap) : void
      {
         var modelId:String = String(this.modelByMethod[methodId]);
         var model:IModel = IModel(this.modelInstances[modelId]);
         Main.writeVarsToConsoleChannel("MODEL REGISTER","invoke");
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   methodId: " + methodId,255);
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   clientObjectId: " + clientObject.id,255);
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   invoke modelId: " + modelId,255);
         Main.writeVarsToConsoleChannel("MODEL REGISTER","   invoke model: " + model,255);
         if(model != null)
         {
            model.invoke(clientObject,methodId,Main.codecFactory,params,nullMap);
         }
         else
         {
            Main.writeVarsToConsoleChannel("MODEL REGISTER","   method invoke failed. MODEL NOT FOUND");
         }
      }
      
      public function getModel(id:String) : IModel
      {
         return this.modelInstances[id];
      }
      
      public function getModelsByInterface(modelInterface:Class) : Vector.<IModel>
      {
         Main.writeVarsToConsoleChannel("MODEL REGISTER","getModelsByInterface %1: %2",modelInterface,this.modelInstancesByInterface[modelInterface]);
         return this.modelInstancesByInterface[modelInterface];
      }
      
      public function getModelForObject(object:ClientObject, modelInterface:Class) : IModel
      {
         var msg:String = null;
         var model:IModel = null;
         var interfaces:Vector.<Class> = null;
         var n:int = 0;
         if(object == null)
         {
            msg = "Object is null. Model interface = " + modelInterface;
            Logger.log(LogLevel.LOG_ERROR,"ModelRegister::getModelForObject " + msg);
         }
         if(modelInterface == null)
         {
            msg = "Model interface is null. Object id = " + object.id;
            Logger.log(LogLevel.LOG_ERROR,"ModelRegister::getModelForObject " + msg);
            throw new ArgumentError(msg);
         }
         var modelIds:Vector.<String> = object.getModels();
         for(var i:int = modelIds.length - 1; i >= 0; i--)
         {
            interfaces = this.modelInterfaces[modelIds[i]] as Vector.<Class>;
            if(interfaces == null)
            {
               throw new Error("No interfaces found. Object id=" + object.id + ", model id=" + modelIds[i]);
            }
            for(n = interfaces.length - 1; n >= 0; n--)
            {
               if(interfaces[n] == modelInterface)
               {
                  if(model == null)
                  {
                     model = this.getModel(modelIds[i]);
                     break;
                  }
                  throw new Error("MODEL REGISTER getModelForObject: Найдено несколько моделей с указанным интерфейсом.");
               }
            }
         }
         return model;
      }
      
      public function getModelsForObject(object:ClientObject, modelInterface:Class) : Vector.<IModel>
      {
         var interfaces:Vector.<Class> = null;
         var n:int = 0;
         var result:Vector.<IModel> = new Vector.<IModel>();
         var modelIds:Vector.<String> = object.getModels();
         for(var i:int = modelIds.length - 1; i >= 0; i--)
         {
            interfaces = this.modelInterfaces[modelIds[i]] as Vector.<Class>;
            if(interfaces == null)
            {
               throw new Error("No interfaces found. Object id=" + object.id + ", model id=" + modelIds[i]);
            }
            for(n = interfaces.length - 1; n >= 0; n--)
            {
               if(interfaces[n] == modelInterface)
               {
                  result.push(this.getModel(modelIds[i]));
                  break;
               }
            }
         }
         return result;
      }
      
      public function getInterfacesForModel(id:String) : Vector.<Class>
      {
         return this.modelInterfaces[id];
      }
      
      public function get modelsList() : Vector.<IModel>
      {
         return this._modelsList;
      }
   }
}
