/*  AMX Mod X script*/

#include <amxmodx>
#include <amxmisc>
#include <celltrie>
#include <cstrike>
#include <reapi>
#include <nvault>
#include <engine>
#include <fakemeta>

#define VERSION "3.2018-FINAL"
#define EDIT "RedarmyGaming"
#define FLAG_LOAD ADMIN_CFG
#define MAX_PREFIXES 33
#define MAX_BAD_PREFIXES 100

new g_bad_prefix, g_listen, g_listen_flag, g_custom, g_custom_flag, g_say_characters, g_prefix_characters;
new pre_ips_count = 0, pre_names_count = 0, pre_steamids_count, pre_flags_count = 0, bad_prefix_count = 0, i, temp_cvar[2];
new configs_dir[64], file_prefixes[128], file_bad_prefixes[128], text[128], prefix[32], type[2], key[32], length, line = 0, error[256];
new g_saytxt, g_maxplayers, CsTeams:g_team;
new g_typed[192], g_message[192], g_name[32];
new Trie:pre_ips_collect, Trie:pre_names_collect, Trie:pre_steamids_collect, Trie:pre_flags_collect, Trie:bad_prefixes_collect, Trie:client_prefix;
new str_id[16], temp_key[35], temp_prefix[32], temp_value;
new bool:g_toggle[33];

new const say_team_info[2][CsTeams][] =
{
	{"*IZLEYICI* ", "x ", "x ", "*IZLEYICI* "},
	{"", "", "", ""}
}

new const sayteam_team_info[2][CsTeams][] =
{
	{"(Izleyici) ", "x(Terrorist) ", "x(Counter-Terrorist) ", "(Izleyici) "},
	{"(Izleyici) ", "(Terrorist) ", "(Counter-Terrorist) ", "(Izleyici) "}
}

new const forbidden_say_symbols[] = {
	"/",
	"!",
	"%",
	"$"
}

new const forbidden_prefixes_symbols[] = {
	"/",
	"\",
	"%",
	"$",
	".",
	":",
	"?",
	"!",
	"@",
	"#",
	"%"
}

new const RUTBE[][][] = {
	{ "UNRANKED", 0 },

	{ "SILVER I", 400 }, // 1
	{ "SILVER II", 600 }, // 2
	{ "SILVER III", 800 }, // 3
	{ "SILVER IV", 1000 }, // 4
	{ "SILVER ELITE", 1400 }, // 5
	{ "SILVER ELITE MASTER", 1800 }, // 6

	{ "GOLD NOVA I", 2000 }, // 7
	{ "GOLD NOVA II", 2500 }, // 8
	{ "GOLD NOVA III", 3000 }, // 9
	{ "GOLD NOVA MASTER", 3400 }, // 10

	{ "MASTER GUARDIAN I", 3800 }, // 11
	{ "MASTER GUARDIAN II", 4500 }, // 12
	{ "MASTER GUARDIAN ELITE", 6400 }, // 13
	{ "DISTINGUISHED MASTER GUARDIAN", 7400 }, // 14

	{ "LEGENDARY EAGLE", 8500 }, // 15
	{ "LEGENDARY EAGLE MASTER", 10000 }, // 16

	{ "SUPREME MASTER FIRST CLASS", 15000 }, // 17
	{ "THE GLOBAL ELITE", 20000 } // 18
}

#define WEAPON_ENT(%0) (get_member(%0, m_iId))
#define is_user_valid(%1) (1 <= %1 <= get_member_game(m_nMaxPlayers))
#define is_nullent2(%0)          (%0 == 0 || %0 == NULLENT || is_entity(%0) == false)

new const rutbe2[] = "sprites/csgonew4/rutbe2.spr";
new const rutbe[] = "sprites/csgonew4/rutbe.spr";

new const rank_up[] = "csgonew4/rank_up.wav";
new const rank_up2[] = "csgonew4/rank_up2.wav";

new Float:pPlayerSpr[MAX_PLAYERS + 1][3];
new bool:pPlayerSprBlock[MAX_PLAYERS + 1];

new PlayerXp[33]
new PlayerLevel[33]

new g_Vault
new savexp, save_type

new const separator[] = "************************************************"
new const in_prefix[] = "[CSD ADMIN PREFIX v2018-FINAL]"
new const prefixfile[] = "addons/amxmodx/configs/ap_prefixes.ini";
new const usersfile[] = "addons/amxmodx/configs/users.ini";
new iPlayer,displaymode_cvar, g_CVAR[3];

public plugin_init()
{
	register_plugin("CSDURAGI ADMIN PREFIX 2018", VERSION, " Alt Yapi m0skVi4a | Cevirmen Ve Ek ozellikler TahaDemirbas")

	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", 1);
	register_forward(FM_CheckVisibility, "fw_CheckVisibility");

	save_type = register_cvar("levels_savetype","0") // Save Xp to : 0 = NVault.
	savexp = register_cvar("levels_save","1") // Save Xp by : 2 = Name, 1 = SteamID, 0 = IP.
	
	g_bad_prefix = register_cvar("ap_bad_prefixes", "1")
	g_listen = register_cvar("ap_listen", "1")
	g_listen_flag = register_cvar("ap_listen_flag", "a")
	g_custom = register_cvar("ap_custom_current", "1")
	g_custom_flag = register_cvar("ap_custom_current_flag", "b")
	g_say_characters = register_cvar("ap_say_characters", "1")
	g_prefix_characters = register_cvar("ap_prefix_characters", "1")
	displaymode_cvar = register_cvar("ap_displaymode","0") // 1 - HERKEZE GOSTER | 0- OLULER VE YASAYANLAR AYRI | 

	g_CVAR[0] = register_cvar("rutbe_killxp", "5");
	g_CVAR[1] = register_cvar("rutbe_deadxp", "-4");
	g_CVAR[2] = register_cvar("rutbe_headshotxp", "5");

	RegisterHookChain(RG_CBasePlayer_Killed, "@CBasePlayer_Killed", .post = true);

	g_saytxt = get_user_msgid ("SayText")
	g_maxplayers = get_maxplayers()
	
	register_concmd("ap_reload_prefixes", "LoadPrefixes")
	register_concmd("ap_reload_badprefixes", "LoadBadPrefixes")
	register_concmd("ap_put", "SetPlayerPrefix")
	register_clcmd("say", "HookSay")
	register_clcmd("say_team", "HookSayTeam")

	register_clcmd("rutbe_bilgi", "native_get_user_bilgi")
	/*register_clcmd("say /prefixmenu", "ShowMenu")
	register_clcmd("YeniTag", "tagekle")
	register_clcmd("IP_ADRES","ipadresi")
	register_clcmd("Tag_Goruntuleme_Yetkisi","tagyetkiekleveyaz")
	register_clcmd("OyuncuNicki","oyuncuismi")*/

	register_clcmd("amx_levelmenu", "levelmenu", ADMIN_RCON)
	register_clcmd("amx_levelver", "level_ver", ADMIN_RCON, "<authid, nick or #userid>")
	
	pre_ips_collect = TrieCreate()
	pre_names_collect = TrieCreate()
	pre_steamids_collect = TrieCreate()
	pre_flags_collect = TrieCreate()
	bad_prefixes_collect = TrieCreate()
	client_prefix = TrieCreate()

	register_dictionary("admin_prefixes.txt")

	get_configsdir(configs_dir, charsmax(configs_dir))
	formatex(file_prefixes, charsmax(file_prefixes), "%s/ap_prefixes.ini", configs_dir)
	formatex(file_bad_prefixes, charsmax(file_bad_prefixes), "%s/ap_bad_prefixes.ini", configs_dir)

	LoadPrefixes(0)
	LoadBadPrefixes(0)
}

