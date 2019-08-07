package alternativa.tanks.model.panel
{
   public interface IBattleSettings
   {
       
      
      function get showSkyBox() : Boolean;
      
      function get showFPS() : Boolean;
      
      function get showBattleChat() : Boolean;
      
      function get adaptiveFPS() : Boolean;
      
      function get enableMipMapping() : Boolean;
      
      function get inverseBackDriving() : Boolean;
      
      function get bgSound() : Boolean;
      
      function get muteSound() : Boolean;
      
      function get showShadowsTank() : Boolean;
      
      function get fog() : Boolean;
      
      function get dust() : Boolean;
      
      function get useSoftParticle() : Boolean;
      
      function get shadows() : Boolean;
      
      function get defferedLighting() : Boolean;
   }
}
