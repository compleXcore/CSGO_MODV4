
#include <amxmodx>
#include <reapi>

#define PLUGIN "CSGO Tarzi Silah Atma"
#define VERSION "1.0"
#define AUTHOR "Fatih ~ EjderYa"

#define Throw_Power 250.0

public plugin_init() {
	
	register_plugin(PLUGIN, VERSION, AUTHOR)
	RegisterHookChain(RG_CBasePlayer_DropPlayerItem, "rg_CBasePlayerDropPlayerItemPost", 1)
}

public rg_CBasePlayerDropPlayerItemPost(Player)
{
	new entity = GetHookChainReturn(ATYPE_INTEGER)
	if(!is_nullent(entity)){
		
		new Float:Velocity[3],Float:Angles[3],Float:Origin[3], Float:Velocity2
		get_entvar(Player,var_origin,Origin)
		get_entvar(Player,var_velocity,Velocity)
		get_entvar(Player,var_angles,Angles)
		Origin[2] += 15.0
		Angles[0] *= 3.0
		
		Velocity[0] += floatcos(Angles[1],degrees ) * Throw_Power * floatcos(floatabs(Angles[0]),degrees )
		Velocity[1] += floatsin(Angles[1],degrees ) * Throw_Power * floatcos(floatabs(Angles[0]),degrees )
		Velocity2 = floatsin(Angles[0],degrees ) * Throw_Power * 2
		Velocity[2] += Velocity2 < 0 ? 0.0 : Velocity2
		
		set_entvar(entity,var_velocity,Velocity)
		set_entvar(entity,var_origin,Origin)
		
	}
	
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1254\\ deff0\\ deflang1055{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ f0\\ fs16 \n\\ par }
*/
