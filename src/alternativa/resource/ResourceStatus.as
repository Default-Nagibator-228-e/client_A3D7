package alternativa.resource
{
   import alternativa.types.Long;
   
   public class ResourceStatus
   {
      
      public static const QUEUED:String = "В очереди";
      
      public static const INFO_REQUESTED:String = "Запрошен info.xml";
      
      public static const INFO_LOADED:String = "info.xml загружен";
      
      public static const REQUESTED:String = "Запрошен";
      
      public static const LOADED:String = "Загружен";
      
      public static const LOAD_ERROR:String = "Ошибка загрузки";
      
      public static const UNLOADED:String = "Выгружен";
       
      
      public var id:Long;
      
      public var batchId:int;
      
      public var typeName:String;
      
      public var name:String;
      
      public var status:String;
      
      public function ResourceStatus(id:Long, batchId:int, typeName:String, name:String, status:String)
      {
         super();
         this.id = id;
         this.batchId = batchId;
         this.typeName = typeName;
         this.name = name;
         this.status = status;
      }
   }
}