@CBasePlayer_Killed(const pVictim, pAttacker, iGib) {
	if(pVictim == pAttacker || !is_user_connected(pAttacker) || !is_user_connected(pVictim) || !is_user_valid(pAttacker) || !is_user_valid(pVictim)) {
		return;
	}

	native_set_user_xp(pVictim, native_get_user_xp(pVictim) + get_pcvar_num(g_CVAR[1]));
	if(PlayerLevel[pAttacker] < sizeof RUTBE - 1) native_set_user_xp(pAttacker, native_get_user_xp(pAttacker) + get_pcvar_num(g_CVAR[0]));

	if(get_member(pVictim, m_bHeadshotKilled)) {
		native_set_user_xp(pAttacker, native_get_user_xp(pAttacker) + get_pcvar_num(g_CVAR[2]));
	}

	SaveLevel(pAttacker)
	check_level(pAttacker)

	SaveLevel(pVictim)
	check_level(pVictim)
}

public fw_AddToFullPack_Post(es, e, ent, host, hostflags, player, pSet)
{
	if(!is_user_connected(host) || !is_user_valid(host))
		return FMRES_IGNORED;

	if(is_nullent2(ent) || pPlayerSprBlock[host] || get_gametime() > pPlayerSpr[host][0])
		return FMRES_IGNORED;

	if(!is_user_alive(host))
		return FMRES_IGNORED;
	
	static Ent_Classname[64], iEnt;
	get_entvar(ent, var_classname, Ent_Classname, charsmax(Ent_Classname));
	iEnt = get_member(host, m_pActiveItem);

	if (!strcmp(Ent_Classname, "rutbe_screen"))
	{
		new Code = pev(ent, pev_iuser1)
		switch(Code)
		{
			/*new const RUTBE[][][] = {
				{ "UNRANKED", 0 },

				{ "SILVER I", 400 }, // 1
				{ "SILVER II", 600 }, // 2
				{ "SILVER III", 800 }, // 3
				{ "SILVER IV", 1000 }, // 4
				{ "SILVER ELITE", 1400 }, // 5
				{ "SILVER ELITE MASTER", 1800 }, // 6

				{ "GOLD NOVA I", 2000 }, // 7
				{ "GOLD NOVA II", 2500 }, // 8
				{ "GOLD NOVA III", 3000 }, // 9
				{ "GOLD NOVA MASTER", 3400 }, // 10

				{ "MASTER GUARDIAN I", 3800 }, // 11
				{ "MASTER GUARDIAN II", 4500 }, // 12
				{ "MASTER GUARDIAN ELITE", 6400 }, // 13
				{ "DISTINGUISHED MASTER GUARDIAN", 7400 }, // 14

				{ "LEGENDARY EAGLE", 8500 }, // 15
				{ "LEGENDARY EAGLE MASTER", 10000 }, // 16

				{ "SUPREME MASTER FIRST CLASS", 15000 }, // 17
				{ "THE GLOBAL ELITE", 20000 } // 18
			}*/
			case 0:
			{
				if(PlayerLevel[host] >= 1 && PlayerLevel[host] <= 6)
				{
					set_es(es, ES_MoveType, MOVETYPE_FOLLOW);
					set_es(es, ES_RenderMode, kRenderTransAlpha);
					set_es(es, ES_RenderAmt, 255);
					switch(WEAPON_ENT(iEnt))
					{
						case WEAPON_KNIFE: set_es(es, ES_Body, 1);
						default: set_es(es, ES_Body, 3);
					}
					set_es(es, ES_Skin, host);
					set_es(es, ES_AimEnt, host);
					set_es(es, ES_Frame, float(PlayerLevel[host] - 1));
					set_es(es, ES_Scale, 0.0305);
				}
			}
			case 1:
			{
				if(PlayerLevel[host] >= 7 && PlayerLevel[host] <= 18)
				{
					set_es(es, ES_MoveType, MOVETYPE_FOLLOW);
					set_es(es, ES_RenderMode, kRenderTransAlpha);
					
					if(pPlayerSpr[host][0] < get_gametime() - 1) {
						pPlayerSpr[host][2] += 50.0;
						for(new d = 0; d <= 3; d++) {
							
						}
					}
					else if()

					set_es(es, ES_RenderAmt, floatround(pPlayerSpr[host][2]));
					switch(WEAPON_ENT(iEnt))
					{
						case WEAPON_KNIFE: set_es(es, ES_Body, 1);
						default: set_es(es, ES_Body, 3);
					}
					set_es(es, ES_Skin, host);
					set_es(es, ES_AimEnt, host);
					set_es(es, ES_Frame, float(PlayerLevel[host] - 7));
					set_es(es, ES_Scale, 0.0305);
				}
			}
		}
		
		//pPlayerSpr[id][0] = get_gametime() + 5.0;
		//pPlayerSprBlock[id] = false;
		//pPlayerSpr[id][1] = 1.0;

		return FMRES_HANDLED;
	}

	return FMRES_IGNORED;
}

public fw_CheckVisibility(iEnt, pSet)
{
	static Ent_Classname[64];
	get_entvar(iEnt, var_classname, Ent_Classname, charsmax(Ent_Classname));

	if(!strcmp(Ent_Classname, "rutbe_screen")) 
	{
		forward_return(FMV_CELL, 1);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public plugin_precache()
{
	precache_model(rutbe2);
	precache_model(rutbe);

	engfunc(EngFunc_PrecacheSound, rank_up);
	engfunc(EngFunc_PrecacheSound, rank_up2);

	new iEnt;
	for(new i = 0; i <= 1; i++)
	{
		iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));
		set_pev(iEnt, pev_classname, "rutbe_screen");
		set_pev(iEnt, pev_scale, 0.0305);
		engfunc(EngFunc_SetModel, iEnt, i == 0 ? rutbe2 : rutbe);
		set_pev(iEnt, pev_rendermode, kRenderTransTexture);
		set_pev(iEnt, pev_renderamt, 0.0);
		set_pev(iEnt, pev_iuser1, i)
	}
}

// Level sifirlama
public levelmenu(id)
{
	if(get_user_flags(id) & ADMIN_RCON)
	{
		static amenu[512]
		formatex(amenu,charsmax(amenu),"\yLevel Sifirlama icin oyuncu sec")
		new menuz = menu_create(amenu,"silmemenu_devam")
		
		new players[32], tempid, pnum
		new szName[32], szTempid[10]
		get_players(players, pnum)
		
		for(new i; i < pnum; i++)
		{
			tempid = players[i]
			if(is_user_connected(tempid) && !is_user_bot(tempid))
			{
				get_user_name(tempid, szName, 31)
				num_to_str(tempid, szTempid, 9)
				
				formatex(amenu, charsmax(amenu), "\w%s", szName)
				menu_additem(menuz, amenu, szTempid)
			}
		}
		
		menu_setprop(menuz,MPROP_EXIT,MEXIT_ALL)
		menu_display(id,menuz,0)
	}
	
	return PLUGIN_HANDLED
}

