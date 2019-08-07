package alternativa.resource
{
   import alternativa.init.Main;
   import alternativa.network.ICommandSender;
   import alternativa.network.command.ControlCommand;
   import alternativa.tanks.loader.ILoaderWindowService;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class BatchLoaderManager
   {
       
      
      private var maxActiveLoaders:int;
      
      private var commandSender:ICommandSender;
      
      private var numActiveLoaders:int;
      
      private var activeLoaders:Dictionary;
      
      private var waitingLoaders:Dictionary;
      
      public function BatchLoaderManager(maxActiveLoaders:int, commandSender:ICommandSender)
      {
         this.activeLoaders = new Dictionary();
         this.waitingLoaders = new Dictionary();
         super();
         this.maxActiveLoaders = maxActiveLoaders;
         this.commandSender = commandSender;
      }
      
      public function addLoader(loader:BatchResourceLoader) : void
      {
         if(this.numActiveLoaders < this.maxActiveLoaders)
         {
            this.startLoader(loader);
         }
         else
         {
            this.waitingLoaders[loader.batchId] = loader;
         }
      }
      
      private function startLoader(loader:BatchResourceLoader) : void
      {
         this.numActiveLoaders++;
         this.activeLoaders[loader.batchId] = loader;
         loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         loader.addEventListener(ErrorEvent.ERROR,this.onLoadingError);
         loader.load();
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         var loader:BatchResourceLoader = BatchResourceLoader(e.target);
         loader.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
         loader.removeEventListener(ErrorEvent.ERROR,this.onLoadingError);
         delete this.activeLoaders[loader.batchId];
         this.numActiveLoaders--;
         this.commandSender.sendCommand(new ControlCommand(ControlCommand.RESOURCES_LOADED,"resourcesLoaded",[loader.batchId]));
         for each(loader in this.waitingLoaders)
         {
            delete this.waitingLoaders[loader.batchId];
            this.startLoader(loader);
         }
      }
      
      private function onLoadingError(e:ErrorEvent) : void
      {
         var loaderWindowService:ILoaderWindowService = null;
         var loader:BatchResourceLoader = BatchResourceLoader(e.target);
         delete this.activeLoaders[loader.batchId];
         for each(loader in this.activeLoaders)
         {
            loader.close();
         }
         this.commandSender.close();
         loaderWindowService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         if(loaderWindowService != null)
         {
            loaderWindowService.hideLoaderWindow();
         }
      }
   }
}
