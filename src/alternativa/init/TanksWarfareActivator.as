package alternativa.init
{
   import alternativa.osgi.CommonBundleActivator;
   import alternativa.tanks.models.effects.common.bonuscommon.BonusCommonModel;
   import alternativa.tanks.models.effects.crystal.CrystalBonusModel;
   import alternativa.tanks.models.effects.firstaid.FirstAidModel;
   import alternativa.tanks.models.longterm.LongTermBonusModel;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformModel;
   import alternativa.tanks.models.sfx.flame.FlamethrowerSFXModel;
   import alternativa.tanks.models.sfx.healing.HealingGunSFXModel;
   import alternativa.tanks.models.sfx.shoot.gun.SmokySFXModel;
   import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXModel;
   import alternativa.tanks.models.sfx.shoot.railgun.RailgunSFXModel;
   import alternativa.tanks.models.sfx.shoot.ricochet.RicochetSFXModel;
   import alternativa.tanks.models.sfx.shoot.thunder.ThunderSFXModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonModel;
   import alternativa.tanks.models.weapon.flamethrower.FlamethrowerModel;
   import alternativa.tanks.models.weapon.freeze.FreezeModel;
   import alternativa.tanks.models.weapon.freeze.FreezeSFXModel;
   import alternativa.tanks.models.weapon.gun.SmokyModel;
   import alternativa.tanks.models.weapon.healing.HealingGunModel;
   import alternativa.tanks.models.weapon.plasma.PlasmaModel;
   import alternativa.tanks.models.weapon.railgun.RailgunModel;
   import alternativa.tanks.models.weapon.ricochet.RicochetModel;
   import alternativa.tanks.models.weapon.shared.shot.ShotModel;
   import alternativa.tanks.models.weapon.thunder.ThunderModel;
   import alternativa.tanks.models.weapon.weakening.WeaponWeakeningModel;
   
   public class TanksWarfareActivator extends CommonBundleActivator
   {
       
      
      public function TanksWarfareActivator()
      {
         super();
      }
      
      override public function start(osgi:OSGi) : void
      {
         registerModel(new FirstAidModel(),osgi);
         registerModel(new BonusCommonModel(),osgi);
         registerModel(new LongTermBonusModel(),osgi);
         registerModel(new CrystalBonusModel(),osgi);
         registerModel(new WeaponCommonModel(),osgi);
         registerModel(new WeaponWeakeningModel(),osgi);
         registerModel(new ShotModel(),osgi);
         registerModel(new SmokyModel(),osgi);
         registerModel(new SmokySFXModel(),osgi);
         registerModel(new PlasmaModel(),osgi);
         registerModel(new PlasmaSFXModel(),osgi);
         registerModel(new FlamethrowerModel(),osgi);
         registerModel(new FlamethrowerSFXModel(),osgi);
         registerModel(new RailgunModel(),osgi);
         registerModel(new RailgunSFXModel(),osgi);
         registerModel(new HealingGunModel(),osgi);
         registerModel(new HealingGunSFXModel(),osgi);
         registerModel(new ThunderModel(),osgi);
         registerModel(new ThunderSFXModel(),osgi);
         registerModel(new RicochetModel(),osgi);
         registerModel(new RicochetSFXModel(),osgi);
         registerModel(new FreezeModel(),osgi);
         registerModel(new FreezeSFXModel(),osgi);
         registerModel(new ColorTransformModel(),osgi);
      }
   }
}