public silmemenu_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new tempid = str_to_num(data)
	
	silmeislem(id, tempid)
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public silmeislem(id, player) {
	if (!player)
	return PLUGIN_HANDLED
	
	native_set_user_xp(player, 0)
	native_set_user_level(player, 0)
	SaveLevel(player)
	
	return PLUGIN_HANDLED
}

// Level verme
public level_ver(id, level, cid)
{
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
	
	new arg[32], arg2[10], arg3[3]
	read_argv(1, arg, charsmax(arg))
	read_argv(2, arg2, charsmax(arg2))
	read_argv(3, arg3, charsmax(arg3))
	
	if(arg3[0])
		return PLUGIN_HANDLED
	
	new player = cmd_target(id, arg, charsmax(arg))
	if(!player)
		return PLUGIN_HANDLED
	
	native_set_user_xp(player, str_to_num(arg2))
	SaveLevel(player)
	check_level(player)

	return PLUGIN_HANDLED
}

public check_level(id)
{
	if(PlayerLevel[id] < sizeof RUTBE - 1 && is_user_connected(id))
	{
		if(PlayerXp[id] >= RUTBE[1][1][0])
		{
			pPlayerSpr[id][0] = 0.0;

			while(PlayerXp[id] >= RUTBE[PlayerLevel[id] + 1][1][0])
			{
				PlayerLevel[id]++
				SaveLevel(id)
				
				client_print_color(0, print_team_red, "^1[ ^3%n ^1] Adli Oyuncu ^1[ ^3%s. ^1] Rutbesine Ulasti.", id, RUTBE[PlayerLevel[id]][0])

				//pPlayerSpr[id][0] = get_gametime() + 5.0;
				//pPlayerSprBlock[id] = false;
				pPlayerSpr[id][1] = 1.0;
				pPlayerSpr[id][2] = 50.0;
			}
		}
	}
}

public native_get_user_bilgi(id)
{
	client_print_color(id, print_team_red, "^4[RUTBE] ^3Toplam XP: ^4'%i' ^3Suanki Rutben: ^4'%s'", PlayerXp[id], RUTBE[PlayerLevel[id]][0])
	if(PlayerLevel[id] < sizeof RUTBE - 1)
	{
		//ColorChat(id,"^4[RUTBE] ^3Sonraki Rutbe: ^4'%s' ^3Oldurmen gereken: ^4'%i'",rankNames[PlayerLevel[id] + 1], (native_get_user_max_level(id) - PlayerXp[id]))
		client_print_color(id, print_team_red, "^4[RUTBE] ^3Sonraki Rutbe: ^4'%s' ^3Rutbe Atlamak Icin Gereken XP: ^4'%i'", RUTBE[PlayerLevel[id] + 1][0], (RUTBE[PlayerLevel[id] + 1][1][0] - PlayerXp[id]))
	}
}

public plugin_cfg()
{
	//Open our vault and have g_Vault store the handle.
	g_Vault = nvault_open("rutbe")

	//Make the plugin error if vault did not successfully open
	if ( g_Vault == INVALID_HANDLE )
		set_fail_state( "Error opening levels nVault, file does not exist!" )
}

public plugin_end()
{
	//Close the vault when the plugin ends (map change\server shutdown\restart)
	nvault_close(g_Vault)
}

public client_connect(id)
{
	pPlayerSprBlock[id] = true;

	LoadLevel(id)
}

public client_disconnected(id)
{
	pPlayerSprBlock[id] = true;

	SaveLevel(id)
	
	PlayerXp[id] = 0
	PlayerLevel[id] = 0
}

SaveLevel(id)
{
	new szAuth[33];
	new szKey[64];
	
	if (get_pcvar_num(savexp) == 0)
	{
		get_user_ip(id, szAuth , charsmax(szAuth), 1)
		formatex(szKey , 63 , "%s-IP" , szAuth)
	}
	else if (get_pcvar_num(savexp) == 1)
	{
		get_user_authid(id , szAuth , charsmax(szAuth))
		formatex(szKey , 63 , "%s-ID" , szAuth)
	}
	else if (get_pcvar_num(savexp) == 2)
	{
		get_user_name(id, szAuth , charsmax(szAuth))
		formatex(szKey , 63 , "%s-NAME" , szAuth)
	}
	
	if (!get_pcvar_num(save_type))
	{
		new szData[256]
		
		formatex(szData , 255 , "%i#%i#" , PlayerLevel[id], PlayerXp[id])
		
		nvault_pset(g_Vault , szKey , szData)
	}
}

LoadLevel(id)
{
	new szAuth[33];
	new szKey[40];
	
	if (get_pcvar_num(savexp) == 0)
	{
		get_user_ip(id, szAuth , charsmax(szAuth), 1)
		formatex(szKey , 63 , "%s-IP" , szAuth)
	}
	else if (get_pcvar_num(savexp) == 1)
	{
		get_user_authid(id , szAuth , charsmax(szAuth))
		formatex(szKey , 63 , "%s-ID" , szAuth)
	}
	else if (get_pcvar_num(savexp) == 2)
	{
		get_user_name(id, szAuth , charsmax(szAuth))
		formatex(szKey , 63 , "%s-NAME" , szAuth)
	}
	
	if (!get_pcvar_num(save_type))
	{
		new szData[256];
		
		formatex(szData , 255, "%i#%i#", PlayerLevel[id], PlayerXp[id])
		
		nvault_get(g_Vault, szKey, szData, 255)
		
		replace_all(szData , 255, "#", " ")
		new xp[32], level[32]
		parse(szData, level, 31, xp, 31)
		PlayerLevel[id] = str_to_num(level)
		PlayerXp[id] = str_to_num(xp)
	}
}

public plugin_natives()
{
	register_native("get_user_xp", "native_get_user_xp", 1)
	register_native("set_user_xp", "native_set_user_xp", 1)
	register_native("get_user_level", "native_get_user_level", 1)
	register_native("set_user_level", "native_set_user_level", 1)
	register_native("get_user_bilgi", "native_get_user_bilgi", 1)
	register_native("get_rankname", "native_get_rankname")
}

public native_get_rankname()
{
	new level = get_param(1);

	set_array(2, RUTBE[level][0], get_param(3));
}

// Native: get_user_xp
public native_get_user_xp(id)
{
	return PlayerXp[id]
}

// Native: set_user_xp
public native_set_user_xp(id, amount)
{
	PlayerXp[id] = amount
}

// Native: get_user_level
public native_get_user_level(id)
{
	return PlayerLevel[id]
}

// Native: set_user_xp
public native_set_user_level(id, amount)
{
	PlayerLevel[id] = amount
}

public ShowMenu(id, lvl, cid)
{

	if(!access(id,ADMIN_RCON)) {
		ColorChat(id,"^4[%s]^3 Buraya Girmeye Hakkin Yok!",in_prefix)
		return PLUGIN_HANDLED
	}	

	new menu = menu_create("\rCSDURAGI\y PREFIX KONTROL MENUSU\d | v2018-FINAL^n\wLutfen Cakismalari onlemek icin \rDiger Say\w Eklentilerini Kapatin.!", "MenuDevam");

	menu_additem(menu, "\yYeni Tag Ekle \d| Sayda Gozukecek Yeni Tag Ekler", "", 0); // case 0
	menu_additem(menu, "\wMevcut Tag Listesi\d | Mevcut Taglari Goruntuler", "", 0); // case 1
	menu_additem(menu, "\rCSDADM Prefix Ayarlari\d", "", 0); // case 2
	menu_additem(menu, "\dCSduragi Gelismis Admin PREFIX (c) 2018 ", "", 0); // case 2

	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_setprop(menu, MPROP_BACKNAME, "Geri");
	menu_setprop(menu, MPROP_NEXTNAME, "Ileri");
	menu_setprop(menu, MPROP_EXITNAME, "Cikis");
	menu_setprop(menu, MPROP_NOCOLORS, 1);

	menu_display(id, menu, 0);

	return PLUGIN_HANDLED;
}

