package alternativa.osgi.service.mainContainer
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   
   public interface IMainContainerService
   {
       
      
      function get stage() : Stage;
      
      function get mainContainer() : DisplayObjectContainer;
      
      function get backgroundLayer() : DisplayObjectContainer;
      
      function get contentLayer() : DisplayObjectContainer;
      
      function get contentUILayer() : DisplayObjectContainer;
      
      function get systemLayer() : DisplayObjectContainer;
      
      function get systemUILayer() : DisplayObjectContainer;
      
      function get dialogsLayer() : DisplayObjectContainer;
      
      function get noticesLayer() : DisplayObjectContainer;
      
      function get cursorLayer() : DisplayObjectContainer;
   }
}
