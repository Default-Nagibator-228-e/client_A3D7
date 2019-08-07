package forms.friends.button.friends
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class NewRequestIndicator extends Sprite
   {
      [Embed(source="1.png")]
      public static var attentionIconClass:Class;
      
      private static var attentionIconBitmapData:BitmapData = Bitmap(new attentionIconClass()).bitmapData;
       
      
      public function NewRequestIndicator()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         addChild(new Bitmap(attentionIconBitmapData));
         this.updateVisible();
         //friendInfoService.addEventListener(NewFriendEvent.ACCEPTED_CHANGE,this.onUpdateAcceptedCounter);
         //friendInfoService.addEventListener(NewFriendEvent.INCOMING_CHANGE,this.onUpdateIncomingCounter);
         //newReferralsNotifierService.addEventListener(NewReferralsNotifierServiceEvent.REFERRAL_ADDED,this.referralsAdded);
         //newReferralsNotifierService.addEventListener(NewReferralsNotifierServiceEvent.NEW_REFERRALS_COUNT_UPDATED,this.newReferralsCountUpdated);
      }
      /*
      private function newReferralsCountUpdated(param1:NewReferralsNotifierServiceEvent) : void
      {
         this.updateVisible();
      }
      
      private function referralsAdded(param1:NewReferralsNotifierServiceEvent) : void
      {
         this.updateVisible();
      }
      
      private function onUpdateIncomingCounter(param1:NewFriendEvent) : void
      {
         this.updateVisible();
      }
      
      private function onUpdateAcceptedCounter(param1:NewFriendEvent) : void
      {
         this.updateVisible();
      }
      */
      private function updateVisible() : void
      {
		 visible = true;
         //visible = friendInfoService.newAcceptedFriendsLength + friendInfoService.newIncomingFriendsLength + newReferralsNotifierService.getNewReferralsCount() > 0;
      }
   }
}