public MenuDevam(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_cancel(id);
		return PLUGIN_HANDLED;
	}

	new command[6], name[64], access, callback;

	menu_item_getinfo(menu, item, access, command, sizeof command - 1, name, sizeof name - 1, callback);

	switch(item)
	{
		case 0:
		{
			
			
			TagturuMenu(id)

		}
		case 1: 
		{
			
			Taglistesi(id)

			
			
		}
		case 2:
		{
			Ayarlar(id)
			
		}
		case 3: 
		{
			
		}
	}

	menu_destroy(menu);

	return PLUGIN_HANDLED;
}	
	

public Ayarlar(id)
{
	if(!access(id,ADMIN_RCON)) {
		ColorChat(id,"^4[%s]^3 Buraya Girmeye Hakkin Yok!",in_prefix)
		return PLUGIN_HANDLED
	}
	
	
	new menu = menu_create("\rCSDURAGI ADMIN PREFIX-FINAL \d|| Ayarlar Menusu", "ayarlar_handled");

	if(get_pcvar_num(g_listen) == 1){
		menu_additem(menu, "\yCSD Admin Prefix\d |\y ACIK ", "", 0); // case 0
	}
	else
	{
		menu_additem(menu, "\dCSD Admin Prefix\d |\r KAPALI ", "", 0); // case 0	
	}
	if(get_pcvar_num(g_say_characters) == 1){
		menu_additem(menu, "\ySay Ozel Karakterlerini Gizle\d |\y ACIK", "", 0); // case 1
	}
	else
	{
		menu_additem(menu, "\dSay Ozel Karakterlerini Gizle\d |\r KAPALI", "", 0); // case 1
	}
	if(get_pcvar_num(g_prefix_characters) == 1){
		menu_additem(menu, "\yPrefix Ozel Karakterlerini Filtrele\d |\y ACIK", "", 0); // case 2
	}
	else
	{
		menu_additem(menu, "\dPrefix Ozel Karakterlerini Filtrele\d |\r KAPALI", "", 0); // case 2
	}
	if(get_pcvar_num(displaymode_cvar) == 1){
		menu_additem(menu, "\yOluler Ile Canlilar Arasi Yazili Iletisim\d |\y ACIK", "", 0); // case 3
	}
	else
	{
		menu_additem(menu, "\dOluler Ile Canlilar Arasi Yazili Iletisim\d |\r KAPALI", "", 0); // case 3
	}

	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_setprop(menu, MPROP_BACKNAME, "Geri");
	menu_setprop(menu, MPROP_NEXTNAME, "Ileri");
	menu_setprop(menu, MPROP_EXITNAME, "Cikis");

	menu_display(id, menu, 0);

	return PLUGIN_HANDLED;
}

public ayarlar_handled(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_cancel(id);
		return PLUGIN_HANDLED;
	}

	new command[6], name[64], access, callback;

	menu_item_getinfo(menu, item, access, command, sizeof command - 1, name, sizeof name - 1, callback);

	switch(item)
	{
		case 0:
		{
			if(get_pcvar_num(g_listen) == 1)
				server_cmd("amx_cvar ap_listen 0")
				
			if(get_pcvar_num(g_listen) == 0)
				server_cmd("amx_cvar ap_listen 1")
				
			set_task(1.5,"Ayarlar",id)
		}
		case 1:
		{
			if(get_pcvar_num(g_say_characters) == 1)
				server_cmd("amx_cvar ap_say_characters 0")
			
			if(get_pcvar_num(g_say_characters) == 0)
				server_cmd("amx_cvar ap_say_characters 1")
				
			set_task(1.5,"Ayarlar",id)
		}		
		case 2:
		{
			if(get_pcvar_num(g_prefix_characters) == 1)
				server_cmd("amx_cvar ap_prefix_characters 0")
			
			if(get_pcvar_num(g_prefix_characters) == 0)
				server_cmd("amx_cvar ap_prefix_characters 1")
				
			set_task(1.5,"Ayarlar",id)
		}
		case 3:
		{
			if(get_pcvar_num(displaymode_cvar) == 1)
				server_cmd("amx_cvar ap_displaymode 0")
			
			if(get_pcvar_num(displaymode_cvar) == 0)
				server_cmd("amx_cvar ap_displaymode 1")
				
			set_task(1.5,"Ayarlar",id)
		}
		
	}
	return PLUGIN_HANDLED
}
	
	
new yazmaturu[64] = 0	
public TagturuMenu(id)
{
	new menu = menu_create("\yTag Ekleme Turu Seciniz", "tagturu_handled");

	menu_additem(menu, "\wSteam ID Tag\d | Secilen Steam Kisisine Ozel Tag", "", 0); // case 0
	menu_additem(menu, "\wIP Adresine Ozel Tag\d | Ip adresi eslesen oyuncuda tag olacak.", "", 0); // case 1
	menu_additem(menu, "\wNicke Ozel Tag \d| Belirtilen Nickle Girene Ozel Tag", "", 0); // case 2
	menu_additem(menu, "\wYetkiye Ozel Tag\d | belirtilen yetkide olan kisilere tag verilecek.", "", 0); // case 3
	menu_additem(menu, "\wYetkili Listesinden Al\d | Users.ini'deki secilen yetkiliye tag verilecek.", "", 0); // case 4

	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_setprop(menu, MPROP_BACKNAME, "Geri");
	menu_setprop(menu, MPROP_NEXTNAME, "Ileri");
	menu_setprop(menu, MPROP_EXITNAME, "Cikis");

	menu_display(id, menu, 0);

	return PLUGIN_HANDLED;
}



