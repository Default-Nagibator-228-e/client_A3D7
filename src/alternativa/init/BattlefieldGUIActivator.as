package alternativa.init
{
   import alternativa.osgi.CommonBundleActivator;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryItemModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryModel;
   import alternativa.tanks.models.effectsvisualization.EffectsVisualizationModel;
   
   public class BattlefieldGUIActivator extends CommonBundleActivator
   {
       
      
      public function BattlefieldGUIActivator()
      {
         super();
      }
      
      override public function start(osgi:OSGi) : void
      {
         registerModel(new ChatModel(),osgi);
         registerModel(new StatisticsModel(),osgi);
         registerModel(new InventoryModel(),osgi);
         registerModel(new InventoryItemModel(),osgi);
         registerModel(new EffectsVisualizationModel(),osgi);
      }
   }
}
