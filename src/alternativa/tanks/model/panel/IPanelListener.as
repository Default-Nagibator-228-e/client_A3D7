package alternativa.tanks.model.panel
{
   public interface IPanelListener
   {
       
      
      function bugReportOpened() : void;
      
      function bugReportClosed() : void;
      
      function settingsOpened() : void;
      
      function settingsCanceled() : void;
      
      function settingsAccepted() : void;
      
      function setMuteSound(param1:Boolean) : void;
   }
}