public tagturu_handled(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_cancel(id);
		return PLUGIN_HANDLED;
	}

	new command[6], name[64], access, callback;

	menu_item_getinfo(menu, item, access, command, sizeof command - 1, name, sizeof name - 1, callback);

	switch(item)
	{
		case 0:
		{
			yazmaturu[id] = 1
			SteamIDMenu(id)
			
		
		
		}
		case 1:
		{
			
			yazmaturu[id] = 2
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 IP Adresini Yazarken Dikkat Ediniz.!",in_prefix)
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 IP Adresi yazarken^3 xxx.xxx.xxx.xxx^4 Olarak Girmelisiniz.",in_prefix)
			client_cmd(id,"messagemode IP_ADRES")		
			
		}
		case 2:
		{
		
			yazmaturu[id] = 3
			
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Nicki Yazarken Dikkat Ediniz.!",in_prefix)
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Nicki yazarken^3 Eksiksiz^4 Olarak Girmelisiniz.",in_prefix)
			client_cmd(id,"messagemode OyuncuNicki")
		
		}
		case 3:
		{
			
			yazmaturu[id] = 4
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Tag Yazarken^3 [,],{,}^4 Gibi Isaretler Kullanmayiniz.",in_prefix)
			ColorChat(id,"^4[%s]^3 Yazacaginiz Tag Ichat uygulamasi gibi Say'in Sol Tarafinda Gosterilecek.",in_prefix)
			ColorChat(id,"^4[%s]^3 Ornek :^4 Kurucu^3 s harfi iken^4 Slot^3 j Harfi^4 Olacak..",in_prefix)
			client_cmd(id,"messagemode YeniTag")
			
		}
		case 4:
		{
			
			yazmaturu[id] = 3
			ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Tag Yazarken^3 [,],{,}^4 Gibi Isaretler Kullanmayiniz.",in_prefix)
			ColorChat(id,"^4[%s]^3 Yazacaginiz Tag Ichat uygulamasi gibi Say'in Sol Tarafinda Gosterilecek.",in_prefix)
			ColorChat(id,"^4[%s]^3 Ornek :^4 Kurucu^3 s harfi iken^4 Slot^3 j Harfi^4 Olacak..",in_prefix)
			Yetkililistesi(id)
			
		}
	}

	menu_destroy(menu);

	return PLUGIN_HANDLED;
}
new oyuncunick[32]
public Yetkililistesi(id) {
	new menu = menu_create("\rYetkili Listesi\d | CSD ADMIN PREFIX 2018-FINAL","Yetlis_handler")
	
	new szLine[248];
	new LineName[32]
	new maxlines,txtlen,linee[6];
	maxlines = file_size(usersfile,1);
	for(new line;line<maxlines;line++) {
		szLine[0] = 0;
		LineName[0] = 0;
		
		read_file(usersfile,line,szLine,247,txtlen)
		
		if(szLine[0]) {
			parse(szLine,LineName,31)
			if(!equali(LineName,";") ) {
				num_to_str(line,linee,5)
				menu_additem(menu,LineName,"1")
			}
		}
	}
	menu_setprop(menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,menu,0)
	return PLUGIN_HANDLED
}	

public Yetlis_handler(id,menu,item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new data[6],name[333];
	new access,callback;
	menu_item_getinfo(menu,item,access,data,5,name,332,callback)

	if(equali(data,"1")) {
		
		ColorChat(id,"^4[%s] ^1%s^4 Adli Yetkili Icin Tag Giriniz.!",in_prefix,name)
		copy(oyuncunick,charsmax(oyuncunick),name)
		client_cmd(id,"messagemode YeniTag")
		
	}
	return PLUGIN_HANDLED
}



new ip[32]
public ipadresi(id){
		
	
	read_args(ip,31)
	remove_quotes(ip)
	client_cmd(id,"messagemode YeniTag")
	
	
	
	
	
	
		
}


public oyuncuismi(id){
	
	read_args(oyuncunick,31)
	remove_quotes(oyuncunick)
	client_cmd(id,"messagemode YeniTag")
	
	
	
}
	
new authid[64]
public SteamIDMenu( id )
	{	
		new iPlayers[ 32 ], iNum;
		get_players( iPlayers, iNum );
		
		new szInfo[ 6 ], hMenu;
		hMenu = menu_create( "Steam ID Almak icin Adam Sec..:", "InviteMenu_Handler" );
		new szName[ 32 ];
		
		for( new i = 0, iPlayer; i < iNum; i++ )
		{
			iPlayer = iPlayers[ i ];
			
			
			
				
			get_user_name( iPlayer, szName, charsmax( szName ) );
			
			num_to_str( iPlayer, szInfo, charsmax( szInfo ) );
			
			menu_additem( hMenu, szName, szInfo );
		}
			
		menu_display( id, hMenu, 0 );
	}	
	
	
	
public InviteMenu_Handler( id, hMenu, iItem)
	{
		if( iItem == MENU_EXIT )
		{
			return PLUGIN_HANDLED;
		}
		
		new szData[ 6 ], iAccess, hCallback, szName[ 32 ];
		menu_item_getinfo( hMenu, iItem, iAccess, szData, 5, szName, 31, hCallback );
		
		iPlayer = str_to_num( szData );

		if( !is_user_connected( iPlayer ) )
			return PLUGIN_HANDLED;
			
			
		get_user_authid(iPlayer,authid,63)
		new tagname[32]
		get_user_name(iPlayer,tagname,31)
			
		ColorChat(id,"^4[%s]^4 %s^3 Steam Id Adresli^4 %s^3 Oyuncusuna Verilecek Tagi Yazin..",in_prefix,authid,tagname)
		client_cmd(id,"messagemode YeniTag")	
		

		return PLUGIN_HANDLED;
	}
	

	
	
	
public Taglistesi(id) {
	new menu = menu_create("\rTag Listesi\d | CSD ADMIN PREFIX-FINAL ","TagSil")
	
	new szLine[248];
	new LineName[32],LinePW[32],LineAccess[32],LineFlag[32];
	new maxlines,txtlen,linee[6];
	maxlines = file_size(prefixfile,1);
	for(new line;line<maxlines;line++) {
		szLine[0] = 0;
		LineName[0] = 0;
		LinePW[0] = 0;
		LineAccess[0] = 0;
		LineFlag[0] = 0;
		read_file(prefixfile,line,szLine,247,txtlen)
		
		if(szLine[0]) {
			parse(szLine,LineName,31,LinePW,31,LineAccess,31,LineFlag,31)
			if(!equali(LineName,";") ) {
				num_to_str(line,linee,5)
				menu_additem(menu,LineAccess)
			}
		}
	}
	menu_setprop(menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,menu,0)
	return PLUGIN_HANDLED
}	

new tag[32];
new tagyetki[32];

