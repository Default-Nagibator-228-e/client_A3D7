package controls.base
{
   public class MainPanelGarageButtonBase extends MainPanelButtonBase
   {
       
      
      private var iconClass:Class;
      
      public function MainPanelGarageButtonBase()
      {
         this.iconClass = MainPanelGarageButtonBase_iconClass;
         super(this.iconClass);
      }
   }
}
