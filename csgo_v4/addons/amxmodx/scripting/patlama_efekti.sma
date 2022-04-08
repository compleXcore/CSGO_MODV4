#include <amxmodx>
#include <fakemeta_util>
#include <hamsandwich>

#pragma compress 1

// Sprites
new g_explode_sound[] = "csgonew4/hegrenade-1.wav"
new g_explode_sounddis[] = "csgonew4/distant/explode5_distant.wav"
new g_sound_flash[] = "csgonew4/flashbang_hit1.wav"
new g_sound_he[] = "csgonew4/he_bounce-1.wav"
new g_sprite_grenade_ring[] = "sprites/csgonew4/bexplo.spr"

const PEV_NADE_TYPE = pev_flTimeStepSound
const NADE_TYPE_NAPALM = 2222
const NADE_TYPE_FROST = 3333
const NADE_TYPE_FLARE = 4444

new g_exploSpr

public plugin_init()
{
	register_plugin("Patlama Efekti + Duvara Carpma sesi", "1.0", "deciduous0")
	
	register_forward(FM_SetModel, "fw_SetModel")
	RegisterHam(Ham_Think, "grenade", "fw_ThinkGrenade")
	
	RegisterHam(Ham_Touch, "grenade", "World_Touch")
}

public plugin_precache()
{
	g_exploSpr = precache_model(g_sprite_grenade_ring)
	precache_sound(g_explode_sound)
	precache_sound(g_explode_sounddis)
	precache_sound(g_sound_flash)
	precache_sound(g_sound_he)
}

public World_Touch(iEnt, id)
{
	static Ent_Classname[64]
	pev(iEnt, pev_classname, Ent_Classname, sizeof(Ent_Classname))
	
	if (pev(iEnt, PEV_NADE_TYPE) == NADE_TYPE_FROST || pev(iEnt, PEV_NADE_TYPE) == NADE_TYPE_FLARE)
	{
		emit_sound(iEnt, CHAN_STATIC, g_sound_flash, 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	else if (pev(iEnt, PEV_NADE_TYPE) == NADE_TYPE_NAPALM)
	{
		emit_sound(iEnt, CHAN_STATIC, g_sound_he, 1.0, ATTN_NORM, 0, PITCH_NORM)
	}

	return HAM_IGNORED
}

// Forward Set Model
public fw_SetModel(entity, const model[])
{
	// We don't care
	if (strlen(model) < 8)
		return;
	
	// Narrow down our matches a bit
	if (model[7] != 'w' || model[8] != '_')
		return;
	
	// Get damage time of grenade
	static Float:dmgtime
	pev(entity, pev_dmgtime, dmgtime)
	
	// Grenade not yet thrown
	if (dmgtime == 0.0)
		return;
	
	// HE Grenade
	if (model[9] == 'h' && model[10] == 'e')
	{
		// Set grenade type on the thrown grenade entity
		set_pev(entity, PEV_NADE_TYPE, NADE_TYPE_NAPALM)
	}
	
	// Flashbang
	if (model[9] == 'f' && model[10] == 'l')
	{
		// Set grenade type on the thrown grenade entity
		set_pev(entity, PEV_NADE_TYPE, NADE_TYPE_FROST)
	}
	
	// Smoke Grenade
	if (model[9] == 's' && model[10] == 'm')
	{
		// Set grenade type on the thrown grenade entity
		set_pev(entity, PEV_NADE_TYPE, NADE_TYPE_FLARE)
	}
}

// Ham Grenade Think Forward
public fw_ThinkGrenade(entity)
{
	// Invalid entity
	if (!pev_valid(entity)) return HAM_IGNORED;
	
	// Get damage time of grenade
	static Float:dmgtime
	pev(entity, pev_dmgtime, dmgtime)
	
	// Check if it's time to go off
	if (dmgtime > get_gametime())
		return HAM_IGNORED;
	
	// Not a napalm grenade
	if (pev(entity, PEV_NADE_TYPE) != NADE_TYPE_NAPALM)
		return HAM_IGNORED;
	
	fire_explode(entity);

	set_pev(entity, PEV_NADE_TYPE, 0)
	
	engfunc(EngFunc_RemoveEntity, entity)
	return HAM_SUPERCEDE;
}

// Fire Grenade Explosion
fire_explode(ent)
{
	// Get origin
	new Float:origin[3];pev(ent, pev_origin, origin)
	
	// Override original HE grenade explosion?
	create_blast2(origin)
		
	emit_sound(ent, CHAN_WEAPON, g_explode_sound, 1.0, ATTN_NORM, 0, PITCH_NORM)
	PlaySound(0, g_explode_sounddis);
	
	static Owner; Owner = pev(ent,pev_owner)
	
	static Float:FinalDamage;
	
	for(new i = 1; i <= 32; i++)
	{		
		if(!is_user_alive(i))
			continue
		
		static Float:VictimOrigin[3]
		pev(i, pev_origin, VictimOrigin)
			
		if(get_distance_f(origin, VictimOrigin) > 380)
			continue
		
		FinalDamage = float(95) - ((float(95) / 380) * get_distance_f(origin, VictimOrigin))
		if(get_user_team(Owner) != get_user_team(i)) ExecuteHamB(Ham_TakeDamage, i, ent, Owner, FinalDamage, DMG_GRENADE)
	}
}

stock PlaySound(id, const sound[])
{
	if(equal(sound[strlen(sound)-4], ".mp3")) client_cmd(id, "mp3 play ^"sound/%s^"", sound);
	else client_cmd(id, "spk ^"%s^"", sound);
}

// Fire Grenade: Fire Blast
create_blast2(const Float:origin[3])
{
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST,SVC_TEMPENTITY, origin, 0) 
	write_byte(TE_EXPLOSION) 
	engfunc(EngFunc_WriteCoord, origin[0]) // x axis 
	engfunc(EngFunc_WriteCoord, origin[1]) // y axis 
	engfunc(EngFunc_WriteCoord, origin[2]+80) // z axis 
	write_short(g_exploSpr) 
	write_byte(45) 
	write_byte(12) 
	write_byte(TE_EXPLFLAG_NOSOUND) 
	message_end() 
}