public TagSil(id,menu,item) {
	
	
	return PLUGIN_HANDLED
	
}
public tagekle(id){
	
	
	read_args(tag,31)
	remove_quotes(tag)
	
	if(yazmaturu[id] == 5){
		
		if(Tag_kontrol(tag)) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Tagi Daha Onceden Kullanmissiniz.",in_prefix)
			client_cmd(id,"messagemode YeniTag")
			return PLUGIN_HANDLED
		}
		
		tagyetkiekleveyaz(id)	
	}
	if(yazmaturu[id] == 1){
		
		if(Tag_kontrol(tag)) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Tagi Daha Onceden Kullanmissiniz.",in_prefix)
			client_cmd(id,"messagemode YeniTag")
			return PLUGIN_HANDLED
		}
		
		tagyetkiekleveyaz(id)	
	}
	if(yazmaturu[id] == 2){
		
		
		if(Tag_kontrol(ip[iPlayer])) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Ip Adresini Daha Onceden Kullanmissiniz.",in_prefix)
			client_cmd(id,"messagemode IP_ADRES")
			return PLUGIN_HANDLED
		}
	
		tagyetkiekleveyaz(id)
	}
	if(yazmaturu[id] == 3){
		
		
		if(Tag_kontrol(oyuncunick[iPlayer])) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Nicki Daha Onceden Kullanmissiniz.",in_prefix)
			client_cmd(id,"messagemode OyuncuNicki")
			return PLUGIN_HANDLED
		}
	
		tagyetkiekleveyaz(id)
	}
	
	
	if(yazmaturu[id] == 4){
		
		if(Tag_kontrol(tag)) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Tagi Daha Onceden Kullanmissiniz.",in_prefix)
			client_cmd(id,"messagemode YeniTag")
			return PLUGIN_HANDLED
		}
		
		ColorChat(id,"^4[%s]^3 Tag Goruntulemek Icin Yetki Harfi Girin (^4 b,c,d,e gibi^3) ",in_prefix)
		ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Yetki Harfleri Girilirken Alfabetik Sirayi Goz onune Alin. Buyuk Yetkiler Alfabetik Siralanmali.",in_prefix)
		ColorChat(id,"^4[%s]^3 DÝKKAT:^4 Tag Yazarken^3 [,],{,}^4 Gibi Isaretler Kullanmayiniz.",in_prefix)

		client_cmd(id,"messagemode Tag_Goruntuleme_Yetkisi")
	}
	
	return PLUGIN_HANDLED
}
public tagyetkiekleveyaz(id){	
	read_args(tagyetki,31)
	remove_quotes(tagyetki)
	
	if(yazmaturu[id] == 1){
		if(Tag_kontrol(authid[iPlayer])) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu authid'yi Baska Bir Tagta kullandiniz.!",in_prefix)
			TagturuMenu(id)
			return PLUGIN_HANDLED
		}	
	}
	if(yazmaturu[id] == 4){
		if(Tag_kontrol(tagyetki)) {
			ColorChat(id,"^4[%s] ^3HATA:^4 Bu Yetkiyi Baska Bir Tagta kullandiniz.!",in_prefix)
			client_cmd(id,"messagemode YeniTag")
			return PLUGIN_HANDLED
		}
	}
	
	new szLine[248]
	
	if(yazmaturu[id] == 1){
		formatex(szLine,247,"^"s^" ^"%s^" ^"[%s]^" ^n",authid,tag)
		write_file(prefixfile,szLine)
		server_cmd("ap_reload_prefixes")
	}
	if(yazmaturu[id] == 2){
		formatex(szLine,247,"^"i^" ^"%s^" ^"[%s]^" ^n",ip,tag)
		write_file(prefixfile,szLine)
		server_cmd("ap_reload_prefixes")
	}
	
	if(yazmaturu[id] == 3){
		formatex(szLine,247,"^"n^" ^"%s^" ^"[%s]^" ^n",oyuncunick,tag)
		write_file(prefixfile,szLine)
		server_cmd("ap_reload_prefixes")
	}
	
	
	if(yazmaturu[id] == 4){
		formatex(szLine,247,"^"f^" ^"%s^" ^"[%s]^" ^n",tagyetki,tag)
		write_file(prefixfile,szLine)
		server_cmd("ap_reload_prefixes")
	}

	ColorChat(id,"^4[%s]^3 Tag Basariyla Aktiflestirildi.!",in_prefix)
	ColorChat(id,"^4[%s]^3 Yazmis Oldugunuz Tag :^4 [%s]^3 Playerismi",in_prefix,tag)
	
	client_cmd(id,"say /prefixmenu")
	
	return PLUGIN_HANDLED
	
}
	
	
stock Tag_kontrol(const Name[]) {
	new szLine[248];
	new LineName[32],blabla[32];
	new maxlines,txtlen;
	maxlines = file_size(prefixfile,1);
	for(new line;line<maxlines;line++) {
		read_file(prefixfile,line,szLine,247,txtlen)
		parse(szLine,LineName,31,blabla,31)
		if(equali(LineName,Name)) {
			return 1;
		}
	}
	return 0;
} 	
	
public LoadPrefixes(id)
{
	if(!(get_user_flags(id) & FLAG_LOAD))
	{
		console_print(id, "%L", LANG_SERVER, "PREFIX_PERMISSION", in_prefix)
		return PLUGIN_HANDLED
	}

	TrieClear(pre_ips_collect)
	TrieClear(pre_names_collect)
	TrieClear(pre_steamids_collect)
	TrieClear(pre_flags_collect)

	line = 0, length = 0, pre_flags_count = 0, pre_ips_count = 0, pre_names_count = 0;

	if(!file_exists(file_prefixes)) 
	{
		formatex(error, charsmax(error), "%L", LANG_SERVER, "PREFIX_NOT_FOUND", in_prefix, file_prefixes)
		set_fail_state(error)
	}

	server_print(separator)

	while(read_file(file_prefixes, line++ , text, charsmax(text), length) && (pre_ips_count + pre_names_count + pre_steamids_count + pre_flags_count) <= MAX_PREFIXES)
	{
		if(!text[0] || text[0] == '^n' || text[0] == ';' || (text[0] == '/' && text[1] == '/'))
			continue

		parse(text, type, charsmax(type), key, charsmax(key), prefix, charsmax(prefix))
		trim(prefix)

		if(!type[0] || !prefix[0] || !key[0])
			continue

		replace_all(prefix, charsmax(prefix), "!g", "^x04")
		replace_all(prefix, charsmax(prefix), "!t", "^x03")
		replace_all(prefix, charsmax(prefix), "!n", "^x01")

		switch(type[0])
		{
			case 'f':
			{
				pre_flags_count++
				TrieSetString(pre_flags_collect, key, prefix)
				server_print("%L", LANG_SERVER, "PREFIX_LOAD_FLAG", in_prefix, prefix, key[0])
			}
			case 'i':
			{
				pre_ips_count++
				TrieSetString(pre_ips_collect, key, prefix)
				server_print("%L", LANG_SERVER, "PREFIX_LOAD_IP", in_prefix, prefix, key)
			}
			case 's':
			{
				pre_steamids_count++
				TrieSetString(pre_steamids_collect, key, prefix)
				server_print("%L", LANG_SERVER, "PREFIX_LOAD_STEAMID", in_prefix, prefix, key)
			}
			case 'n':
			{
				pre_names_count++
				TrieSetString(pre_names_collect, key, prefix)
				server_print("%L", LANG_SERVER, "PREFIX_LOAD_NAME", in_prefix, prefix, key)
			}
			default:
			{
				continue
			}
		}
	}

	if(pre_flags_count <= 0 && pre_ips_count <= 0 && pre_steamids_count <= 0 && pre_names_count <= 0)
	{
		server_print("%L", LANG_SERVER, "PREFIX_NO", in_prefix)
	}

	get_user_name(id, g_name, charsmax(g_name))
	server_print("%L", LANG_SERVER, "PREFIX_LOADED_BY", in_prefix, g_name)
	console_print(id, "%L", LANG_SERVER, "PREFIX_LOADED", in_prefix)

	server_print(separator)

	for(new i = 1; i <= g_maxplayers; i++)
	{
		num_to_str(i, str_id, charsmax(str_id))
		TrieDeleteKey(client_prefix, str_id)
		PutPrefix(i)
	}

	return PLUGIN_HANDLED
}

public LoadBadPrefixes(id)
{
	if(!get_pcvar_num(g_bad_prefix))
	{
		console_print(id, "%L", LANG_SERVER, "BADP_OFF", in_prefix)
		return PLUGIN_HANDLED
	}

	if(!(get_user_flags(id) & FLAG_LOAD))
	{
		console_print(id, "%L", LANG_SERVER, "BADP_PERMISSION", in_prefix)
		return PLUGIN_HANDLED
	}

	TrieClear(bad_prefixes_collect)

	line = 0, length = 0, bad_prefix_count = 0;

	if(!file_exists(file_bad_prefixes)) 
	{
		console_print(id, "%L", LANG_SERVER, "BADP_NOT_FOUND", in_prefix, file_bad_prefixes)
		return PLUGIN_HANDLED		
	}

	server_print(separator)

	while(read_file(file_bad_prefixes, line++ , text, charsmax(text), length) && bad_prefix_count <= MAX_BAD_PREFIXES)
	{
		if(!text[0] || text[0] == '^n' || text[0] == ';' || (text[0] == '/' && text[1] == '/'))
			continue

		parse(text, prefix, charsmax(prefix))

		if(!prefix[0])
			continue

		bad_prefix_count++
		TrieSetCell(bad_prefixes_collect, prefix, 1)
		server_print("%L", LANG_SERVER, "BADP_LOAD", in_prefix, prefix)
	}

	if(bad_prefix_count <= 0)
	{
		server_print("%L", LANG_SERVER, "BADP_NO", in_prefix)
	}

	get_user_name(id, g_name, charsmax(g_name))
	server_print("%L", LANG_SERVER, "BADP_LOADED_BY", in_prefix, g_name)
	console_print(id, "%L", LANG_SERVER, "BADP_LOADED", in_prefix)

	server_print(separator)

	return PLUGIN_HANDLED
}

