package utils.client.panel.model
{
   public class User
   {
       
      
      public var place:int = 0;
      
      public var callsign:String;
      
      public var kills:int = 0;
      
      public var deaths:int = 0;
      
      public var ratio:int = 0;
      
      public var rank:int = 0;
      
      public var score:int = 0;
      
      public var wealth:int = 0;
      
      public var rating:Number = 0;
      
      public function User(callsign:String, score:int, rank:int, place:int, kills:int, deaths:int, ratio:int, wealth:int, rating:int)
      {
         super();
         this.place = place;
         this.callsign = callsign;
         this.kills = kills;
         this.deaths = deaths;
         this.ratio = ratio;
         this.rank = rank;
         this.score = score;
         this.wealth = wealth;
         this.rating = rating;
      }
   }
}
