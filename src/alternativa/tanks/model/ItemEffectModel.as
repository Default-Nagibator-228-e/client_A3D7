package alternativa.tanks.model
{
   import alternativa.init.Main;
   import utils.client.models.IModel;
   import utils.client.models.ClientObject;
   import alternativa.service.IModelService;
   import utils.client.garage.effects.effectableitem.EffectableItemModelBase;
   import utils.client.garage.effects.effectableitem.IEffectableItemModelBase;
   import flash.utils.Dictionary;
   
   public class ItemEffectModel extends EffectableItemModelBase implements IEffectableItemModelBase, IItemEffect
   {
       
      
      private var modelRegister:IModelService;
      
      private var remainingTime:Dictionary;
      
      private var timers:Dictionary;
      
      private var idByTimer:Dictionary;
      
      public function ItemEffectModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IItemEffect);
         _interfaces.push(IEffectableItemModelBase);
         this.remainingTime = new Dictionary();
         this.idByTimer = new Dictionary();
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
      }
      
      public function setRemaining(clientObject:ClientObject, remaining:Number) : void
      {
         var i:int = 0;
         this.remainingTime[clientObject.id] = remaining;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IItemEffectListener).setTimeRemaining(clientObject.id,remaining);
            }
         }
      }
      
      public function effectStopped(clientObject:ClientObject) : void
      {
         var i:int = 0;
         this.remainingTime[clientObject.id] = null;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IItemEffectListener).effectStopped(clientObject.id);
            }
         }
      }
      
      public function getTimeRemaining(itemId:String) : Number
      {
         var time:Number = this.remainingTime[itemId];
         return time;
      }
   }
}