public client_putinserver(id)
{
	g_toggle[id] = true
	num_to_str(id, str_id, charsmax(str_id))
	TrieSetString(client_prefix, str_id, "")
	PutPrefix(id)
}

public HookSay(id)
{
	read_args(g_typed, charsmax(g_typed))
	remove_quotes(g_typed)

	trim(g_typed)

	if(equal(g_typed, "") || !is_user_connected(id))
		return PLUGIN_HANDLED_MAIN

	if(equal(g_typed, "/prefix"))
	{
		if(g_toggle[id])
		{
			g_toggle[id] = false
			client_print(id, print_chat, "%L", LANG_SERVER, "PREFIX_OFF", in_prefix)
		}
		else
		{
			g_toggle[id] = true
			client_print(id, print_chat, "%L", LANG_SERVER, "PREFIX_ON", in_prefix)
		}

		return PLUGIN_HANDLED_MAIN
	}

	if(!g_toggle[id])
		return PLUGIN_CONTINUE

	num_to_str(id, str_id, charsmax(str_id))

	if((TrieGetString(client_prefix, str_id, temp_prefix, charsmax(temp_prefix)) && get_pcvar_num(g_say_characters) == 1) || (!TrieGetString(client_prefix, str_id, temp_prefix, charsmax(temp_prefix)) && get_pcvar_num(g_say_characters) == 2) || get_pcvar_num(g_say_characters) == 3)
	{
		if(check_say_characters(g_typed))
			return PLUGIN_HANDLED_MAIN
	}

	get_user_name(id, g_name, charsmax(g_name))

	g_team = cs_get_user_team(id)

	if(temp_prefix[0])
	{
		formatex(g_message, charsmax(g_message), "^1%s^4[%s][%s]^3 %s :^4 %s", say_team_info[is_user_alive(id)][g_team], RUTBE[PlayerLevel[id]][0][0], temp_prefix, g_name, g_typed)
	}
	else
	{
		formatex(g_message, charsmax(g_message), "^1%s^4[%s]^3%s :^1 %s", say_team_info[is_user_alive(id)][g_team], RUTBE[PlayerLevel[id]][0][0], g_name, g_typed)
	}

	get_pcvar_string(g_listen_flag, temp_cvar, charsmax(temp_cvar))

	for(new i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue
			
		// 1 - HERKEZE GOSTER | 0- OLULER VE YASAYANLAR AYRI	
		if(get_pcvar_num(displaymode_cvar) == 0 ){
			if(is_user_alive(id) && is_user_alive(i) || !is_user_alive(id) && !is_user_alive(i))
			{
				send_message(g_message, id, i)
			}
		
		}
		if(get_pcvar_num(displaymode_cvar) == 1){
			//if(is_user_alive(id) && is_user_alive(i) || !is_user_alive(id) && !is_user_alive(i))
			
			
				send_message(g_message, id, i)
			
		
		}
	}

	return PLUGIN_HANDLED_MAIN
}

public HookSayTeam(id)
{
	read_args(g_typed, charsmax(g_typed))
	remove_quotes(g_typed)

	trim(g_typed)

	if(equal(g_typed, "") || !is_user_connected(id))
		return PLUGIN_HANDLED_MAIN

	if(equal(g_typed, "/prefix"))
	{
		if(g_toggle[id])
		{
			g_toggle[id] = false
			client_print(id, print_chat, "%L", LANG_SERVER, "PREFIX_OFF", in_prefix)
		}
		else
		{
			g_toggle[id] = true
			client_print(id, print_chat, "%L", LANG_SERVER, "PREFIX_ON", in_prefix)
		}

		return PLUGIN_HANDLED_MAIN
	}

	if(!g_toggle[id])
		return PLUGIN_CONTINUE

	num_to_str(id, str_id, charsmax(str_id))

	if((TrieGetString(client_prefix, str_id, temp_prefix, charsmax(temp_prefix)) && get_pcvar_num(g_say_characters) == 1) || (!TrieGetString(client_prefix, str_id, temp_prefix, charsmax(temp_prefix)) && get_pcvar_num(g_say_characters) == 2) || get_pcvar_num(g_say_characters) == 3)
	{
		if(check_say_characters(g_typed))
			return PLUGIN_HANDLED_MAIN
	}

	get_user_name(id, g_name, charsmax(g_name))

	g_team = cs_get_user_team(id)

	if(temp_prefix[0])
	{
		formatex(g_message, charsmax(g_message), "^1%s^4[%s][%s]^3 %s :^4 %s", sayteam_team_info[is_user_alive(id)][g_team], RUTBE[PlayerLevel[id]][0][0], temp_prefix, g_name, g_typed)
	}
	else
	{
		formatex(g_message, charsmax(g_message), "^1%s^4[%s]^3%s :^1 %s", sayteam_team_info[is_user_alive(id)][g_team], RUTBE[PlayerLevel[id]][0][0], g_name, g_typed)
	}

	get_pcvar_string(g_listen_flag, temp_cvar, charsmax(temp_cvar))

	for(new i = 1; i <= g_maxplayers; i++)
	{
		if(!is_user_connected(i))
			continue

		if(get_user_team(id) == get_user_team(i))
		{
			
			// 1 - HERKEZE GOSTER | 0- OLULER VE YASAYANLAR AYRI	
			if(get_pcvar_num(displaymode_cvar) == 1 ){
				//if(is_user_alive(id) && is_user_alive(i) || !is_user_alive(id) && !is_user_alive(i))
				
				
					send_message(g_message, id, i)
				
					
			}
			if(get_pcvar_num(displaymode_cvar) == 0 ){
				if(is_user_alive(id) && is_user_alive(i) || !is_user_alive(id) && !is_user_alive(i))
				{
					send_message(g_message, id, i)
				}
					
			}
		}
	}

	return PLUGIN_HANDLED_MAIN
}

