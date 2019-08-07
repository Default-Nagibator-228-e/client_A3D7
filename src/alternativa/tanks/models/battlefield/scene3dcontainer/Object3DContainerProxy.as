package alternativa.tanks.models.battlefield.scene3dcontainer
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import flash.utils.Dictionary;
   
   public class Object3DContainerProxy implements Scene3DContainer
   {
       
      
      private var container:Object3DContainer;
      
      private const objects:Dictionary = new Dictionary();
      
      public function Object3DContainerProxy(param1:Object3DContainer = null)
      {
         this.container = new Object3DContainer();
         super();
         this.setContainer(param1);
      }
      
      public function addChild(param1:Object3D) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         this.objects[param1] = true;
         this.container.addChild(param1);
      }
      
      public function addChildAt(param1:Object3D, param2:int) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         this.objects[param1] = true;
         this.container.addChildAt(param1,param2);
      }
      
      public function addChildren(param1:Vector.<Object3D>) : void
      {
         var _loc2_:Object3D = null;
         if(param1 == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         for each(_loc2_ in param1)
         {
            this.addChild(_loc2_);
         }
      }
      
      public function removeChild(param1:Object3D) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         if(this.objects[param1])
         {
            delete this.objects[param1];
            this.container.removeChild(param1);
         }
      }
      
      public function setContainer(param1:Object3DContainer) : void
      {
         var _loc2_:Vector.<Object3D> = this.removeAllChildren();
         this.container = param1 || new Object3DContainer();
         this.addChildren(_loc2_);
      }
      
      private function removeAllChildren() : Vector.<Object3D>
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<Object3D> = new Vector.<Object3D>();
         for(_loc2_ in this.objects)
         {
            delete this.objects[_loc2_];
            this.container.removeChild(_loc2_);
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
   }
}
