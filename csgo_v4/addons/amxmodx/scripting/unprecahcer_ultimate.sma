#include <amxmodx> 
#include <cstrike> 
#include <fakemeta> 

new const g_Sounds[][] = 
{ 
	"weapons/c4_beep1.wav", 
	"weapons/c4_beep2.wav", 
	"weapons/c4_beep3.wav", 
	"weapons/c4_beep4.wav", 
	"weapons/c4_plant.wav", 
	"weapons/c4_disarm.wav", 
	"weapons/c4_disarmed.wav", 
	"items/kevlar.wav", 
	"items/nvg_on.wav",
	"items/nvg_off.wav",
	"items/equip_nvg.wav",
	"ambience/Guit1.wav",
	"ambience/Opera.wav",
	"ambience/Opera.wav",
	"weapons/sg_explode.wav",
	"weapons/p228_clipin.wav",
	"weapons/p228_clipout.wav",
	"weapons/p228_slidepull.wav",
	"weapons/p228_sliderelease.wav",
	"weapons/pinpull.wav",
	"weapons/scout_bolt.wav",
	"weapons/scout_clipin.wav",
	"weapons/scout_clipout.wav",
	"weapons/sg550_clipout.wav",
	"weapons/sg550_boltpull.wav",
	"weapons/sg550_clipin.wav",
	"weapons/sg550_clipout.wav",
	"weapons/aug_boltpull.wav",
	"weapons/aug_boltslap.wav",
	"weapons/aug_forearm.wav",
	"weapons/aug_clipin.wav",
	"weapons/aug_clipout.wav",
	"weapons/p90_boltpull.wav",
	"weapons/p90_clipin.wav",
	"weapons/p90_clipout.wav",
	"weapons/p90_cliprelease.wav",
	"weapons/pinpull.wav",
	"weapons/fiveseven-1.wav",
	"weapons/fiveseven-2.wav",
	"weapons/fiveseven_clipin.wav",
	"weapons/fiveseven_clipout.wav",
	"weapons/fiveseven_slidepull.wav",
	"weapons/fiveseven_sliderelease.wav",
	"weapons/g3sg1_clipin.wav",
	"weapons/g3sg1_clipout.wav",
	"weapons/g3sg1_slide.wav",
	"weapons/sg552_boltpull.wav",
	"weapons/sg552_clipin.wav",
	"weapons/sg552_clipout.wav",
	"weapons/awp_clipin.wav",
	"weapons/awp_clipout.wav",
	"weapons/awp_deploy.wav",
	"weapons/tmp_clipin.wav",
	"weapons/tmp_clipout.wav",
	"weapons/flashbang-1.wav",
	"weapons/flashbang-2.wav",
	"weapons/famas-burst.wav",
	"weapons/famas_boltpull.wav",
	"weapons/famas_boltslap.wav",
	"weapons/famas_clipin.wav",
	"weapons/famas_clipout.wav",
	"weapons/famas_forearm.wav",
	"weapons/mac10_boltpull.wav",
	"weapons/mac10_clipin.wav",
	"weapons/mac10_clipout.wav",
	"weapons/ump45_boltslap.wav",
	"weapons/ump45_clipin.wav",
	"weapons/ump45_clipout.wav",
	"radio/blow.wav",
	"radio/bombdef.wav",
	"radio/bombpl.wav",
	"radio/circleback.wav",
	"radio/clear.wav",
	"radio/com_followcom.wav",
	"radio/com_getinpos.wav",
	"radio/com_go.wav",
	"radio/com_reportin.wav",
	"radio/ct_affirm.wav",
	"radio/ct_backup.wav",
	"radio/ct_coverme.wav",
	"radio/ct_enemys.wav",
	"radio/ct_fireinhole.wav",
	"radio/ct_imhit.wav",
	"radio/ct_inpos.wav",
	"radio/ct_point.wav",
	"radio/ct_reportingin.wav",
	"radio/elim.wav",
	"radio/enemydown.wav",
	"radio/fallback.wav",
	"radio/fireassis.wav",
	"radio/flankthem.wav",
	"radio/followme.wav",
	"radio/getout.wav",
	"radio/hitassist.wav",
	"radio/hosdown.wav",
	"radio/letsgo.wav",
	"radio/locknload.wav",
	"radio/matedown.wav",
	"radio/meetme.wav",
	"radio/moveout.wav",
	"radio/negative.wav",
	"radio/position.wav",
	"radio/regroup.wav",
	"radio/rescued.wav",
	"radio/roger.wav",
	"radio/rounddraw.wav",
	"radio/sticktog.wav",
	"radio/stormfront.wav",
	"radio/takepoint.wav",
	"radio/takepoint.wav",
	"radio/vip.wav",
	"hostage/hos1.wav",
	"hostage/hos2.wav",
	"hostage/hos3.wav",
	"hostage/hos4.wav",
	"hostage/hos5.wav",
	"hostage/hos1.wav",
	"items/tr_kevlar.wav",
	"player/breathe1.wav",
	"player/breathe2.wav",
	"player/pl_fallpain1.wav",
	"player/pl_fallpain2.wav",
	"player/pl_fallpain3.wav",
	"player/gasp1.wav",
	"player/gasp2.wav",
	"items/suitcharge1.wav",
	"items/suitchargeno1.wav",
	"items/suitchargeok1.wav",
	"common/wpn_hudoff.wav",
	"common/wpn_hudon.wav",
	"common/wpn_moveselect.wav",
	"player/geiger6.wav",
	"player/geiger5.wav",
	"player/geiger4.wav",
	"player/geiger3.wav",
	"player/geiger2.wav",
	"player/geiger1.wav  ",
	"weapons/bullet_hit1.wav",
	"weapons/bullet_hit2.wav",
	"items/weapondrop1.wav",
	"weapons/generic_reload.wav",
	"buttons/bell1.wav",
	"buttons/blip1.wav",
	"buttons/blip2.wav",
	"buttons/button11.wav",
	"buttons/latchunlocked2.wav",
	"buttons/lightswitch2.wav",
	"ambience/quail1.wav",
	"events/tutor_msg.wav",
	"events/enemy_died.wav",
	"events/friend_died.wav",
	"events/task_complete.wav"
} 
new const g_Models[][] = 
{ 
	"models/shield/p_shield_deagle.mdl",
	"models/shield/p_shield_fiveseven.mdl",
	"models/shield/p_shield_flashbang.mdl",
	"models/shield/p_shield_glock18.mdl",
	"models/shield/p_shield_hegrenade.mdl",
	"models/shield/p_shield_p228.mdl",
	"models/shield/p_shield_smokegrenade.mdl",
	"models/shield/p_shield_usp.mdl",
	"models/shield/v_shield_deagle.mdl",
	"models/shield/v_shield_fiveseven.mdl",
	"models/shield/v_shield_flashbang.mdl",
	"models/shield/v_shield_glock18.mdl",
	"models/shield/v_shield_hegrenade.mdl",
	"models/shield/v_shield_p228.mdl",
	"models/shield/v_shield_smokegrenade.mdl",
	"models/shield/v_shield_usp.mdl",
	"models/shield/v_shield_knife.mdl",
	"models/v_shield.mdl",
	"models/p_shield.mdl",
	"models/w_shield.mdl",
	"models/v_shield_r.mdl",
	"models/p_shield_r.mdl",
	"models/w_shield_r.mdl",
	"models/hostage01.mdl",
	"models/hostage02.mdl",
	"models/hostage03.mdl",
	"models/hostage04.mdl",
	"models/hostage05.mdl",
	"models/hostage06.mdl",
	"models/hostage07.mdl",
	"models/hostage08.mdl",
	"models/player/vip/vip.mdl",
	"sprites/c4.spr",
	"sprites/ic4.spr",
	"sprites/ihostage.spr",
	"sprites/iplayerc4.spr",
	"sprites/iplayervip.spr",
	"sprites/ibackpack.spr"
}
new const g_Generic[][] = 
{ 
	"gfx\vgui\ak47.tga",
	"gfx\vgui\aug.tga",
	"gfx\vgui\awp.tga",
	"gfx\vgui\defuser.tga",
	"gfx\vgui\deserteagle.tga",
	"gfx\vgui\elites.tga",
	"gfx\vgui\famas.tga",
	"gfx\vgui\fiveseven.tga",
	"gfx\vgui\flashbang.tga",
	"gfx\vgui\g3sg1.tga",
	"gfx\vgui\galil.tga",
	"gfx\vgui\gign.tga",
	"gfx\vgui\glock18.tga",
	"gfx\vgui\hegrenade.tga",
	"gfx\vgui\kevlar.tga",
	"gfx\vgui\kevlar_helmet.tga",
	"gfx\vgui\leet.tga",
	"gfx\vgui\m249.tga",
	"gfx\vgui\m3.tga",
	"gfx\vgui\m4a1.tga",
	"gfx\vgui\mac10.tga",
	"gfx\vgui\mp5.tga",
	"gfx\vgui\nightvision.tga",
	"gfx\vgui\not_available.tga",
	"gfx\vgui\p228.tga",
	"gfx\vgui\p90.tga",
	"gfx\vgui\sas.tga",
	"gfx\vgui\scout.tga",
	"gfx\vgui\sg550.tga",
	"gfx\vgui\sg552.tga",
	"gfx\vgui\shield.tga",
	"gfx\vgui\smokegrenade.tga",
	"gfx\vgui\tmp.tga",
	"gfx\vgui\ump45.tga",
	"gfx\vgui\urban.tga",
	"gfx\vgui\usp45.tga",
	"gfx\vgui\vip.tga",
	"gfx\vgui\xm1014.tga"
}
public plugin_precache() 
{ 
	register_forward(FM_PrecacheModel, "PrecacheModel") 
	register_forward(FM_PrecacheGeneric, "PrecacheGeneric") 
	register_forward(FM_PrecacheSound, "PrecacheSound") 
} 

public PrecacheModel(const szModel[]) 
{ 
	for(new i = 0; i < sizeof(g_Models); i++) 
	{ 
		if(containi(szModel, g_Models[i]) != -1 ) 
		{ 
			forward_return(FMV_CELL, 0) 
			return FMRES_SUPERCEDE 
		} 
	} 
	return FMRES_IGNORED 
} 

public PrecacheSound(const szSound[]) 
{ 
	for(new i = 0; i < sizeof(g_Sounds); i++) 
	{ 
		if(containi(szSound, g_Sounds[i]) != -1 ) 
		{ 
			forward_return(FMV_CELL, 0) 
			return FMRES_SUPERCEDE 
		} 
	} 
	return FMRES_IGNORED 
}

public PrecacheGeneric(const szGeneric[]) 
{ 
	for(new i = 0; i < sizeof(g_Generic); i++) 
	{ 
		if(containi(szGeneric, g_Generic[i]) != -1 ) 
		{ 
			forward_return(FMV_CELL, 0) 
			return FMRES_SUPERCEDE 
		} 
	} 
	return FMRES_IGNORED 
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1026\\ f0\\ fs16 \n\\ par }
*/
