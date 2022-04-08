
#include <amxmodx>
#include <engine>
#include <reapi>

#define PLUGIN "Silah Bekletici"
#define VERSION "1.0"
#define AUTHOR "Fatih ~ EjderYa"

#define var_user var_euser1

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	RegisterHookChain(RG_CBasePlayer_DropPlayerItem, "rg_CBasePlayerDropPlayerItemPost", 1)

	register_touch("weaponbox", "player", "fw_touch");
}

public fw_touch( ent, id ) {
	if(get_entvar(ent,var_user) == id)
		return PLUGIN_HANDLED;

	return PLUGIN_CONTINUE;
}
public rg_CBasePlayerDropPlayerItemPost(Player)
{
	new entity = GetHookChainReturn(ATYPE_INTEGER)
	if(!is_nullent(entity)){
		
		set_entvar(entity,var_user,Player)	
		SetThink(entity, "Remove_User1")
		set_entvar(entity, var_nextthink, get_gametime() + 2.0 )
		
	}
	
}
public Remove_User1(entity)
	set_entvar(entity,var_user,-1)
	