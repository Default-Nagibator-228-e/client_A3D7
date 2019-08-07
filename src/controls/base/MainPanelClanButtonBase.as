package controls.base
{
   public class MainPanelClanButtonBase extends MainPanelButtonBase
   {
       
      
      private var iconClass:Class;
      
      public function MainPanelClanButtonBase()
      {
         this.iconClass = MainPanelClanButtonBase_iconClass;
         super(this.iconClass);
      }
   }
}
