/* Dokulari tanimli olan haritalar ( Dokulari kendinize gore ayarlayip bu kisimlari silin)
DE_CSGO_DUST
DE_CSGO_DUST2
DE_CSGO_DUST2_WINTER
CSGO_DUST2_NIGHT
DE_CSGO_INFERNO
DE_CSGO_NUKE
DE_GO_TRAIN
DE_CSGO_CACHE
DE_CSGO_CBBLE
DE_GO_MIRAGE
DE_CSGO_OVERPASS
de_GO_MirageWinter
CSGO_OFFICE_NIGHT
css_kabul2*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <fakemeta>
#include <fakemeta_const>
#include <cstrike>
#include <engine>

#define PLUGIN "footstep"
#define VERSION "1.0"
#define AUTHOR "The Professional & MSS &  & Y'ekta"

//#define IsOnLadder(%1) (pev(%1, pev_movetype) == MOVETYPE_FLY)

// Butun zaman birimleri saniye cinsindendir

const numSounds = 4 // Kac ses var? Default 4

const Float:soundDelay = 0.35 //Ayak sesleri arasindaki sure

const Float:lowestSpeed = 150.0 // Ses cikarmak icin gerekli en dusuk hiz

const Float:soundAtt = 1.5 // Ses ne kadar uzaktan duyulacak (ne kadar az o kadar uzaktan duyulur, 0-2 arasi)

const Float:soundVol = 0.8 // Ses siddeti (0-1 arasi)

const pathLength = 128

new randSoundPrev[33]

new Float:userTicks[33]

new fsSounds[numSounds][pathLength] = {
	"csgo_footstep3/normal1.wav",
	"csgo_footstep3/normal2.wav",
	"csgo_footstep3/normal3.wav",
"csgo_footstep3/normal4.wav"}

new fsSounds2[numSounds][pathLength] = {
	"csgo_footstep3/toprak1.wav",
	"csgo_footstep3/toprak2.wav",
	"csgo_footstep3/toprak3.wav",
"csgo_footstep3/toprak4.wav"}

new fsSounds3[numSounds][pathLength] = {
	"csgo_footstep3/cimen1.wav",
	"csgo_footstep3/cimen2.wav",
	"csgo_footstep3/cimen3.wav",
"csgo_footstep3/cimen4.wav"}

new fsSounds4[numSounds][pathLength] = {
	"csgo_footstep3/fayans1.wav",
	"csgo_footstep3/fayans2.wav",
	"csgo_footstep3/fayans3.wav",
"csgo_footstep3/fayans4.wav"}

new fsSounds5[numSounds][pathLength] = {
	"csgo_footstep3/tahta1.wav",
	"csgo_footstep3/tahta2.wav",
	"csgo_footstep3/tahta3.wav",
"csgo_footstep3/tahta4.wav"}

new fsSounds6[numSounds][pathLength] = {
	"csgo_footstep3/metal1.wav",
	"csgo_footstep3/metal2.wav",
	"csgo_footstep3/metal3.wav",
"csgo_footstep3/metal4.wav"}

new fsSounds7[numSounds][pathLength] = {
	"csgo_footstep3/kar1.wav",
	"csgo_footstep3/kar2.wav",
	"csgo_footstep3/kar3.wav",
"csgo_footstep3/kar4.wav"}

new fsSounds8[numSounds][pathLength] = {
	"csgo_footstep3/havalandirma1.wav",
	"csgo_footstep3/havalandirma2.wav",
	"csgo_footstep3/havalandirma3.wav",
"csgo_footstep3/havalandirma4.wav"}

new const g_normal[][] =
{
"d2temp14",
"d2bw8",
"d2bw5",
"d2rock1",
"d2stone3",
"d2stone2",
"d2residwa6",
"base_mid_v1",
"stonestep02",
"stonestep01",
"concext07",
"prodflra",
"babtech_dr1c",
"d2bw29",
"brick_ext04",
"concretef04",
"ground_tiled",
"ground_tilef",
"out_pave1",
"train_cement_fl",
"train_cement_s1",
"train_cement_s2",
"concext07",
"nukroofa",
"nukfloora",
"cemen",
"base_top_v1",
"plaster_brick4",
"goa11",
"marble_01",
"market128",
"tile_ver4",
"gob6",
"nukmetalwallp",
"ground_tilec",
"ground_tileh",
"groundsand",
"cstones_2",
"infflrd2",
"frontstone31d",
"frontstone11b",
"wallinter1",
"eground1",
"cfloor01",
"cfloor02",
"tela01",
"curba",
"csgodust6",
"csgodust30",
"csgodust154",
"bank",
"stoneblocks2t",
"stoneblock01a",
"csgodust9",
"csgodust150",
"csgodust8",
"csgodust9",
"csgodust31",
"inf5",
"inf13",
"inf86",
"inf49",
"bombsite_x",
"inf2",
"de_mground01",
"de_mground02",
"dust0_block_01",
"de_mwall16",
"de_mfence01",
"de_mground07",
"de_mwall33",
"dust0_wall_21",
"de_mground03",
"nowallshot",
"NoTexture",
"topext03b",
"topext04",
"roadstone1",
"cobble01a",
"infbaseb1",
"bmbs12",
"silo2_wet6",
"dbags2",
"hr_conc_i",
"sairs_04_color",
"hr_sidewalk_c",
"hr_sidewalk_a",
"hr_trim_a",
"hr_conc_idark",
"hr_conc_d2",
"hr_conc_g",
"hr_conc_stairs2",
"tiles_e",
"concretefloor02",
"infgrnd1",
"infdirt01",
"infbnnsteps",
"costone1-256",
"concext07a1",
"nukegrnd",
"bdngtop",
"hrcp001",
"hrcp002",
"inf2",
"pntflr01",
"inf2",
"stair001",
"conc001",
"curb001",
"asphalt01",
"hrcw006",
"barricade01",
"trimtop",
"tiretp",
"hrcw001",
"d2dirt5",
"d2dirt5b",
"d2xvsite",
"mat39",
"mat5",
"mat43",
"mat8",
"mat49",
"mat18",
"grndsandrd",
"concsnwblend",
"mat24",
"fcabsd",
"mat156",
"mat188",
"sandbags",
"pavement001",
"pavement001a",
"rescuezcsa",
"concratewall2",
"trash13",
"cr1u",
"trash15",
"groundsand03",
"groundsand03sfn",
"groundsand03str",
"siteBwall01",
"siteBwall03b",
"residBwall03",
"residBwall06",
"stonestep04",
"groundsandxway"
}

new const g_toprak[][] =
{
"d2dirt4",
"d2dirt7",
"d2dirt5c",
"d2xysite",
"d2crate14",
"go_dustfloor2",
"costone1b",
"costone1d",
"costone1c",
"csstfloor5",
"grass03c",
"nature_dirt",
"dustgrndsand",
"dustconcgrnd",
"dusttilegrnd",
"bombstA",
"nukfloorc",
"de_mground08",
"pve11p_wall17",
"stonext01",
"roadgrass1",
"ext12",
"proddirta",
"debree01",
"roadgrass3",
"plantbedlong",
"plantbedcurve",
"plantbedH",
"vietnam_mud",
"csstfloor6b",
"trash17",
"trash12",
"csstfloor7b",
"csstfloor7",
"trash11"

}


new const g_cimen[][] =
{
"c_grass3",
"paiz",
"grass03",
"redcouch",
"hay",
"infplntbed",
"cementtp",
"inf17",
"rats_table01",
"grass00",
"trashb",
"roadgrass4",
"canapea_matrl",
"prefab_pot1",
"hr_trashcard",
"sofa",
"sofa2"
}

new const g_fayans[][] =
{
"d2temp15",
"nukfloorb",
"lab1_bluxflr1b",
"cuiflre",
"stonefloor3",
"cxmarblee",
"pi_floorst5",
"cstones_1",
"outwall2",
"concext14",
"ctilefloor01",
"pi_floorst1g",
"csgodust115",
"csgodust117",
"znow1",
"fifties_tbl1",
"inf106",
"inf33",
"inf44",
"inf29",
"de_mground04",
"de_mground06",
"de_mground05",
"de_mground09",
"de_mground10",
"rats_tile04",
"csstfloor1",
"cocnfloor02",
"concrete02_",
"floor06",
"concext01",
"concwall011cj",
"conwall07a",
"ext14b",
"asphalt_b2",
"asphalt_b1",
"cuiflrc",
"carpet004",
"hr_conc_f2dark",
"tiles_c_dirty",
"rubber_floor_th",
"hrft001",
"hrft002",
"flrtrim01",
"platformdn",
"+0~watergrid",
"walltop",
"d2floor1",
"tilesnwrd",
"mat125",
"mat128",
"mat131",
"trash5",
"concratefloor",
"trash7",
"trash6",
"lab1_bluxflr1",
"blue_small",
"yellow_small",
"red_small",
"white_small",
"purple_small",
"tilefloor01",
"tilefloor02",
"dusandcrete",
"tilefloor01-x"

}

new const g_tahta[][] =
{
"d2crate12",
"d2crate9",
"d2crate8b",
"d2crate17",
"d2crate18",
"d2crate21",
"go_crate64",
"ammo1",
"flatbed_top",
"cardbox1",
"babtech_wall03",
"generic102b",
"d2wood5",
"wdcrate4",
"woodfloor07a",
"woodext01",
"woodcrat1",
"woodtext01",
"cutie1b",
"wdcrate",
"wdcrate2",
"roofblue3",
"woobeamt01",
"plywood",
"cr2u",
"ccrate_64",
"boxwall01",
"csgodust2",
"generic039",
"dustcrt64tp",
"dustcrtwd",
"csgodust105",
"dustcrt32sd",
"dustcrt32ft",
"csgodust114",
"csgodust54",
"scaffoldlog_tex",
"aidcrttp",
"foodcratest",
"ducrtwd2",
"pallettop",
"frk_m2wood01",
"frk_dwood01",
"d2wood4",
"woodsteps001",
"d2wood6",
"d2wood2",
"d2wood1",
"woodfloor05a",
"inf105",
"inf1",
"inf11",
"inf3",
"inf6",
"inf115",
"inf6",
"de_mwall45",
"de_mbox02",
"de_mwood01",
"dark_wood_02",
"miwoodm",
"dust0_Box_01",
"pi_barrelt",
"bencht",
"plywoodext01",
"vertigo_plywood",
"plywood02",
"dcrate2",
"wood_plank_a",
"yellow_wood",
"plywood02",
"wood",
"ducrt64x64snw",
"ducrt64x64",
"offbox01",
"cafetable",
"fifties_dr6a",
"out_wall10",
"woodcssd2",
"vietnam_crate",
"s_generic3",
"infwood2",
"picrate1",
"picrate3",
"dcrate02"
}

new const g_metal[][] =
{
"capbut2",
"capbut01",
"d2crate4",
"d2contnr",
"nukmetalblu2",
"duckflr01a",
"c2a3turbine3",
"metalwall014a",
"{gratestep2",
"{gratestep3",
"mtc2_red",
"mtc3_red",
"nukmetalwallj",
"nukmetalwallh",
"nukmetalwallg",
"nukmetalwallb",
"roofnuclear",
"mtc4",
"mtc1",
"mcc4",
"duct_flr01a",
"drkmtlt_bord11",
"trrm_pan6",
"generic015h",
"generic015v",
"nukroof01",
"go_residwall04",
"nuke_ceiling_02",
"dvan3",
"ibeama",
"csstbdr2",
"generic015u",
"ctred02",
"tanks3",
"pwall01w",
"doorbig",
"metalroof05a",
"vertigoibeam",
"inf22",
"bombdrumtp",
"rats_metal02",
"rats_oven03",
"train_cement_st",
"train_cementwea",
"obarrel2",
"barreltp",
"contain3",
"drainage_floor2",
"{rails_trn",
"metal_floor_a",
"go_train9",
"go_train6",
"go_train3",
"go_train15",
"go_train18",
"signalbox2",
"go_train_flat3",
"go_train_flat",
"go_train_flat2",
"asphalt+b",
"metalroof",
"train_flame",
"i_beam_b",
"nuclear_cont_c",
"nuke_floor_trim",
"crtmed2tp",
"platformy",
"hrmf001",
"labhzrdtrim",
"crtsmltp",
"crate_02_up",
"flrxttk",
"metalplatform02",
"metalplatformbs",
"aSiteXPlat",
"{metalsteps",
"+0acfan_bld",
"crtmed03tp",
"lrgcrttp",
"lrgcrt2tp",
"ac01sd",
"rollertop",
"truck_bed",
"truck_bk",
"crate01_up",
"crtssmltop",
"silo2_c1c",
"btarg_wlltp",
"metaltrimbt",
"cplbtns",
"cplmon",
"platformx",
"cranesteps",
"mat25",
"out_dmplid",
"kitchentop",
"metalroofred",
"metalcrate001a",
"metalcrate001c_",
"csstmetalc",
"c2a3turbine3",
"out_dmp2c",
"stripes5",
"out_galv1",
"introdr1e"


}

new const g_kar[][] =
{
"snow",
"snowA",
"snowB",
"mat51",
"xx-b",
"xx-a",
"awning"

}

new const g_havalandirma[][] =
{
"crwlspc",
"rooftopobj2",
"metal01",
"duct_flr01"
}

public plugin_init() {
register_plugin(PLUGIN, VERSION, AUTHOR)

}

public ayak_sesi(id, ses_turu)
{
	new randSound
	do
	{
		randSound = random_num(0, numSounds - 1)
	} while (randSoundPrev[id] == randSound)
	randSoundPrev[id] = randSound
	//randSound = random_num(0, numSounds - 1)
	switch (ses_turu)
	{
		case 1:emit_sound(id, CHAN_BODY, fsSounds[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 2:emit_sound(id, CHAN_BODY, fsSounds2[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 3:emit_sound(id, CHAN_BODY, fsSounds3[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 4:emit_sound(id, CHAN_BODY, fsSounds4[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 5:emit_sound(id, CHAN_BODY, fsSounds5[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 6:emit_sound(id, CHAN_BODY, fsSounds6[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 7:emit_sound(id, CHAN_BODY, fsSounds7[randSound], soundVol, soundAtt, 0, PITCH_NORM)
		case 8:emit_sound(id, CHAN_BODY, fsSounds8[randSound], soundVol, soundAtt, 0, PITCH_NORM)
	}

}

public client_PreThink( id )
{
	if (!(pev(id, pev_flags) & FL_ONGROUND) || (pev(id, pev_movetype) == MOVETYPE_FLY) || !is_user_alive(id))
	{
		//client_print(id, print_chat, "haha")
		if (get_user_footsteps(id))
			set_user_footsteps(id, 0)
		return PLUGIN_CONTINUE
	}
	else
		if (!get_user_footsteps(id))
			set_user_footsteps(id, 1)
		
	new Float:vel[3]
	new Float:velR
	
	pev(id, pev_velocity, vel)
	velR = vector_length(vel)
	if (velR < lowestSpeed)
		return PLUGIN_CONTINUE
		
		
	if (get_gametime() - userTicks[id] >= soundDelay)
		userTicks[id] = get_gametime()
	else
		return PLUGIN_CONTINUE

	static Float:start[3]
	pev(id, pev_origin, start)

	static Float:dest[3]
	dest[0] = start[0]
	dest[1] = start[1]
	dest[2] = -8191.0

	new tr
	engfunc(EngFunc_TraceLine, start, dest, 0, id, tr)

	static texent
	texent = get_tr2(tr, TR_pHit)
	if (texent == -1)
		texent = 0
	else if (is_user_alive(texent))
		return PLUGIN_CONTINUE

	static texname[16]
	engfunc(EngFunc_TraceTexture, texent, start, dest, texname, 15)

	static textype[2]
	textype[0] = dllfunc(DLLFunc_PM_FindTextureType, texname)

	//server_print("TexEnt[%d] TexName[%s] TexType[%s]", texent, texname, textype)
	new texfound = 0
	for(new i=0;i< sizeof(g_normal);i++)
	{
		if(equal(texname, g_normal[i]))
		{
			//normal(id)
			ayak_sesi(id, 1)
			texfound = 1
			break
			//client_print(id, print_chat, "NORMAL");
		}
	}
	if (!texfound)
	for(new i=0;i< sizeof(g_toprak);i++)
	{
		if(equal(texname, g_toprak[i]))
		{
			//toprak(id)
			ayak_sesi(id, 2)
			texfound = 1
			break
			//client_print(id, print_chat, "TOPRAK");
		}
	}
	if (!texfound)
	for(new i=0;i< sizeof(g_cimen);i++)
	{
		if(equal(texname, g_cimen[i]))
		{
			//cimen(id)
			ayak_sesi(id, 3)
			texfound = 1
			break
			//client_print(id, print_chat, "CIMEN");
		}
	}
	if (!texfound)
	for(new i=0;i< sizeof(g_fayans);i++)
	{
		if(equal(texname, g_fayans[i]))
		{
			//fayans(id)
			ayak_sesi(id, 4)
			texfound = 1
			break
			//client_print(id, print_chat, "FAYANS");
		}
	}
	if (!texfound)
		for(new i=0;i< sizeof(g_tahta);i++)
	{
		if(equal(texname, g_tahta[i]))
		{
			//tahta(id)
			ayak_sesi(id, 5)
			texfound = 1
			break
			//client_print(id, print_chat, "TAHTA");
		}
	}
	if (!texfound)
		for(new i=0;i< sizeof(g_metal);i++)
	{
		if(equal(texname, g_metal[i]))
		{
			//metal(id)
			ayak_sesi(id, 6)
			texfound = 1
			break
			//client_print(id, print_chat, "METAL");
		}
	}
	if (!texfound)
		for(new i=0;i< sizeof(g_kar);i++)
	{
		if(equal(texname, g_kar[i]))
		{
			//kar(id)
			ayak_sesi(id, 7)
			texfound = 1
			break
			//client_print(id, print_chat, "KAR");
		}
	}
	if (!texfound)
		for(new i=0;i< sizeof(g_havalandirma);i++)
	{
		if(equal(texname, g_havalandirma[i]))
		{
			//havalandirma(id)
			ayak_sesi(id, 8)
			texfound = 1
			break
			//client_print(id, print_chat, "HAVALANDIRMA");
		}
	}
	return PLUGIN_CONTINUE
}


public plugin_precache() {
	
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds2[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds3[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds4[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds5[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds6[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds7[i])
	for (new i = 0; i < numSounds; i++)
		precache_sound(fsSounds8[i])
}