public SetPlayerPrefix(id)
{
	if(!get_pcvar_num(g_custom) || !get_pcvar_string(g_custom_flag, temp_cvar, charsmax(temp_cvar)))
	{
		console_print(id, "%L", LANG_SERVER, "CUSTOM_OFF", in_prefix)
		return PLUGIN_HANDLED
	}

	if(!(get_user_flags(id) & read_flags(temp_cvar)))
	{
		console_print(id, "%L", LANG_SERVER, "CUSTOM_PERMISSION", in_prefix)
		return PLUGIN_HANDLED
	}

	new input[128], target;
	new arg_type[2], arg_prefix[32], arg_key[35];
	new temp_str[16];

	read_args(input, charsmax(input))
	remove_quotes(input)
	parse(input, arg_type, charsmax(arg_type), arg_key, charsmax(arg_key), arg_prefix, charsmax(arg_prefix))
	trim(arg_prefix)

	if(get_pcvar_num(g_bad_prefix) && is_bad_prefix(arg_prefix) && !equali(arg_prefix, ""))
	{
		console_print(id, "%L", LANG_SERVER, "CUSTOM_FORBIDDEN", in_prefix, arg_prefix)
		return PLUGIN_HANDLED
	}

	if(get_pcvar_num(g_prefix_characters) && check_prefix_characters(arg_prefix))
	{
		console_print(id, "%L", LANG_SERVER, "CUSTOM_SYMBOL", in_prefix, arg_prefix, forbidden_prefixes_symbols[i])
		return PLUGIN_HANDLED
	}

	switch(arg_type[0])
	{
		case 'f':
		{
			target = 0
			temp_str = "Flag"
		}
		case 'i':
		{
			target = find_player("d", arg_key)
			temp_str = "IP"
		}
		case 's':
		{
			target = find_player("c", arg_key)
			temp_str = "SteamID"
		}
		case 'n':
		{
			target = find_player("a", arg_key)
			temp_str = "Name"
		}
		default:
		{
			console_print(id, "%L", LANG_SERVER, "CUSTOM_INVALID", in_prefix, arg_type)
			return PLUGIN_HANDLED
		}
	}

	get_user_name(id, g_name, charsmax(g_name))

	if(equali(arg_prefix, ""))
	{
		find_and_delete(arg_type, arg_key)

		if(target)
		{
			PutPrefix(target)
		}
		
		console_print(id, "%L", LANG_SERVER, "CUSTOM_REMOVE", in_prefix, temp_str, arg_key)
		server_print("%L", LANG_SERVER, "CUSTOM_REMOVE_INFO", in_prefix, g_name, temp_str, arg_key)
		return PLUGIN_HANDLED
	}

	find_and_delete(arg_type, arg_key)

	formatex(text, charsmax(text), "^"%s^" ^"%s^" ^"%s^"", arg_type, arg_key, arg_prefix)
	write_file(file_prefixes, text, -1)

	switch(arg_type[0])
	{
		case 'f':
		{
			TrieSetString(pre_flags_collect, arg_key, arg_prefix)
		}
		case 'i':
		{
			TrieSetString(pre_ips_collect, arg_key, arg_prefix)
		}
		case 's':
		{
			TrieSetString(pre_steamids_collect, arg_key, arg_prefix)
		}
		case 'n':
		{
			TrieSetString(pre_names_collect, arg_key, arg_prefix)
		}
	}

	if(target)
	{
		num_to_str(target, str_id, charsmax(str_id))
		TrieSetString(client_prefix, str_id, arg_prefix)
	}

	console_print(id, "%L", LANG_SERVER, "CUSTOM_CHANGE", in_prefix, temp_str, arg_key, arg_prefix)
	server_print("%L", LANG_SERVER, "CUSTOM_CHANGE_INFO", in_prefix, g_name, temp_str, arg_key, arg_prefix) 

	return PLUGIN_HANDLED
}

public client_infochanged(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE

	new g_old_name[32];

	get_user_info(id, "name", g_name, charsmax(g_name))
	get_user_name(id, g_old_name, charsmax(g_old_name))

	if(!equal(g_name, g_old_name))
	{
		num_to_str(id, str_id, charsmax(str_id))
		TrieSetString(client_prefix, str_id, "")
		set_task(0.5, "PutPrefix", id)
		return PLUGIN_HANDLED
	}

	return PLUGIN_CONTINUE
}

public PutPrefix(id)
{
	num_to_str(id, str_id, charsmax(str_id))
	TrieSetString(client_prefix, str_id, "")

	new sflags[32], temp_flag[2];
	get_flags(get_user_flags(id), sflags, charsmax(sflags))

	for(new i = 0; i <= charsmax(sflags); i++)
	{
		formatex(temp_flag, charsmax(temp_flag), "%c", sflags[i])

		if(TrieGetString(pre_flags_collect, temp_flag, temp_prefix, charsmax(temp_prefix)))
		{
			TrieSetString(client_prefix, str_id, temp_prefix)
		}
	}

	get_user_ip(id, temp_key, charsmax(temp_key), 1)

	if(TrieGetString(pre_ips_collect, temp_key, temp_prefix, charsmax(temp_prefix)))
	{
		TrieSetString(client_prefix, str_id, temp_prefix)
	}

	get_user_authid(id, temp_key, charsmax(temp_key))

	if(TrieGetString(pre_steamids_collect, temp_key, temp_prefix, charsmax(temp_prefix)))
	{
		TrieSetString(client_prefix, str_id, temp_prefix)
	}

	get_user_name(id, temp_key, charsmax(temp_key))

	if(TrieGetString(pre_names_collect, temp_key, temp_prefix, charsmax(temp_prefix)))
	{
		TrieSetString(client_prefix, str_id, temp_prefix)
	}

	return PLUGIN_HANDLED
}

send_message(const message[], const id, const i)
{
	message_begin(MSG_ONE, g_saytxt, {0, 0, 0}, i)
	write_byte(id)
	write_string(message)
	message_end()
}

bool:check_say_characters(const check_message[])
{
	for(new i = 0; i < charsmax(forbidden_say_symbols); i++)
	{
		if(check_message[0] == forbidden_say_symbols[i])
		{
			return true
		}
	}
	return false
}

bool:check_prefix_characters(const check_prefix[])
{
	for(i = 0; i < charsmax(forbidden_prefixes_symbols); i++)
	{
		if(containi(check_prefix, forbidden_prefixes_symbols[i]) != -1)
		{
			return true
		}
	}
	return false
}

bool:is_bad_prefix(const check_prefix[])
{
	if(TrieGetCell(bad_prefixes_collect, check_prefix, temp_value))
	{
		return true
	}
	return false
}

find_and_delete(const arg_type[], const arg_key[])
{
	line = 0, length = 0;

	while(read_file(file_prefixes, line++ , text, charsmax(text), length))
	{
		if(!text[0] || text[0] == '^n' || text[0] == ';' || (text[0] == '/' && text[1] == '/'))
			continue

		parse(text, type, charsmax(type), key, charsmax(key), prefix, charsmax(prefix))
		trim(prefix)

		if(!type[0] || !prefix[0] || !key[0])
			continue
			
		if(!equal(arg_type, type) || !equal(arg_key, key))
			continue
			
		write_file(file_prefixes, "", line - 1)
	}
	
	switch(arg_type[0])
	{
		case 'f':
		{
			TrieDeleteKey(pre_flags_collect, arg_key)
		}
		case 'i':
		{
			TrieDeleteKey(pre_ips_collect, arg_key)
		}
		case 's':
		{
			TrieDeleteKey(pre_steamids_collect, arg_key)
		}
		case 'n':
		{
			TrieDeleteKey(pre_names_collect, arg_key)
		}
	}
}


stock ColorChat(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	replace_all(msg, 190, "!g", "^4")
	replace_all(msg, 190, "!y", "^3")
	replace_all(msg, 190, "!team", "^1")
	
	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
				write_byte(players[i]);
				write_string(msg); 
				message_end();
			}
		}
	}
}


stock GetPlayersNum(CsTeams:iTeam) {
	new iNum
	for( new i = 1; i <= get_maxplayers(); i++ ) {
		if(is_user_connected(i) && is_user_alive(i) && cs_get_user_team(i) == iTeam)
			iNum++
	}
	return iNum
}
