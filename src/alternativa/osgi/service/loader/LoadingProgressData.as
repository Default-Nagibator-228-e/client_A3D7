package alternativa.osgi.service.loader
{
   public class LoadingProgressData
   {
       
      
      public var status:String;
      
      public var progress:Number;
      
      public function LoadingProgressData(status:String, progress:Number)
      {
         super();
         this.status = status;
         this.progress = progress;
      }
   }
}
