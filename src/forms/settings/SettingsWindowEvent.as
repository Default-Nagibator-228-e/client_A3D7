package forms.settings
{
   import flash.events.Event;
   
   public class SettingsWindowEvent extends Event
   {
      
      public static const CHANGE_TEXTURE_QUALITY:String = "SettingsWindowEventChangeTextureQuality";
      
      public static const CHANGE_VOLUME:String = "SettingsWindowEventChangeVolume";
      
      public static const RESEND_CONFIRMATION:String = "SettingsWindowEventResendConfirmation";
      
      public static const CANCEL_SETTINGS:String = "SettingsWindowEventCancelSettings";
      
      public static const ACCEPT_SETTINGS:String = "SettingsWindowEventAcceptSettings";
      
      public static const CHANGE_PASSWORD:String = "SettingsWindowEventChangePassword";
       
      
      public function SettingsWindowEvent(type:String)
      {
         super(type,true,false);
      }
   }
}
