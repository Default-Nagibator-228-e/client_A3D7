package utils
{
   import flash.utils.ByteArray;
   
   public class TARAParser
   {
       
      
      public function TARAParser()
      {
         super();
      }
      
      public static function parse(data:ByteArray) : Object
      {
         var i:int = 0;
         var fileData:ByteArray = null;
         var fileInfo:FileInfo = null;
         var numFiles:int = data.readInt();
         var files:Vector.<FileInfo> = new Vector.<FileInfo>(numFiles,true);
         for(i = 0; i < numFiles; i++)
         {
            files[i] = new FileInfo(data.readUTF(),data.readInt());
         }
         var table:Object = {};
         for(i = 0; i < numFiles; i++)
         {
            fileData = new ByteArray();
            fileInfo = files[i];
            data.readBytes(fileData,0,fileInfo.size);
            table[fileInfo.name] = fileData;
         }
         return table;
      }
   }
}

class FileInfo
{
    
   
   public var name:String;
   
   public var size:int;
   
   function FileInfo(name:String, size:int)
   {
      super();
      this.name = name;
      this.size = size;
   }
}
