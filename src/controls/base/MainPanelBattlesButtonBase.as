package controls.base
{
   public class MainPanelBattlesButtonBase extends MainPanelButtonBase
   {
       
      
      private var iconClass:Class;
      
      public function MainPanelBattlesButtonBase()
      {
         this.iconClass = MainPanelBattlesButtonBase_iconClass;
         super(this.iconClass);
      }
   }
}
