#include <amxmodx>
#include <amxmisc>
#include <reapi>
#include <fakemeta>
#include <hamsandwich>
#include <xs>
#include <nvault>

#pragma semicolon 1
#pragma compress 1

new const PLUGIN[] = "CS:Global Offensive";
new const VERSION[] = "V4";
new const AUTHOR[] = "deciduous";

#define IDLE_ANIM 0
#define KNIFE_STABMISS 5
#define GLOCK18_SHOOT3 5
#define AK47_SHOOT1 3
#define AUG_SHOOT1 3
#define AWP_SHOOT2 2
#define DEAGLE_SHOOT1 2
#define ELITE_SHOOTLEFT5 6
#define ELITE_SHOOTRIGHT5 12
#define CLARION_SHOOT2 4
#define FIVESEVEN_SHOOT1 1
#define GALIL_SHOOT3 5
#define M3_FIRE2 2
#define M4A1_SHOOT3 3
#define M4A1_UNSIL_SHOOT3 10
#define M249_SHOOT2 2
#define MAC10_SHOOT1 3
#define MP5N_SHOOT1 3
#define P90_SHOOT1 3
#define P228_SHOOT2 2
#define SCOUT_SHOOT 1
#define SG552_SHOOT2 4
#define TMP_SHOOT3 5
#define UMP45_SHOOT2 4
#define USP_SHOOT3 3

//Macros
//#define WEAPON_ENT(%0) (get_member(%0, m_iId))
#define CLIENT_DATA(%0,%1,%2) (get_user_info(%0, %1, %2, charsmax(%2)))
#define HOOK_DATA(%0,%1,%2) (set_user_info(%0, %1, %2))

new Ses[][] = 
{ 
	"ak47-1", // 0
	"ak47-2", // 1
	"aug-1", // 2 
	"aug-2", // 3 
	"awp1", // 4
	"awp2", // 5
	"deagle-1", // 6
	"deagle-2", // 7
	"elite_fire", // 8
	"famas-1", // 9
	"famas-2", // 10
	"fiveseven-1", // 11
	"fiveseven-2", // 12
	"g3sg1-1", // 13
	"galil-1", // 14
	"galil-2", // 15
	"glock18-1", // 16
	"glock18-2", // 17
	"knife_hit1", // 18
	"knife_hit2", // 19
	"knife_hit3", // 20
	"knife_hit4", // 21
	"knife_hitwall1", // 22
	"knife_hitwall2", // 23
	"knife_hitwall3", // 24
	"knife_hitwall4", // 25
	"knife_hitwall5", // 26
	"knife_slash1", // 27
	"knife_slash2", // 28
	"knife_stab", // 29
	"knife_deploy1", // 30
	"m3-1", // 31
	"m3-2", // 32
	"m4a1_unsil-1", // 33
	"m4a1_unsil-2", // 34
	"m4a1-1", // 35
	"m4a1-2", // 36
	"m249-1", // 37
	"m249-2", // 38
	"mac10-1", // 39
	"mp5-1", // 40
	"p90-1", // 41
	"p90-2", // 42
	"p228-1", // 43
	"p228-2", // 44
	"scout_fire-1", // 45
	"scout_fire-2", // 46
	"sg550-1", // 47
	"sg552-1", // 48
	"sg552-2", // 49
	"tmp-1", // 50
	"tmp-2", // 51
	"ump45-1", // 52
	"usp_unsil-1", // 53
	"usp_unsil-2", // 54
	"usp1", // 55
	"usp2", // 56
	"xm1014-1", // 57
	"xm1014-2", // 58
	"bhit_flesh-1", // 59
	"bhit_flesh-2", // 60
	"bhit_flesh-3", // 61
	"bhit_helmet-1", // 62
	"bhit_kevlar-1", // 63
	"death6", // 64
	"die1", // 65
	"die2", // 66
	"die3", // 67
	"headshot1", // 68
	"headshot2", // 69
	"headshot3", // 70
	"pl_die1", // 71
	"pl_dirt1", // 72
	"pl_dirt2", // 73
	"pl_dirt3", // 74
	"pl_dirt4", // 75
	"pl_duct1", // 76
	"pl_duct2", // 77
	"pl_duct3", // 78
	"pl_duct4", // 79
	"pl_fallpain1", // 80
	"pl_fallpain2", // 81
	"pl_fallpain3", // 82
	"pl_grate1", // 83
	"pl_grate2", // 84
	"pl_grate3", // 85
	"pl_grate4", // 86
	"pl_jump1", // 87
	"pl_jump2", // 88
	"pl_ladder1", // 89
	"pl_ladder2", // 90
	"pl_ladder3", // 91
	"pl_ladder4", // 92
	"pl_metal1", // 93
	"pl_metal2", // 94
	"pl_metal3", // 95
	"pl_metal4", // 96
	"pl_pain2", // 97
	"pl_pain4", // 98
	"pl_pain5", // 99
	"pl_pain6", // 100
	"pl_pain7", // 101
	"pl_shell2", // 102
	"pl_shot1", // 103
	"pl_slosh1", // 104
	"pl_slosh2", // 105
	"pl_slosh3", // 106
	"pl_slosh4", // 107
	"pl_snow1", // 108
	"pl_snow2", // 109
	"pl_snow3", // 110
	"pl_snow4", // 111
	"pl_snow5", // 112
	"pl_snow6", // 113
	"pl_step1", // 114
	"pl_step2", // 115
	"pl_step3", // 116
	"pl_step4", // 117
	"pl_swim1", // 118
	"pl_swim2", // 119
	"pl_swim3", // 120
	"pl_swim4", // 121
	"pl_tile1", // 122
	"pl_tile2", // 123
	"pl_tile3", // 124
	"pl_tile4", // 125
	"pl_tile5", // 126
	"pl_wade1", // 127
	"pl_wade2", // 128
	"pl_wade3", // 129
	"pl_wade4", // 130
	"sprayer", // 131
	"pl_wood1", // 132
	"pl_wood2", // 133
	"pl_wood3", // 134
	"pl_wood4", // 135
	"pl_grass1", // 136
	"pl_grass2", // 137
	"pl_grass3", // 138
	"pl_grass4", // 139
	"pl_gravel1", // 140
	"pl_gravel2", // 141
	"pl_gravel3", // 142
	"pl_gravel4", // 143
	"he_bounce-1", // 144
	"grenade_hit1", // 145
	"grenade_hit2", // 146
	"grenade_hit3", // 147
	"sg_explode", // 148
	"explode3", // 149
	"explode4", // 150
	"explode5", // 151
	"flashbang-1", // 152
	"flashbang-2", // 153
	"c4_beep1", // 154
	"c4_beep2", // 155
	"c4_beep3", // 156
	"c4_beep4", // 157
	"c4_beep5" // 158
};

new const WEAPONS_SHOOT_SOUND[][] = {
	"weapons/csgo_shoot/glock18-1.wav", // 0
	"weapons/csgo_shoot/ak47-1.wav", // 1
	"weapons/csgo_shoot/aug-1.wav", // 2
	"weapons/csgo_shoot/awp-1.wav", // 3
	"weapons/csgo_shoot/deagle-1.wav", // 4
	"weapons/csgo_shoot/elite-1.wav", // 5
	"weapons/csgo_shoot/famas-1.wav", // 6
	"weapons/csgo_shoot/fiveseven-1.wav", // 7
	"weapons/csgo_shoot/galil-1.wav", // 8
	"weapons/csgo_shoot/m3-1.wav", // 9
	"weapons/csgo_shoot/m249-1.wav", // 10
	"weapons/csgo_shoot/mac10-1.wav", // 11
	"weapons/csgo_shoot/mp5-1.wav", // 12
	"weapons/csgo_shoot/p90-1.wav", // 13
	"weapons/csgo_shoot/tec9-1.wav", // 14
	"weapons/csgo_shoot/scout-1.wav", // 15
	"weapons/csgo_shoot/sg552-1.wav", // 16
	"weapons/csgo_shoot/tmp-1.wav", // 17
	"weapons/csgo_shoot/ump45-1.wav", // 18
	"weapons/csgo_shoot/m4a1-1.wav", // 19 slient
	"weapons/csgo_shoot/m4a4-1.wav", // 20 normal
	"weapons/csgo_shoot/usp-1.wav" // 21
};

new DISTANT[21][] = {
	"glock18-distant", // 0
	"ak47-distant", // 1
	"aug-distant", // 2
	"awp_distant_yn", // 3
	"deagle-distant", // 4
	"elite-distant", // 5
	"famas-distant", // 6
	"fvsvn-distant", // 7
	"galil-distant", // 8
	"m3-distant", // 9
	"m249-1-distant", // 10
	"mac10-1-distant", // 11
	"mp5-distant", // 12
	"p90-distant", // 13
	"p228_distant", // 14
	"scout-distant", // 15
	"sg552-distant", // 16
	"hkp2000-1-distant", // 17
	"ump45-distant", // 18
	"m4a1-distant", // 19
	"usp_distant", // 20
};

new const WeaponNames[][] = { "weapon_knife", "weapon_glock18", "weapon_ak47", "weapon_aug", "weapon_awp", "weapon_c4", "weapon_deagle", "weapon_elite", "weapon_famas", 
	"weapon_fiveseven", "weapon_flashbang", "weapon_g3sg1", "weapon_galil", "weapon_hegrenade", "weapon_m3", "weapon_xm1014", "weapon_m4a1", "weapon_m249", "weapon_mac10", 
	"weapon_mp5navy", "weapon_p90", "weapon_p228", "weapon_scout", "weapon_sg550", "weapon_sg552", "weapon_smokegrenade", "weapon_tmp", "weapon_ump45", "weapon_usp" };

//Old models to unprecache
new const g_OldModels[][] = { "models/v_knife.mdl", "models/v_glock18.mdl", "models/v_ak47.mdl", "models/v_aug.mdl", "models/v_awp.mdl", "models/v_c4.mdl" , "models/v_deagle.mdl", 
	"models/v_elite.mdl", "models/v_famas.mdl", "models/v_fiveseven.mdl", "models/v_flashbang.mdl", "models/v_g3sg1.mdl", "models/v_galil.mdl", "models/v_hegrenade.mdl", 
	"models/v_m3.mdl", "models/v_xm1014.mdl", "models/v_m4a1.mdl", "models/v_m249.mdl", "models/v_mac10.mdl", "models/v_mp5.mdl", "models/v_p90.mdl", "models/v_p228.mdl", 
	"models/v_scout.mdl", "models/v_sg550.mdl", "models/v_sg552.mdl", "models/v_smokegrenade.mdl", "models/v_tmp.mdl", "models/v_ump45.mdl", "models/v_usp.mdl" };

//enum WeaponIdType ile sıralandı
new const g_NewModels[][] = { 
	"", // 0 						WEAPON_NONE
	"models/csgonew4/v_tec9.mdl", // 1 						WEAPON_P228
	"", // 2 						WEAPON_GLOCK
	"models/csgonew4/v_scout_v4.mdl", // 3 					WEAPON_SCOUT
	"models/csgonew4/v_hegrenade_v4.mdl", // 4 				WEAPON_HEGRENADE
	"", // 5						WEAPON_XM1014
	"models/csgonew4/v_c4_v4.mdl" , // 6						WEAPON_C4
	"models/csgonew4/v_mac10_v4.mdl", // 7						WEAPON_MAC10
	"models/csgonew4/v_aug_v4.mdl", // 8						WEAPON_AUG
	"models/csgonew4/v_smokegrenade_v4.mdl", // 9				WEAPON_SMOKEGRENADE
	"models/csgonew4/v_elite_v4.mdl", // 10	WEAPON_ELITE
	"models/csgonew4/v_fiveseven_v4.mdl", // 11				WEAPON_FIVESEVEN
	"models/csgonew4/v_ump45_v4.mdl", // 12					WEAPON_UMP45
	"", // 13						WEAPON_SG550
	"models/csgonew4/v_galil_v4.mdl", // 14					WEAPON_GALIL
	"models/csgonew4/v_famas_v4.mdl", // 15					WEAPON_FAMAS
	"models/csgonew4/v_usp_v4.mdl", // 16					WEAPON_USP
	"models/csgonew4/v_glock18_v4.mdl", // 17				WEAPON_GLOCK18
	"models/csgonew4/v_awp_v5.mdl",  // 18					WEAPON_AWP
	"models/csgonew4/v_mp5navy_v4.mdl", // 19				WEAPON_MP5N
	"models/csgonew4/v_m249_v5.mdl", // 20			WEAPON_M249
	"models/csgonew4/v_m3_v4.mdl", // 21			WEAPON_M3
	"", // 22						WEAPON_M4A1
	"models/csgonew4/v_tmp_v4.mdl", // 23					WEAPON_TMP
	"", // 24						WEAPON_G3SG1
	"models/csgonew4/v_flashbang_v4.mdl", // 25				WEAPON_FLASHBANG
	"models/csgonew4/v_deagle_v4.mdl", // 26					WEAPON_DEAGLE
	"models/csgonew4/v_sg552_v4.mdl", // 27			WEAPON_SG552
	"models/csgonew4/v_ak47_v4.mdl", // 28					WEAPON_AK47
	"", // 29						WEAPON_KNIFE
	"models/csgonew4/v_p90_v4.mdl", // 30					WEAPON_P90
	"" // 31						WEAPON_SHIELDGUN
};

new const g_KnifeModels[][] = 
{
	"models/csgonew4/v_knife_v4.mdl",
	"models/csgonew4/v_knife_bayonet_v4.mdl",
	"models/csgonew4/v_knife_bowie_v4.mdl",
	"models/csgonew4/v_knife_butterfly_v4.mdl",
	"models/csgonew4/v_knife_flip_v4.mdl",
	"models/csgonew4/v_knife_karambit_v4.mdl",
	"models/csgonew4/v_knife_m9_bayonet_v4.mdl",
	"models/csgonew4/v_knife_talon_v4.mdl",
	"models/csgonew4/v_knife_stiletto_v4.mdl",
	"models/csgonew4/v_knife_paracord_v4.mdl"
};

new const g_M4Models[][] = 
{
	"models/csgonew4/v_m4a1_v4.mdl",
	"models/csgonew4/v_m4a4_v6.mdl"
};

new const SOUNDS2[][] = {
	"csgonew4/flashbang-1.wav", // 0
	"csgonew4/bhit_helmet-1.wav", // 1
	"csgonew4/headshot3_new.wav" // 2
};

new const YENISESLER[][] = {
	"csgonew4/bhit_flesh-1.wav", // 0
	"csgonew4/bhit_flesh-2.wav", // 1
	"csgonew4/bhit_flesh-2.wav", // 2

	"csgonew4/bhit_kevlar-1.wav", // 3
	"csgonew4/ammopickup2.wav", // 4
	"csgonew4/he_bounce-1.wav", // 5
	"csgonew4/c4_disarm.wav", // 6
	"csgonew4/c4_disarm.wav", // 7
	"weapons/silahseslerinew3/knife_deploy1.wav", // 8

	"weapons/silahseslerinew3/c4_beep1.wav", // 9
	"weapons/silahseslerinew3/c4_beep2.wav", // 10
	"weapons/silahseslerinew3/c4_beep3.wav", // 11
	"weapons/silahseslerinew3/c4_beep4.wav", // 12
	"weapons/silahseslerinew3/c4_beep5.wav", // 13

	"csgonew4/smoke_explode.wav", // 14 
	"csgonew4/flashbang_explode.wav", // 15
	"csgonew4/flashbang_explode.wav" // 16
};

new const ESKISESLER[][] = {
	"player/bhit_flesh-1.wav", // 0
	"player/bhit_flesh-2.wav", // 1
	"player/bhit_flesh-3.wav", // 2

	"player/bhit_kevlar-1.wav", // 3
	"items/ammopickup2.wav", // 4
	"weapons/he_bounce-1.wav", // 5
	"weapons/c4_disarm.wav", // 6
	"weapons/c4_disarm.wav", // 7
	"weapons/knife_deploy1.wav", // 8

	"weapons/c4_beep1.wav", // 9
	"weapons/c4_beep2.wav", // 10
	"weapons/c4_beep3.wav", // 11
	"weapons/c4_beep4.wav", // 12
	"weapons/c4_beep5.wav", // 13

	"weapons/sg_explode.wav", // 14
	"weapons/flashbang-1.wav", // 15
	"weapons/flashbang-2.wav" // 16
};

new const stopsound[][] = {
	"csgonew4/arm_bomb.mp3",
	"csgonew4/bombtenseccount.mp3",
	"csgonew4/bombplanted.mp3"
};

/*
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
*/
// Üstte yazan sayılara göre silahlara otomatik rütbe verebilirsin.
// Örnek: Vulcan - 3(bu sayıyı bütün skinlerde değiştirmeyin özelden ulaşın bana) - Buraya yazıcağınız sayıyı seçin örnek: 15. rütbe diyoruz yani  "LEGENDARY EAGLE" yazıyor otomatik.

native get_user_level(id);
native get_rankname(const level, const rankname[], const len);

new const AK47_MenuTitle[][][] =
{
	{ "Default", "0", "0"},
	{ "Neon Revolution", "1", "1"},
	{ "Neva", "2", "2"},
	{ "Wasteland Rebel", "3", "3"},
	{ "The Empress", "4", "4"},
	{ "Fire Serpent", "5", "5"}
};

new const AWP_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Lighting Strike", "1", "1"},
	{ "Assimov", "2", "2"},
	{ "Hyper Beast", "3", "3"},
	{ "Fade", "4", "4"},
	{ "Dragon Lore", "5", "5"}
};

new const DEAGLE_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Crocodilus", "1", "1"},
	{ "Glory", "2", "2"},
	{ "Mountain", "3", "3"},
	{ "Neon Rider", "4", "4"},
	{ "Orochi", "5", "5"}
};

new const GALIL_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Cerbrus", "1", "1"},
	{ "ChatterBox", "2", "2"},
	{ "Octopus", "3", "3"},
	{ "Sirius", "4", "4"},
	{ "Wasteland Rebel", "5", "5"}
};

new const GLOCK_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Assimov", "1", "1"},
	{ "Nordic Hunter", "2", "2"},
	{ "Wasteland Rebel", "3", "3"},
	{ "Water Elemental", "4", "4"},
	{ "Yellow Jungle", "5", "5"}
};

new const M4A1_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Assimov", "1", "1"},
	{ "Black Death", "2", "2"},
	{ "Bush Master", "3", "3"},
	{ "Chaticos Fire", "4", "4"},
	{ "Chicken Revenge", "5", "5"},
	{ "Cod Ghost", "6", "6"},
	{ "Decimator", "7", "7"},
	{ "Haze", "8", "8"},
	{ "Hell Rainbow", "9", "9"},
	{ "Hermeus", "10", "10"}
};

new const M4A4_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Asilime", "1", "1"},
	{ "Asiimow", "2", "2"},
	{ "Hyper Beast", "3", "3"},
	{ "Desolate Space", "4", "4"},
	{ "Dragon King", "5", "5"}
};

new const P90_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Assimov", "1", "1"},
	{ "Catalyst", "2", "2"},
	{ "Death by Kitty", "3", "3"},
	{ "Frontside Misty", "4", "4"},
	{ "Hydro", "5", "5"}
};

new const USP_MenuTitle[][][] = 
{
	{ "Default", "0", "0"},
	{ "Bull Eye", "1", "1"},
	{ "Cyrex", "2", "2"},
	{ "Draco", "3", "3"},
	{ "Kill Confirmed", "4", "4"},
	{ "Neo Noir", "5", "5"}
};

// Classic Knife
new const KNIFE_MenuTitle[][][] =
{
	{ "Default", "0"},
	{ "Crimson Web", "1"},
	{ "Fade", "2"},
	{ "Forest Ddpat", "3"},
	{ "Nigh Stripe", "4"},
	{ "Urban Masked", "5"}
};

new const BAYONET_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Doppler Ruby", "1"},
	{ "Doppler Saphire", "2"},
	{ "Gamma Doppler", "3"},
	{ "Gamma Doppler Emerald", "4"},
	{ "Lore", "5"}
};

new const BOWIE_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Crimson Web", "1"},
	{ "Droppler Black Pearl", "2"},
	{ "Droppler Ruby", "3"},
	{ "Droppler Sapphire", "4"},
	{ "Fade", "5"}
};

new const BUTTERFLY_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Blood", "1"},
	{ "Crimson Web", "2"},
	{ "Marble Fade", "3"},
	{ "Forest Ddpat", "4"},
	{ "Lore", "5"}
};

new const FLIP_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Crimson Web", "1"},
	{ "Doppler Black Pearl", "2"},
	{ "Doppler Green", "3"},
	{ "Doppler Sapphire", "4"},
	{ "Fade", "5"}
};

new const KARAMBIT_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Alien Blood", "1"},
	{ "Black Magic", "2"},
	{ "Couse", "3"},
	{ "Doppler Saphire", "4"},
	{ "Draginix", "5"}
};

new const M9BAYONET_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Crimson Web", "1"},
	{ "Doppler Sapphire", "2"},
	{ "Fade", "3"},
	{ "Gamma Doppler", "4"},
	{ "Lore", "5"}
};

new const TALON_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Droppler", "1"},
	{ "Fade", "2"},
	{ "Galaxy", "3"},
	{ "Marble Fade", "4"},
	{ "Tiger Tooth", "5"}
};

new const STILETTO_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Droppler Ruby", "1"},
	{ "Droppler Sapphire", "2"},
	{ "Gamma Doppler", "3"},
	{ "Ruby", "4"},
	{ "Sapphire", "5"}
};

new const PARACORD_MenuTitle[][][] = 
{
	{ "Default", "0"},
	{ "Case Hardened", "1"},
	{ "Droppler", "2"},
	{ "Scorched", "3"},
	{ "Slaughter", "4"}
};

new TraceBullets[][] = { "func_breakable", "func_wall", "func_door", "func_plat", "func_rotating", "worldspawn", "func_door_rotating" };

new const CSW_SHIELD = 2;

new const Sprites[10][4][64] =
{
	{ "Default - 1", "sprites/crosshair_packnew.spr", "csgo_crosshair_1", "sprites/csgo_crosshair_1.txt" },
	{ "Default - 2", "sprites/crosshair_packnew.spr", "csgo_crosshair_2", "sprites/csgo_crosshair_2.txt" },
	{ "Kalin Yesil Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_9", "sprites/csgo_crosshair_9.txt" },
	{ "Kalin Sari Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_7", "sprites/csgo_crosshair_7.txt" },
	
	{ "Kucuk Mavi Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_12", "sprites/csgo_crosshair_12.txt" },
	{ "Ince Sari Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_11", "sprites/csgo_crosshair_11.txt" },
	{ "Buyuk Mavi Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_8", "sprites/csgo_crosshair_8.txt" },
	{ "Ince Yesil Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_3", "sprites/csgo_crosshair_3.txt" },
	{ "Kalin Yesil Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_5", "sprites/csgo_crosshair_5.txt" },
	{ "Kalin Mavi Crosshair", "sprites/crosshair_packnew.spr", "csgo_crosshair_4", "sprites/csgo_crosshair_4.txt" }
};

new const TERROR_THROWING[][] = {
	"csgonew4/phoenix/throwing_grenade.wav", // 0 - agent 0
	"csgonew4/phoenix/throwing_flashbang.wav", // 1
	"csgonew4/phoenix/throwing_smoke.wav", // 2

	"csgonew4/safecracker/throwing_grenade.wav", // 3 - agent 1
	"csgonew4/safecracker/throwing_flashbang.wav", // 4
	"csgonew4/safecracker/throwing_smoke.wav", // 5

	"csgonew4/bloody_darryl/throwing_grenade.wav", // 6 - agent 2
	"csgonew4/bloody_darryl/throwing_flashbang.wav", // 7
	"csgonew4/bloody_darryl/throwing_smoke.wav" // 8
};

new const CT_THROWING[][] = {
	"csgonew4/gsg9/throwing_grenade.wav", // 0 - agent 0
	"csgonew4/gsg9/throwing_flashbang.wav", // 1
	"csgonew4/gsg9/throwing_smoke.wav", // 2

	"csgonew4/ricksaw/throwing_grenade.wav", // 3 - agent 1
	"csgonew4/ricksaw/throwing_flashbang.wav", // 4
	"csgonew4/ricksaw/throwing_smoke.wav", // 5

	"csgonew4/jamison/throwing_grenade.wav", // 6 - agent 2
	"csgonew4/jamison/throwing_flashbang.wav", // 7
	"csgonew4/jamison/throwing_smoke.wav" // 8
};

new const TERROR_RADIO[][] = {
	"csgonew4/phoenix/hadihadi.wav", // 0 - agent 0
	"csgonew4/phoenix/gericekil.wav", // 1
	"csgonew4/phoenix/guzel.wav",// 2
	"csgonew4/phoenix/olumsuz.wav", // 3
	"csgonew4/phoenix/yardim.wav",// 4
	"csgonew4/phoenix/tesekkur.wav",// 5
	"csgonew4/phoenix/temiz.wav", // 6
	"csgonew4/phoenix/sniper.wav", // 7
	"csgonew4/phoenix/sevinc.wav", // 8

	"csgonew4/safecracker/hadihadi.wav", // 9 - agent 1
	"csgonew4/safecracker/gericekil.wav", // 10
	"csgonew4/safecracker/guzel.wav",// 11
	"csgonew4/safecracker/olumsuz.wav", // 12
	"csgonew4/safecracker/yardim.wav",// 13
	"csgonew4/safecracker/tesekkur.wav",// 14
	"csgonew4/safecracker/temiz.wav", // 15
	"csgonew4/safecracker/sniper.wav", // 16
	"csgonew4/safecracker/sevinc.wav", // 17

	"csgonew4/bloody_darryl/hadihadi.wav", // 18 - agent 2
	"csgonew4/bloody_darryl/gericekil.wav", // 19
	"csgonew4/bloody_darryl/guzel.wav",// 20
	"csgonew4/bloody_darryl/olumsuz.wav", // 21
	"csgonew4/bloody_darryl/yardim.wav",// 22
	"csgonew4/bloody_darryl/tesekkur.wav",// 23
	"csgonew4/bloody_darryl/temiz.wav", // 24
	"csgonew4/bloody_darryl/sniper.wav", // 25
	"csgonew4/bloody_darryl/sevinc.wav" // 26
};

new const CT_RADIO[][] = {
	"csgonew4/gsg9/hadihadi.wav", // 0 - agent 0
	"csgonew4/gsg9/gericekil.wav", // 1
	"csgonew4/gsg9/guzel.wav", // 2
	"csgonew4/gsg9/olumsuz.wav", // 3
	"csgonew4/gsg9/yardim.wav", // 4
	"csgonew4/gsg9/tesekkur.wav", // 5
	"csgonew4/gsg9/temiz.wav", // 6
	"csgonew4/gsg9/sniper.wav", // 7
	"csgonew4/gsg9/sevinc.wav", // 8

	"csgonew4/ricksaw/hadihadi.wav", // 9 - agent 1
	"csgonew4/ricksaw/gericekil.wav", // 10
	"csgonew4/ricksaw/guzel.wav",// 11
	"csgonew4/ricksaw/olumsuz.wav", // 12
	"csgonew4/ricksaw/yardim.wav",// 13
	"csgonew4/ricksaw/tesekkur.wav",// 14
	"csgonew4/ricksaw/temiz.wav", // 15
	"csgonew4/ricksaw/sniper.wav", // 16
	"csgonew4/ricksaw/sevinc.wav", // 17

	"csgonew4/jamison/hadihadi.wav", // 18 - agent 2
	"csgonew4/jamison/gericekil.wav", // 19
	"csgonew4/jamison/guzel.wav",// 20
	"csgonew4/jamison/olumsuz.wav", // 21
	"csgonew4/jamison/yardim.wav",// 22
	"csgonew4/jamison/tesekkur.wav",// 23
	"csgonew4/jamison/temiz.wav", // 24
	"csgonew4/jamison/sniper.wav", // 25
	"csgonew4/jamison/sevinc.wav" // 26
};

new const TERROR_DEATH[][] = {
	"csgonew4/phoenix/death.wav", // 0 - agent 0
	"csgonew4/safecracker/death.wav", // 1 - agent 1
	"csgonew4/bloody_darryl/death.wav" // 2 - agent 2
};

new const CT_DEATH[][] = {
	"csgonew4/gsg9/death.wav", // 0 - agent 0
	"csgonew4/ricksaw/death.wav", // 1 - agent 1
	"csgonew4/jamison/death.wav" // 2 - agent 2
};

new const CT_DEFUSING_BOMB[][] = {
	"csgonew4/gsg9/defusing.wav", // 0 - agent 0
	"csgonew4/ricksaw/defusing.wav", // 1 - agent 1
	"csgonew4/jamison/defusing.wav" // 2 - agent 2
};

new const T_PLANTINGBOMB[][] = {
	"csgonew4/phoenix/plantingbomb.wav", // 0 - agent 0
	"csgonew4/safecracker/plantingbomb.wav", // 1 - agent 1
	"csgonew4/bloody_darryl/plantingbomb.wav" // 2 - agent 2
};

new const AGENT_MODELT[][] = {
	"phoenix_slingshot",
	"pro_safecracker",
	"master_agents"
};

new const AGENT_MODELCT[][] = {
	"csgo_gsg9",
	"st6_ricksaw",
	"swat_jamison"
};

new const EL_BASI_CT[][] = {
	"csgonew4/gsg9/round_start_01.wav", // 0 - agent 0
	"csgonew4/gsg9/round_start_02.wav", // 1 - agent 0

	"csgonew4/ricksaw/round_start_01.wav", // 2 - agent 1
	"csgonew4/ricksaw/round_start_02.wav", // 3 - agent 1

	"csgonew4/jamison/round_start_01.wav", // 4 - agent 2
	"csgonew4/jamison/round_start_02.wav", // 5 - agent 2
};

new const EL_BASI_T[][] = {
	"csgonew4/phoenix/round_start_01.wav", // 0 - agent 0
	"csgonew4/phoenix/round_start_02.wav", // 1 - agent 0

	"csgonew4/safecracker/round_start_01.wav", // 2 - agent 1
	"csgonew4/safecracker/round_start_02.wav", // 3 - agent 1

	"csgonew4/bloody_darryl/round_start_01.wav", // 4 - agent 2
	"csgonew4/bloody_darryl/round_start_02.wav", // 5 - agent 2
};

enum _:Weapons
{
	AK47,
	AWP,
	DEAGLE,
	GALIL,
	GLOCK,
	M4A1,
	M4A4,
	P90,
	USP
};

enum _:Knifes
{
	Default,
	BAYONET,
	BOWIE,
	BUTTERFLY,
	FLIP,
	KARAMBIT,
	M9BAYONET,
	TALON,
	STILETTO,
	PARACORD
};

new Crosshair[MAX_PLAYERS + 1],
	iPlayerGlove[MAX_PLAYERS + 1], 
	iPlayerSkin[MAX_PLAYERS + 1][Weapons],
	iPlayerKnife[MAX_PLAYERS + 1][Knifes],
	iPlayerKnifeA[MAX_PLAYERS + 1],
	g_M4[MAX_PLAYERS + 1],
	g_fov[MAX_PLAYERS + 1],
	g_duman[MAX_PLAYERS + 1],
	iBodyIndex[MAX_PLAYERS + 1],
	g_PlayerAgent[MAX_PLAYERS + 1][3],
	g_PlayerAgentC[MAX_PLAYERS + 1][3],
	g_Zoom[MAX_PLAYERS + 1],
	Float:g_ZoomTime[MAX_PLAYERS + 1],
	Float:g_LookTime[MAX_PLAYERS + 1],
	g_win,
	Float:defuse_sesengel,
	Float:planting_sesengel,
	Float:Values[MAX_PLAYERS + 1][3],
	maxplayer,
	pointnum,
	g_SmokePuff_SprId,
	g_vault,
	g_warmtime,
	iSeconds,
	bool:g_warmup,
	bool:g_RadioTimer[MAX_PLAYERS + 1],
	bool:g_isDead[MAX_PLAYERS + 1];

new const augsg_nokta[] = { "custom_augsg_scope" };
new const AUG_SCOPE[] = "models/csgonew4/v_augscope.mdl";
new const SIG_SCOPE[] = "models/csgonew4/v_sigscope.mdl";

new const TAG[] = "LP";
new const TAG2[] = "Lost Player";

new const SPRITES2[][] = {
	"sprites/csgonew4/muzzleflash.spr", // 0
	"sprites/csgonew4/win.spr"
};

new const ROUND_SOUNDS[][] = {
	"csgonew4/roundstart1.mp3", // 0
	"csgonew4/roundstart2.mp3", // 1
	"csgonew4/roundend.mp3", // 2
	"csgonew4/lostround.mp3" // 3
};

enum _:Messages
{
	Message_WeaponList,
	Message_ScreenFade,
	Message_CurWeapon,
	Message_ForceCam,
	Message_SetFov,
	Message_HideWeapon
};

new Message_New[Messages];

new Messages_Names[Messages][] =
{
	"WeaponList",
	"ScreenFade",
	"CurWeapon",
	"ForceCam",
	"SetFOV",
	"HideWeapon"
};

new const GameName[32] = "CS:Global Offensive";

#define is_user_valid(%1) (1 <= %1 <= get_member_game(m_nMaxPlayers))
#define is_nullent2(%0)          (%0 == 0 || %0 == NULLENT || is_entity(%0) == false)
#define HUD_HIDE_FLASH (1<<1)
#define HUD_HIDE_CROSS (1<<6)

const KEYSMENU = MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_forward(FM_EmitSound, "EmitSound", false);
	register_forward(FM_AddToFullPack, "fw_AddToFullPack_Post", 1);
	register_forward(FM_CheckVisibility, "fw_CheckVisibility");

	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_c4", "CC4_PrimaryAttack");

	for (new i; i < sizeof WeaponNames; i++)
	{
		RegisterHam(Ham_CS_Weapon_SendWeaponAnim, WeaponNames[i], "HamF_CS_Weapon_SendWeaponAnim_Post", true);
	}

	for (new i; i < sizeof TraceBullets; i++)
	{
		RegisterHam(Ham_TraceAttack, TraceBullets[i], "HamF_TraceAttack_Post", true);
	}

	for(new i; i < sizeof(Message_New); i++)
	{
		Message_New[i] = get_user_msgid(Messages_Names[i]);
	}

	register_message(get_user_msgid("TextMsg"), "Message_TextMsg" );
	
	RegisterHookChain(RG_CBasePlayerWeapon_DefaultDeploy, "CBasePlayerWeapon_DefaultDeploy", .post = false);
	register_forward(FM_UpdateClientData, "FM_Hook_UpdateClientData_Post", 1);
	register_forward(FM_PlaybackEvent, "Forward_PlaybackEvent");
	RegisterHookChain(RG_CSGameRules_ClientUserInfoChanged, "Forward_ClientUserInfoChanged", .post = false);
	RegisterHookChain(RG_CSGameRules_RestartRound, "CSGameRules_RestartRound", .post = false);
	RegisterHookChain(RG_CSGameRules_OnRoundFreezeEnd, "CSGameRules_OnRoundFreezeEnd", .post = true);
	RegisterHookChain(RG_CGrenade_DefuseBombStart, "CGrenade_DefuseBombStart", .post = true);
	RegisterHookChain(RG_CBasePlayer_ImpulseCommands, "LookWeapon", .post = false);
	RegisterHookChain(RG_CBasePlayer_Spawn, "CBasePlayer_SpawnPost", .post = true);
	RegisterHookChain(RG_CSGameRules_DeathNotice, "CSGameRules_DeathNotice", .post = true); 
	RegisterHookChain(RG_CBasePlayer_AddPlayerItem, "CBasePlayer_AddPlayerItem", .post = false);
	RegisterHookChain(RG_RoundEnd, "RoundEnd", .post = true);
	RegisterHookChain(RG_PlayerBlind, "PlayerBlind", .post = true);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "CBasePlayer_TakeDamage", .post = true);
	RegisterHookChain(RG_CBasePlayer_Radio, "Radio_Pre", .post = false);
	
	register_clcmd("radio1", "radio", 0, "- Calls radio menu 1");
	register_clcmd("radio2", "radio", 0, "- Calls radio menu 2");
	register_clcmd("radio3", "radio", 0, "- Calls radio menu 3");

	register_clcmd("awp_scope_custom", "Hook_weapon_awp");
	register_clcmd("scout_scope_custom", "Hook_weapon_scout");

	register_menucmd(register_menuid("Radio Commands"), 511, "radiocmd");
	register_menu("terroragent", KEYSMENU, "t_ajancmd");

	register_message(get_user_msgid("TextMsg"), "message");
	register_message(get_user_msgid("SendAudio"), "msg_audio");

	bind_pcvar_num(create_cvar("amx_warmuptime", "8"), g_warmtime);

	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1");

	register_clcmd("chooseteam", "clcmd_changeteam");
	register_clcmd("jointeam", "clcmd_changeteam");

	register_clcmd("say !glove", "Eldiven_Menu");
	register_clcmd("say !skins", "SKIN_Menu");
	register_clcmd("say !agets", "AJAN_Menu");

	g_win = 2;

	set_member_game(m_GameDesc, GameName);
	maxplayer = get_member_game(m_nMaxPlayers);
	pointnum = get_cvar_pointer("mp_c4timer");
}

public CBasePlayer_SpawnPost(const id)
{
	if(is_user_bot(id))
	{
		iPlayerKnifeA[id] = random_num(0, 9);
		iPlayerGlove[id] = random_num(0, 9);
		ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], 0));
	}

	if(is_user_alive(id) && is_user_valid(id))
	{
		g_isDead[id] = false;
	}

	if(!g_isDead[id])
	{
		static iWeapon;
	
		iWeapon = get_member(id, m_pActiveItem);

		if(!is_nullent2(iWeapon) && !g_isDead[id])
		{
			ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
		}		

		static tur; tur = (get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins)+1);
		if(tur == 16)
		{
			static para; para = get_cvar_num("mp_startmoney");

			rg_remove_all_items(id);
			rg_set_user_armor(id, 0, ARMOR_NONE);
			rg_give_item(id, "weapon_knife", GT_REPLACE);

			switch(get_member(id, m_iTeam))
			{
				case TEAM_TERRORIST:
				{
					rg_give_item(id, "weapon_glock18", GT_REPLACE);
					rg_set_user_bpammo(id, rg_get_weapon_info("weapon_glock18", WI_ID), 90);
				}
				case TEAM_CT:
				{
					rg_give_item(id, "weapon_usp", GT_REPLACE);
					rg_set_user_bpammo(id, rg_get_weapon_info("weapon_usp", WI_ID), 90);
				}
			}
			rg_add_account(id, para, AS_SET);
		}

		if(g_warmup)
		{
			new Map[32]; get_mapname(Map, sizeof(Map));
			if(equal(Map, "awp_", 3)) 
				return;

			silah_ver(id);
		}

		g_PlayerAgent[id][0] = g_PlayerAgentC[id][0];
		g_PlayerAgent[id][1] = g_PlayerAgentC[id][1];
		g_PlayerAgent[id][2] = g_PlayerAgentC[id][2];
		
		switch(get_member(id, m_iTeam))
		{
			case TEAM_TERRORIST:
			{
				switch(g_PlayerAgent[id][0])
				{
					case 2: {
						rg_set_user_model(id, AGENT_MODELT[g_PlayerAgent[id][0]], true);
						set_entvar(id, var_skin, g_PlayerAgent[id][2]);
					}
					default: rg_set_user_model(id, AGENT_MODELT[g_PlayerAgent[id][0]], true);
				}
			}
			case TEAM_CT:
			{
				rg_set_user_model(id, AGENT_MODELCT[g_PlayerAgent[id][1]], true);
			}
		}

		UnScope(id);
		Event_CurWeapon(id);
		ShowHud(id);
	}
}

public CSGameRules_DeathNotice(victim, attacker)
{
	if(!is_user_connected(victim) || !is_user_valid(victim))
		return HC_CONTINUE;

	g_isDead[victim] = true;

	if(g_warmup)
	{	
		new team;
		team = get_member(victim, m_iTeam);

		if(any:team == TEAM_TERRORIST || any:team == TEAM_CT)
		{
			set_task( 0.5, "revle", victim );
		}
	}

	if(get_member(victim, m_bHeadshotKilled) && WeaponIdType:get_member(get_member(attacker, m_pActiveItem), m_iId) != WEAPON_KNIFE)
	{
		rh_emit_sound2(victim, 0, CHAN_STATIC, SOUNDS2[2], 1.0, 0.9, 0, PITCH_NORM);
	}

	return HC_CONTINUE;
}

public CC4_PrimaryAttack( iC4 )
{
    if( g_warmup )
    {
        set_member(iC4, m_Weapon_flNextPrimaryAttack, 1.0);
        return HAM_SUPERCEDE;
    }
    return HAM_IGNORED;
} 

public silah_ver( id )
{
	if( !g_isDead[id] && g_warmup) 
	{
		static Item[ 64 ];
		
		formatex( Item, charsmax( Item ), "\ySilah Menu" );
		new Menu = menu_create( Item, "silah_verdevam" );
		
		formatex( Item, charsmax( Item ), "\yAWP" );
		menu_additem( Menu, Item, " 1 ");
		formatex( Item, charsmax( Item ), "\yAK47" );
		menu_additem( Menu, Item, " 2 ");
		formatex( Item, charsmax( Item ), "\yM4A1" );
		menu_additem( Menu, Item, " 3 ");
		formatex( Item, charsmax( Item ), "\yFAMAS" );
		menu_additem( Menu, Item, " 4 ");
		formatex( Item, charsmax( Item ), "\yGALIL" );
		menu_additem( Menu, Item, " 5 ");
		
		menu_setprop( Menu, MPROP_EXIT, MEXIT_ALL );
		menu_display( id, Menu, 0 );
	}
	return PLUGIN_HANDLED;
}

public silah_verdevam( id, menu, item )
{
	if( item == MENU_EXIT )
	{
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	
	if(!is_user_connected(id) || g_isDead[id] || !g_warmup)
		return PLUGIN_HANDLED;

	new access, callback, data[ 6 ], name[ 32 ];
	menu_item_getinfo( menu, item, access, data, 5, name, 31, callback );
	
	new key = str_to_num( data );
	
	rg_give_item(id, "weapon_deagle", GT_REPLACE);
	rg_set_user_bpammo(id, WEAPON_DEAGLE, 35);

	switch( key )
	{
		case 1 :
		{
			if( is_user_connected(id) && !g_isDead[id] && g_warmup )
			{
				rg_give_item(id, "weapon_awp");
				rg_set_user_bpammo(id, WEAPON_AWP, 250);
				rg_give_item(id, "item_assaultsuit");
			}
		}
		case 2 :
		{
			if( is_user_connected(id) && !g_isDead[id] && g_warmup )
			{
				rg_give_item(id, "weapon_ak47" );
				rg_set_user_bpammo(id, WEAPON_AK47, 250);
				rg_give_item(id, "item_assaultsuit");
			}
		}
		case 3 :
		{
			if( is_user_connected(id) && !g_isDead[id] && g_warmup )
			{
				rg_give_item(id, "weapon_m4a1" );
				rg_set_user_bpammo(id, WEAPON_M4A1, 250);
				rg_give_item(id, "item_assaultsuit");
			}
		}
		case 4 :
		{
			if( is_user_connected(id) && !g_isDead[id] && g_warmup )
			{
				rg_give_item(id, "weapon_famas" );
				rg_set_user_bpammo(id, WEAPON_FAMAS, 250);
				rg_give_item(id, "item_assaultsuit");
			}
		}
		case 5 :
		{
			if( is_user_connected(id) && !g_isDead[id] && g_warmup )
			{
				rg_give_item(id, "weapon_galil" );
				rg_set_user_bpammo(id, WEAPON_GALIL, 250);
				rg_give_item(id, "item_assaultsuit");
			}
		}
	}
	menu_destroy( menu );
	return PLUGIN_HANDLED;
}

public ShowHud(id)
{
	new Text[128];
	formatex(Text, charsmax(Text), "TUR^n%i TE		[%i]		CT %i",get_member_game(m_iNumTerroristWins), get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins)+1, get_member_game(m_iNumCTWins));
	set_dhudmessage(255, 255, 255, -1.0, 0.0, 2, 9.0, 12.0);
	show_dhudmessage(id, Text);
}

public CSGameRules_RestartRound()
{
	g_win = 2;

	if(!g_warmup)
	{
		remove_task(2000);

		static tur; tur = (get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins)+1);

		for(new id = 1; id <= maxplayer; id++)
		{
			if(!is_user_connected(id) || !is_user_valid(id))
				continue;
			
			if(tur == 15 || tur == 30)
			{
				new Text[128];
				if(tur == 15) formatex(Text, charsmax(Text), "Ilk Yarinin Son Turu!");
				else if(tur == 30) formatex(Text, charsmax(Text), "Mac Sayisi!");
				set_dhudmessage(255, 255, 255, -1.0, 0.20, 2, 9.0, 12.0);
				show_dhudmessage(id, Text);

				PlaySound(id, ROUND_SOUNDS[3]);
			}
			else PlaySound(id, ROUND_SOUNDS[random_num(0, 1)]);
		}

		static para; para = get_cvar_num("mp_startmoney");
		
		if(tur == 16)
		{
			for(new id = 1; id <= maxplayer; id++)
			{
				if(!is_user_connected(id) || !is_user_valid(id) || g_isDead[id])
					continue;

				rg_remove_all_items(id);
				rg_set_user_armor(id, 0, ARMOR_NONE);
				rg_give_item(id, "weapon_knife", GT_REPLACE);

				switch(get_member(id, m_iTeam))
				{
					case TEAM_TERRORIST:
					{
						rg_give_item(id, "weapon_glock18", GT_REPLACE);
						rg_set_user_bpammo(id, rg_get_weapon_info("weapon_glock18", WI_ID), 90);
					}
					case TEAM_CT:
					{
						rg_give_item(id, "weapon_usp", GT_REPLACE);
						rg_set_user_bpammo(id, rg_get_weapon_info("weapon_usp", WI_ID), 90);
					}
				}
				set_member(id, m_iAccount, para);
			}
		}

		if(tur != 31)
		{
			new map[32];
			get_mapname(map, charsmax(map));
			client_print_color(0, print_team_red, "^1[^4%s^1] ^3Map: ^1[^4%s^1] ^3Round: ^1[^4%d^1 /^4 30^1]", TAG, map, tur);
			client_print_color(0, print_team_red, "^1[^4%s^1] ^4Takim Skoru: ^3T: ^1[^4%d^1] ^3CT: ^1[^4%d^1]", TAG, get_member_game(m_iNumTerroristWins), get_member_game(m_iNumCTWins));
		}
	}
}

public CSGameRules_OnRoundFreezeEnd()
{
	new team, canli, player, id, number, count;
	canli = Canli_kisiler();
	count = GetPlayingCount(2);

	if(count > 1) {
		count = GetPlayingCount(1);
		if(count >= 1) {
			while(number < 1)
			{
				player = GetRandomAlive(random_num(1, canli));
				team = get_member(player, m_iTeam);

				if(!is_user_connected(player) || !is_user_valid(player) || any:team != TEAM_CT || g_isDead[player])
					continue;
				
				for(id = 1; id <= maxplayer; id++)
				{
					if(!is_user_connected(id) || !is_user_valid(id))
						continue;
					
					team = get_member(id, m_iTeam);

					if(any:team == TEAM_CT)
					{
						switch(g_PlayerAgent[player][1]) {
							case 0: PlaySound(id, EL_BASI_CT[random_num(0, 1)]);
							case 1: PlaySound(id, EL_BASI_CT[random_num(2, 3)]);
							case 2: PlaySound(id, EL_BASI_CT[random_num(4, 5)]);
						}
					}
				}
				number = 2;
			}
		}

		count = GetPlayingCount(1);
		number = 0;

		if(count >= 1) {
			while(number < 1)
			{
				player = GetRandomAlive(random_num(1, canli));
				team = get_member(player, m_iTeam);

				if(!is_user_connected(player) || !is_user_valid(player) || any:team != TEAM_TERRORIST || g_isDead[player])
					continue;

				for(id = 1; id <= maxplayer; id++)
				{
					if(!is_user_connected(id) || !is_user_valid(id))
						continue;
					
					team = get_member(id, m_iTeam);

					if(any:team == TEAM_TERRORIST)
					{
						switch(g_PlayerAgent[player][0]) {
							case 0: PlaySound(id, EL_BASI_T[random_num(0, 1)]);
							case 1: PlaySound(id, EL_BASI_T[random_num(2, 3)]);
							case 2: PlaySound(id, EL_BASI_T[random_num(4, 5)]);
						}
					}
				}
				number = 2;
			}
		}
	}
}

public plugin_cfg()
{
	g_vault = nvault_open("csgomod");

	if ( g_vault == INVALID_HANDLE )
		set_fail_state( "Error opening levels nVault, file does not exist!" );
}

public plugin_end()
{
	//Close the vault when the plugin ends (map change\server shutdown\restart)
	nvault_close(g_vault);
}

public client_connect(id)
{
	LoadLevel(id);

	if(g_fov[id] == 0 && is_user_valid(id) && is_user_connected(id))
	{
		g_fov[id] = 90;
		set_member(id, m_iFOV, 90);
		set_member(id, m_iClientFOV, 90);
	}
}

public client_putinserver(id)
{
	g_RadioTimer[id] = false;
	g_isDead[id] = false;

	if( g_warmup )
	{
		set_task( 3.0, "revle", id );
	}
}

public client_disconnected(id)
{
	g_PlayerAgent[id][0] = g_PlayerAgentC[id][0];
	g_PlayerAgent[id][1] = g_PlayerAgentC[id][1];
	g_PlayerAgent[id][2] = g_PlayerAgentC[id][2];
	
	SaveLevel(id);

	Crosshair[id] = 0;
	iPlayerGlove[id] = 0;
	new i;
	for(i = 0; i < Weapons; i++) iPlayerSkin[id][i] = 0;
	for(i = 0; i < Knifes; i++) iPlayerKnife[id][i] = 0;
	iPlayerKnifeA[id] = 0;
	g_M4[id] = 0;
	g_fov[id] = 0;
	g_duman[id] = 0;
	iBodyIndex[id] = 0;
	g_PlayerAgent[id][0] = 0;
	g_PlayerAgent[id][1] = 0;
	g_PlayerAgent[id][2] = 0;
	g_PlayerAgentC[id][0] = 0; 
	g_PlayerAgentC[id][1] = 0; 
	g_PlayerAgentC[id][2] = 0;
	g_Zoom[id] = 0;
	g_ZoomTime[id] = 0.0;
	g_LookTime[id] = 0.0;
	Values[id][0] = 0.0;
	Values[id][1] = 0.0;
	Values[id][2] = 0.0;
	g_RadioTimer[id] = false;
	g_isDead[id] = false;
}

public revle( const id )
{
	if( g_warmup && is_user_connected(id) && g_isDead[id])
	{	
		new team;
		team = get_member(id, m_iTeam);
		if(any:team == TEAM_TERRORIST || any:team == TEAM_CT )
		{
			rg_round_respawn(id);
		}
		else {
			set_task( 3.0, "revle", id );
		}
	}
}

SaveLevel(id)
{
	new szAuth[33];
	new szKey[64];
	
	get_user_authid(id , szAuth , charsmax(szAuth));
	formatex(szKey , charsmax(szKey) , "%s-ID" , szAuth);

	new szData[256];
	
	formatex(szData , charsmax(szData) , "%d#", iPlayerSkin[id][AK47]);

	for(new i = 1; i < Weapons; i++)
	{
		formatex(szData, charsmax(szData), "%s%d#", szData, iPlayerSkin[id][i]);
	}

	for(new i = 0; i < Knifes; i++)
	{
		formatex(szData, charsmax(szData), "%s%d#", szData, iPlayerKnife[id][i]);
	}

	formatex(szData, charsmax(szData), "%s%d#%d#%d#%d#%d#%d#%d#%d#%d#^n", szData, iPlayerKnifeA[id], iPlayerGlove[id], g_M4[id], g_fov[id], Crosshair[id], g_duman[id], g_PlayerAgent[id][0], g_PlayerAgent[id][1], g_PlayerAgent[id][2]);

	nvault_pset(g_vault , szKey , szData);
}

LoadLevel(id)
{
	new szAuth[33];
	new szKey[64];
	
	get_user_authid(id , szAuth , charsmax(szAuth));
	formatex(szKey , charsmax(szKey) , "%s-ID" , szAuth);
	
	new szData[256];
	
	formatex(szData , charsmax(szData) , "%d#", iPlayerSkin[id][AK47]);

	for(new i = 1; i < Weapons; i++)
	{
		formatex(szData, charsmax(szData), "%s%d#", szData, iPlayerSkin[id][i]);
	}

	for(new i = 0; i < Knifes; i++)
	{
		formatex(szData, charsmax(szData), "%s%d#", szData, iPlayerKnife[id][i]);
	}

	formatex(szData, charsmax(szData), "%s%d#%d#%d#%d#%d#%d#%d#%d#%d#^n", szData, iPlayerKnifeA[id], iPlayerGlove[id], g_M4[id], g_fov[id], Crosshair[id], g_duman[id], g_PlayerAgent[id][0], g_PlayerAgent[id][1], g_PlayerAgent[id][2]);

	nvault_get(g_vault, szKey, szData, charsmax(szData));
	replace_all(szData , charsmax(szData), "#", " ");

	new ak47[6], awp[6], deagle[6], galil[6], glock[6], m4a1[6], m4a4[6], p90[6], usp[6], defknife[6], bayonet[6], bowie[6], butterfly[6], flip[6], karambit[6], m9bayonet[6], talon[6], stiletto[6], paracord[6], knifeA[6], playerglove[6], m4[6], fov[6], cross[6], duman[6], agent1[6], agent2[6], agent3[6];
	parse(szData, ak47, 5, awp, 5, deagle, 5, galil, 5, glock, 5, m4a1, 5, m4a4, 5, p90, 5, usp, 5, defknife, 5, bayonet, 5, bowie, 5, butterfly, 5, flip, 5, karambit, 5, m9bayonet, 5, talon, 5, stiletto, 5, paracord, 5, knifeA, 5, playerglove, 5, m4, 5, fov, 5, cross, 5, duman, 5, agent1, 5, agent2, 5, agent3, 5);

	iPlayerSkin[id][AK47] = str_to_num(ak47);
	iPlayerSkin[id][AWP] = str_to_num(awp);
	iPlayerSkin[id][DEAGLE] = str_to_num(deagle);
	iPlayerSkin[id][GALIL] = str_to_num(galil);
	iPlayerSkin[id][GLOCK] = str_to_num(glock);
	iPlayerSkin[id][M4A1] = str_to_num(m4a1);
	iPlayerSkin[id][M4A4] = str_to_num(m4a4);
	iPlayerSkin[id][P90] = str_to_num(p90);
	iPlayerSkin[id][USP] = str_to_num(usp);

	iPlayerKnife[id][Default] = str_to_num(defknife);
	iPlayerKnife[id][BAYONET] = str_to_num(bayonet);
	iPlayerKnife[id][BOWIE] = str_to_num(bowie);
	iPlayerKnife[id][BUTTERFLY] = str_to_num(butterfly);
	iPlayerKnife[id][FLIP] = str_to_num(flip);
	iPlayerKnife[id][KARAMBIT] = str_to_num(karambit);
	iPlayerKnife[id][M9BAYONET] = str_to_num(m9bayonet);
	iPlayerKnife[id][TALON] = str_to_num(talon);
	iPlayerKnife[id][STILETTO] = str_to_num(stiletto);
	iPlayerKnife[id][PARACORD] = str_to_num(paracord);

	iPlayerKnifeA[id] = str_to_num(knifeA);
	iPlayerGlove[id] = str_to_num(playerglove);
	g_M4[id] = str_to_num(m4);
	g_fov[id] = str_to_num(fov);
	Crosshair[id] = str_to_num(cross);
	g_duman[id] = str_to_num(duman);

	g_PlayerAgentC[id][0] = str_to_num(agent1);
	g_PlayerAgentC[id][1] = str_to_num(agent2);
	g_PlayerAgentC[id][2] = str_to_num(agent3);

	g_PlayerAgent[id][0] = str_to_num(agent1);
	g_PlayerAgent[id][1] = str_to_num(agent2);
	g_PlayerAgent[id][2] = str_to_num(agent3);
}

public clcmd_changeteam(id)
{
	switch(get_member(id, m_iTeam))
	{
		case TEAM_UNASSIGNED, TEAM_SPECTATOR: return PLUGIN_CONTINUE;
		default: CSGO_Menu(id);
	}

	return PLUGIN_HANDLED;
}

public CBasePlayerWeapon_DefaultDeploy(const pEntity, szViewModel[], szWeaponModel[], iAnim, szAnimExt[], skiplocal)
{
	skiplocal = 1;

	static iPlayer;	
	iPlayer = get_member(pEntity, m_pPlayer);

	new iTaskData[2];

	iTaskData[0] = pEntity;
	iTaskData[1] = 0;

	SetHookChainArg(2, ATYPE_STRING, "");
	UTIL_SendWeaponAnim(iPlayer, 0, 0);
	set_task(0.1, "DeployWeaponSwitch", iPlayer, iTaskData, sizeof(iTaskData));
	//set_task(0.01, "DeployWeaponSwitch", iPlayer, iTaskData, sizeof(iTaskData));

	g_LookTime[iPlayer] = 0.0;
}

public DeployWeaponSwitch(iTaskData[], id)
{
	static WeaponIdType:wep_id, OldWeapon, pEntity; // skinid
	OldWeapon = iTaskData[0];

	if(g_isDead[id] || !is_user_connected(id)) return HC_CONTINUE;

	pEntity = get_member(id, m_pActiveItem);
	//skinid = WeaponSkinID(id, pEntity);
	wep_id = rg_get_weapon(pEntity); //WEAPON_ENT(pEntity);

	if(wep_id != WeaponIdType:rg_get_weapon(OldWeapon)) {
		//set_entvar(id, var_viewmodel, "");
		return HC_CONTINUE;
	}

	set_member(pEntity, m_flLastEventCheck, get_gametime() + 0.001);	//0.001 is good enough
	UTIL_SendWeaponAnim(id, 0, 0);
	return HC_CONTINUE;

	/*
	switch(wep_id)
	{
		case WEAPON_KNIFE:
		{
			//ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerKnife[id][iPlayerKnifeA[id]]));
			set_entvar(id, var_viewmodel, g_KnifeModels[iPlayerKnifeA[id]]);
		}
		case WEAPON_M4A1:
		{
			set_member(pEntity, m_Weapon_flNextSecondaryAttack, 9999.9);

			if(g_M4[id] == 0)
			{
				set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) | WPNSTATE_M4A1_SILENCED);
			}
			else
			{
				set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) &~ WPNSTATE_M4A1_SILENCED);
			}

			//ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerSkin[id][skinid]));
			set_entvar(id, var_viewmodel, g_M4Models[g_M4[id]]);
		}
		default:
		{
			if(wep_id == WEAPON_USP) // WeaponIdType:get_member(pEntity, m_iId) == WEAPON_USP
			{
				set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) | WPNSTATE_USP_SILENCED);
				set_member(pEntity, m_Weapon_flNextSecondaryAttack, 9999.9);
			}
			//ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerSkin[id][skinid] == 0 ? 0 : iPlayerSkin[id][skinid]));
			set_entvar(id, var_viewmodel, g_NewModels[get_member(pEntity, m_iId)]);
		}
	}*/
}

public HamF_CS_Weapon_SendWeaponAnim_Post(iEnt, iAnim, Skiplocal)
{
	Skiplocal = 0;
	
	new id;
 
	id = get_member(iEnt, m_pPlayer);
	
	UTIL_SendWeaponAnim(id, iAnim, iBodyIndex[id]);
	
	return HAM_IGNORED;
}

public Forward_PlaybackEvent(iFlags, id, iEvent, Float:fDelay, Float:vecOrigin[3], Float:vecAngle[3], Float:flParam1, Float:flParam2, iParam1, iParam2, bParam1, bParam2)
{
	if(!is_user_valid(id))
	{
		return FMRES_IGNORED;
	}

	if(!g_isDead[id])
	{
		static iEnt;
	
		iEnt = get_member(id, m_pActiveItem);

		if(is_nullent2(iEnt))
		{
			return FMRES_SUPERCEDE;
		}

		new ResourcePath[32+(2*32)], Distant;

		g_LookTime[id] = 0.0;

		switch(WeaponIdType:rg_get_weapon(iEnt))
		{
			case WEAPON_M4A1:
			{
				set_member(iEnt, m_Weapon_flNextSecondaryAttack, 9999.9);
				if(g_M4[id] == 0)
				{
					set_member(iEnt, m_Weapon_iWeaponState, get_member(iEnt, m_Weapon_iWeaponState) | WPNSTATE_M4A1_SILENCED);
					rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[19], 1.0, 0.4, 0, 94 + random_num(0, 15));
					PlayWeaponState(id, M4A1_SHOOT3);

					Distant = -1;
				}
				else
				{
					set_member(iEnt, m_Weapon_iWeaponState, get_member(iEnt, m_Weapon_iWeaponState) &~ WPNSTATE_M4A1_SILENCED);
					rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[20], 1.0, 0.4, 0, 94 + random_num(0, 15));
					PlayWeaponState(id, M4A1_UNSIL_SHOOT3);

					Distant = 19;
				}
			}
			case WEAPON_USP:
			{
				set_member(iEnt, m_Weapon_iWeaponState, get_member(iEnt, m_Weapon_iWeaponState) | WPNSTATE_USP_SILENCED);
				set_member(iEnt, m_Weapon_flNextSecondaryAttack, 9999.9);
				rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[21], 1.0, 0.4, 0, 94 + random_num(0, 15));
				PlayWeaponState(id, USP_SHOOT3);
				Distant = 20;
			}
			case WEAPON_GLOCK18: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[0], 1.0, 0.4, 0, 94 + random_num(0, 15)) , PlayWeaponState(id, GLOCK18_SHOOT3), Distant = 0;
			case WEAPON_AK47: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[1], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, AK47_SHOOT1), Distant = 1;
			case WEAPON_AUG: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[2], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, AUG_SHOOT1), Distant = 2;
			case WEAPON_AWP: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[3], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, AWP_SHOOT2), Distant = 3;
			case WEAPON_DEAGLE: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[4], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, DEAGLE_SHOOT1), Distant = 4;
			case WEAPON_ELITE:
			{
				Values[id][0] = float(random_num(0, 9));
				Values[id][1] = get_gametime() + 0.047;

				if(get_entvar(id, var_weaponanim) == ELITE_SHOOTLEFT5)
					PlayWeaponState(id, ELITE_SHOOTRIGHT5);
				else if(get_entvar(id, var_weaponanim) == ELITE_SHOOTRIGHT5)
					PlayWeaponState(id, ELITE_SHOOTLEFT5);
				else
				{
					switch(random_num(0, 1))
					{
						case 0: PlayWeaponState(id, ELITE_SHOOTLEFT5);
						case 1: PlayWeaponState(id, ELITE_SHOOTRIGHT5);
					}
				}
				rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[5], 1.0, 0.4, 0, 94 + random_num(0, 15));
				Distant = 5;
			}
			case WEAPON_FAMAS: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[6], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, CLARION_SHOOT2), Distant = 6;
			case WEAPON_FIVESEVEN: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[7], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, FIVESEVEN_SHOOT1), Distant = 7;
			case WEAPON_GALIL: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[8], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, GALIL_SHOOT3), Distant = 8;
			case WEAPON_M3: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[9], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, M3_FIRE2), Distant = 9;
			case WEAPON_M249: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[10], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, M249_SHOOT2), Distant = 10;
			case WEAPON_MAC10: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[11], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, MAC10_SHOOT1), Distant = 11;
			case WEAPON_MP5N: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[12], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, MP5N_SHOOT1), Distant = 12;
			case WEAPON_P90: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[13], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, P90_SHOOT1), Distant = 13;
			case WEAPON_P228: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[14], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, P228_SHOOT2), Distant = 14;
			case WEAPON_SCOUT: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[15], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, SCOUT_SHOOT), Distant = 15;
			case WEAPON_SG552: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[16], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, SG552_SHOOT2), Distant = 16;
			case WEAPON_TMP: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[17], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, TMP_SHOOT3), Distant = 17;
			case WEAPON_UMP45: rh_emit_sound2(id, 0, CHAN_STATIC, WEAPONS_SHOOT_SOUND[18], 1.0, 0.4, 0, 94 + random_num(0, 15)), PlayWeaponState(id, UMP45_SHOOT2), Distant = 18;
		}

		if(Distant > -1)
		{
			formatex(ResourcePath, charsmax(ResourcePath), "csgonew4/distant/%s.wav", DISTANT[Distant]);
			PlaySound(0, ResourcePath);
		}

		switch(WeaponIdType:rg_get_weapon(iEnt))
		{
			case WEAPON_M4A1:
			{
				if(g_M4[id] == 1)
				{
					Values[id][0] = float(random_num(0, 9));
					Values[id][1] = get_gametime() + 0.05;
				}
			}
			case WEAPON_GLOCK18, WEAPON_AK47, WEAPON_AUG, WEAPON_AWP, WEAPON_DEAGLE, WEAPON_FAMAS, WEAPON_FIVESEVEN, WEAPON_GALIL, WEAPON_M3, WEAPON_M249, WEAPON_MAC10, WEAPON_MP5N, WEAPON_P90, WEAPON_P228, WEAPON_SCOUT, WEAPON_TMP, WEAPON_UMP45:
			{
				Values[id][0] = float(random_num(0, 9));
				Values[id][1] = get_gametime() + 0.05;
			}
			case WEAPON_SG552:
			{
				if(!g_Zoom[id])
				{
					Values[id][0] = float(random_num(0, 9));
					Values[id][1] = get_gametime() + 0.05;
				}
			}
		}

		return FMRES_SUPERCEDE;
	}

	for(new i = 1; i <= maxplayer; i++)
	{
		if(get_entvar(i, var_iuser1) != OBS_IN_EYE || get_entvar(i, var_iuser2) != id) 
			continue;
		
		return FMRES_SUPERCEDE;
	}

	return FMRES_IGNORED;	//Let other things to be pass	
}

//CS weapon animations hook/block fire here. With pev_iuser2 checkout. This code part by fl0wer
public FM_Hook_UpdateClientData_Post(iPlayer, SendWeapons, CD_Handle)
{
	enum
	{
		SPEC_MODE,
		SPEC_TARGET,
		SPEC_END
	};
	
	static aSpecInfo[33][SPEC_END];
	static Float: flGameTime;
	static Float: flLastEventCheck;
	static iTarget;
	static iSpecMode;
	static iActiveItem;
	static iId;

	iTarget = (iSpecMode = get_entvar(iPlayer, var_iuser1)) ? get_entvar(iPlayer, var_iuser2) : iPlayer;
	
	if(is_user_valid(iTarget)) iActiveItem = get_member(iTarget, m_pActiveItem);

	if(is_nullent2(iActiveItem))
		return FMRES_IGNORED;

	iId = get_member(iActiveItem, m_iId);

	flGameTime = get_gametime();
	flLastEventCheck = get_member(iActiveItem, m_flLastEventCheck);

	if(iId)
	{
		if(iSpecMode)
		{
			if(aSpecInfo[iPlayer][SPEC_MODE] != iSpecMode)
			{
				aSpecInfo[iPlayer][SPEC_MODE] = iSpecMode;
				aSpecInfo[iPlayer][SPEC_TARGET] = 0;
			}

			if(iSpecMode == OBS_IN_EYE && aSpecInfo[iPlayer][SPEC_TARGET] != iTarget)
			{
				aSpecInfo[iPlayer][SPEC_TARGET] = iTarget;

				new iTaskData[2];
				iTaskData[0] = iBodyIndex[iTarget];
				iTaskData[1] = IDLE_ANIM;
				
				//Because once pushing LMB u will immediately move to OBS_IN_EYE, the anim message may skip, so let's make delay
				set_task(0.1, "SPEC_OBS_IN_EYE", iPlayer, iTaskData, sizeof(iTaskData));	//Delay 0.1, because with high ping this may skip this 99%

				//ViewBodySwitch(iPlayer, iBodyIndex[iTarget]);
				//UTIL_SendWeaponAnim(iPlayer, IDLE_ANIM, iBodyIndex[iTarget]);
			}
		}

		if(!flLastEventCheck)
		{
			set_cd(CD_Handle, CD_flNextAttack, flGameTime + 0.001);
			set_cd(CD_Handle, CD_WeaponAnim, IDLE_ANIM);

			return FMRES_HANDLED;
		}

		if(flLastEventCheck <= flGameTime)
		{
			UTIL_SendWeaponAnim(iTarget, 0, 0);

			static WeaponIdType:wep_id, skinid;
	
			skinid = WeaponSkinID(iTarget, iActiveItem);
			wep_id = rg_get_weapon(iActiveItem);//WEAPON_ENT(iActiveItem);

			switch(wep_id)
			{
				case WEAPON_KNIFE:
				{
					ViewBodySwitch(iTarget, GetBodyIndex(iTarget, iPlayerGlove[iTarget], iPlayerKnife[iTarget][iPlayerKnifeA[iTarget]]));
					set_entvar(iTarget, var_viewmodel, g_KnifeModels[iPlayerKnifeA[iTarget]]);
				}
				case WEAPON_M4A1:
				{
					set_member(iActiveItem, m_Weapon_flNextSecondaryAttack, 9999.9);

					if(g_M4[iTarget] == 0)
					{
						set_member(iActiveItem, m_Weapon_iWeaponState, get_member(iActiveItem, m_Weapon_iWeaponState) | WPNSTATE_M4A1_SILENCED);
					}
					else
					{
						set_member(iActiveItem, m_Weapon_iWeaponState, get_member(iActiveItem, m_Weapon_iWeaponState) &~ WPNSTATE_M4A1_SILENCED);
					}

					ViewBodySwitch(iTarget, GetBodyIndex(iTarget, iPlayerGlove[iTarget], iPlayerSkin[iTarget][skinid]));
					set_entvar(iTarget, var_viewmodel, g_M4Models[g_M4[iTarget]]);
				}
				default:
				{
					if(WeaponIdType:get_member(iActiveItem, m_iId) == WEAPON_USP)
					{
						set_member(iActiveItem, m_Weapon_iWeaponState, get_member(iActiveItem, m_Weapon_iWeaponState) | WPNSTATE_USP_SILENCED);
						set_member(iActiveItem, m_Weapon_flNextSecondaryAttack, 9999.9);
					}

					ViewBodySwitch(iTarget, GetBodyIndex(iTarget, iPlayerGlove[iTarget], iPlayerSkin[iTarget][skinid] == 0 ? 0 : iPlayerSkin[iTarget][skinid]));
					set_entvar(iTarget, var_viewmodel, g_NewModels[get_member(iActiveItem, m_iId)]);
				}
			}

			//PlayWeaponState(iTarget, GetWeaponDrawAnim(iActiveItem));	//Custom weapon draw anim should go there too
			UTIL_SendWeaponAnim(iTarget, GetWeaponDrawAnim(iActiveItem), iBodyIndex[iTarget]);
			
			set_member(iActiveItem, m_flLastEventCheck, 0.0);
		}
	}

	return FMRES_IGNORED;
}

public Forward_ClientUserInfoChanged(const index, infobuffer[])
{
	static iUserInfo[6] = "cl_lw", iClientValue[2], iServerValue[2] = "1";
	
	if(CLIENT_DATA(index, iUserInfo, iClientValue))
	{
		HOOK_DATA(index, iUserInfo, iServerValue);
		return HC_SUPERCEDE;
	}
	
	return HC_CONTINUE;
}

public HamF_TraceAttack_Post(iEnt, iAttacker, Float:damage, Float:fDir[3], ptr, iDamageType)
{
	if(g_duman[iAttacker] != 0) return HAM_IGNORED;

	/*static iWeapon;
	
	iWeapon = get_member(iAttacker, m_pActiveItem);*/

	if(WeaponIdType:rg_get_user_weapon(iAttacker) == WEAPON_KNIFE) //if(WeaponIdType:get_member(get_member(iAttacker, m_pActiveItem), m_iId) == WEAPON_KNIFE)
	{
		return HAM_IGNORED;
	}
	/*switch(WEAPON_ENT(iWeapon))
	{
		case WEAPON_KNIFE: return HAM_IGNORED;	//No decals while stabbing or swinging with knife
	}*/

	static Float:flEnd[3], Float:vecPlane[3];
	get_tr2(ptr, TR_vecEndPos, flEnd);
	get_tr2(ptr, TR_vecPlaneNormal, vecPlane);
	
	Make_BulletSmoke(iAttacker, ptr);
	Make_BulletHole(iAttacker, flEnd, damage);
	
	return HAM_IGNORED;	
}

public CSGO_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wCS:GO Mod Menusu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_csgomenu");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wEldiven \rMenu", TAG2);
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wSkin \rMenu", TAG2);
	menu_additem(menu, TempString, "2");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wCrosshair \rMenu", TAG2);
	menu_additem(menu, TempString, "3");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wGorus Acisi \rMenu", TAG2);
	menu_additem(menu, TempString, "4");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wSilah Dumani \r%s", TAG2, g_duman[id] == 0 ? "Kapat" : "Ac");
	menu_additem(menu, TempString, "5");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wRutbe Bilgi", TAG2);
	menu_additem(menu, TempString, "6");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wAjan Menu", TAG2);
	menu_additem(menu, TempString, "7");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_csgomenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	switch(Numara)
	{
		case 1: Eldiven_Menu(id);
		case 2: SKIN_Menu(id);
		case 3: Crosshair_Menu2(id);
		case 4: Gorus_Menu(id);
		case 5:
		{
			if(g_duman[id] == 0)
			{
				g_duman[id] = 1;
				client_print_color(id, print_team_red, "^1[^4%s^1] ^3Silah Dumani ^4Kapali^1.", TAG);
			}
			else
			{
				g_duman[id] = 0;
				client_print_color(id, print_team_red, "^1[^4%s^1] ^3Silah Dumani ^4Acik^1.", TAG);
			}
		}
		case 6: client_cmd(id, "rutbe_bilgi");
		case 7: AJAN_Menu(id);
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public AJAN_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wCS:GO Ajan Menusu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_ajanmenu");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wT \rAjanlari", TAG2);
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "\y%s \d- \wCT \rAjanlari", TAG2);
	menu_additem(menu, TempString, "2");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_ajanmenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	switch(Numara)
	{
		case 1: T_AJANLARI(id);
		case 2: CT_AJANLARI(id);
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public T_AJANLARI(id)
{
	if(g_isDead[id]) return PLUGIN_HANDLED;
	
	static menu[512];
	new len;

	len = formatex(menu[len], charsmax(menu) - len,"\yT Ajanlari^n^n");

	if(g_PlayerAgent[id][0] == 0) len += formatex(menu[len], charsmax(menu) - len, "\r1. \dSlingshot \d| \dPhoenix^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r1. \wSlingshot \d| \yPhoenix^n");

	if(g_PlayerAgent[id][0] == 1) len += formatex(menu[len], charsmax(menu) - len, "\r2. \dSafecracker Voltzmann \d| \dThe Professionals^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r2. \wSafecracker Voltzmann \d| \yThe Professionals^n");

	if(g_PlayerAgent[id][0] == 2 && g_PlayerAgent[id][2] == 4) len += formatex(menu[len], charsmax(menu) - len, "\r3. \dSilent Darryl \d| \dThe Professionals^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r3. \wSilent Darryl \d| \yThe Professionals^n");

	if(g_PlayerAgent[id][0] == 2 && g_PlayerAgent[id][2] == 3) len += formatex(menu[len], charsmax(menu) - len, "\r4. \dSkullhead Darryl \d| \dThe Professionals^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r4. \wSkullhead Darryl \d| \yThe Professionals^n");

	if(g_PlayerAgent[id][0] == 2 && g_PlayerAgent[id][2] == 2) len += formatex(menu[len], charsmax(menu) - len, "\r5. \dDarryl Royale \d| \dThe Professionals^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r5. \wDarryl Royale \d| \yThe Professionals^n");

	if(g_PlayerAgent[id][0] == 2 && g_PlayerAgent[id][2] == 1) len += formatex(menu[len], charsmax(menu) - len, "\r6. \dLoudmouth Darryl \d| \dThe Professionals^n");
	else len += formatex(menu[len], charsmax(menu) - len, "\r6. \wLoudmouth Darryl \d| \yThe Professionals^n");

	if(g_PlayerAgent[id][0] == 2 && g_PlayerAgent[id][2] == 0) len += formatex(menu[len], charsmax(menu) - len, "\r7. \dMiami Darryl \d| \dThe Professionals");
	else len += formatex(menu[len], charsmax(menu) - len, "\r7. \wMiami Darryl \d| \yThe Professionals");

	len += formatex(menu[len], charsmax(menu) - len, "^n^n\r0. \wExit");
	
	set_pdata_int(id, 205, 0);

	show_menu(id, KEYSMENU, menu, -1, "terroragent");

	return PLUGIN_HANDLED;
} 

public t_ajancmd(id, key) {
	if(!is_user_connected(id))
		return PLUGIN_HANDLED;

	switch(key)
	{
		case 0: g_PlayerAgentC[id][0] = 0, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 1: g_PlayerAgentC[id][0] = 1, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 2: g_PlayerAgentC[id][0] = 2, g_PlayerAgentC[id][2] = 4, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 3: g_PlayerAgentC[id][0] = 2, g_PlayerAgentC[id][2] = 3, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 4: g_PlayerAgentC[id][0] = 2, g_PlayerAgentC[id][2] = 2, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 5: g_PlayerAgentC[id][0] = 2, g_PlayerAgentC[id][2] = 1, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
		case 6: g_PlayerAgentC[id][0] = 2, g_PlayerAgentC[id][2] = 0, client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
	}

	return PLUGIN_HANDLED;
}

public CT_AJANLARI(const id)
{
	static TempString[1024];
	
	formatex(TempString, sizeof(TempString), "\yCT Ajanlari");
	static menu; menu = menu_create(TempString, "MenuHandle_ctagentmenu");

	formatex(TempString, sizeof(TempString), "%s", g_PlayerAgent[id][1] == 0 ? "\dGSG-9" : "\wGSG-9");
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "%s", g_PlayerAgent[id][1] == 1 ? "\dLt. Commander Ricksaw \d| \dNSWC SEAL" : "\wLt. Commander Ricksaw \d| \yNSWC SEAL");
	menu_additem(menu, TempString, "2");

	formatex(TempString, sizeof(TempString), "%s", g_PlayerAgent[id][1] == 2 ? "\dCmdr. Mae 'Dead Cold' Jamison \d| \dSWAT" : "\wCmdr. Mae 'Dead Cold' Jamison \d| \ySWAT");
	menu_additem(menu, TempString, "3");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_ctagentmenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	switch(Numara)
	{
		case 1: g_PlayerAgentC[id][1] = 0;
		case 2: g_PlayerAgentC[id][1] = 1;
		case 3: g_PlayerAgentC[id][1] = 2;
	}

	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Secilen Ajan El Basi Gelicek!", TAG);
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public SKIN_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wSkin Menu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_SKIN_Menu");

	formatex(TempString, sizeof(TempString), "\rBicak Menu ^n");
	menu_additem(menu, TempString, "-1");

	formatex(TempString, sizeof(TempString), "\yAK47");
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "\yAWP");
	menu_additem(menu, TempString, "3");
	
	formatex(TempString, sizeof(TempString), "\yDEAGLE");
	menu_additem(menu, TempString, "4");

	formatex(TempString, sizeof(TempString), "\yGALIL");
	menu_additem(menu, TempString, "7");

	formatex(TempString, sizeof(TempString), "\yGLOCK");
	menu_additem(menu, TempString, "8");

	formatex(TempString, sizeof(TempString), "\yM4A1");
	menu_additem(menu, TempString, "9");

	formatex(TempString, sizeof(TempString), "\yM4A4");
	menu_additem(menu, TempString, "10");

	formatex(TempString, sizeof(TempString), "\yP90");
	menu_additem(menu, TempString, "11");

	formatex(TempString, sizeof(TempString), "\yUSP");
	menu_additem(menu, TempString, "13");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_SKIN_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	switch(Numara)
	{
		case -1: BICAK_Menu(id);
		case 1: AK47_Menu(id);
		case 3: AWP_Menu(id);
		case 4: DEAGLE_Menu(id);
		case 7: GALIL_Menu(id);
		case 8: GLOCK_Menu(id);
		case 9:
		{
			g_M4[id] = 0; // M4A1_Menu(id);
			iPlayerSkin[id][M4A1] = 0;

			static iWeapon;
	
			iWeapon = get_member(id, m_pActiveItem);
			
			if(!is_nullent2(iWeapon) && !g_isDead[id])
			{
				ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
				
			}
		} 
		case 10: M4A4_Menu(id);
		case 11: P90_Menu(id);
		case 13: USP_Menu(id);
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public USP_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wUsp Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_USP_Menu");

	for(new i; i < sizeof(USP_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(USP_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][USP] == str_to_num(USP_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", USP_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", USP_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", USP_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", USP_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, USP_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_USP_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(USP_MenuTitle[Num][1]);
	new level = str_to_num(USP_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3Usp ^1| ^4%s ^1Adli skin aktif edildi.", TAG, USP_MenuTitle[Numara][0]), iPlayerSkin[id][USP] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public P90_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wP90 Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_P90_Menu");

	for(new i; i < sizeof(P90_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(P90_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][P90] == str_to_num(P90_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", P90_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", P90_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", P90_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", P90_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_P90_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(P90_MenuTitle[Num][1]);
	new level = str_to_num(P90_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3P90 ^1| ^4%s ^1Adli skin aktif edildi.", TAG, P90_MenuTitle[Numara][0]), iPlayerSkin[id][P90] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public M4A4_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wM4A4 Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_M4A4_Menu");

	for(new i; i < sizeof(M4A4_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(M4A4_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][M4A4] == str_to_num(M4A4_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", M4A4_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", M4A4_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", M4A4_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", M4A4_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_M4A4_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(M4A4_MenuTitle[Num][1]);
	new level = str_to_num(M4A4_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3M4A4 ^1| ^4%s ^1Adli skin aktif edildi.", TAG, M4A4_MenuTitle[Numara][0]), iPlayerSkin[id][M4A4] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	g_M4[id] = 1;

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public M4A1_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wM4A1-S Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_M4A1_Menu");

	for(new i; i < sizeof(M4A1_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(M4A1_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][M4A1] == str_to_num(M4A1_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", M4A1_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", M4A1_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", M4A1_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", M4A1_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_M4A1_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(M4A1_MenuTitle[Num][1]);
	new level = str_to_num(M4A1_MenuTitle[Numara][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3M4A1-S ^1| ^4%s ^1Adli skin aktif edildi.", TAG, M4A1_MenuTitle[Numara][0]), iPlayerSkin[id][M4A1] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	g_M4[id] = 0;

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public GLOCK_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wGlock Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_GLOCK_Menu");

	for(new i; i < sizeof(GLOCK_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(GLOCK_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][GLOCK] == str_to_num(GLOCK_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", GLOCK_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", GLOCK_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", GLOCK_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", GLOCK_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_GLOCK_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(GLOCK_MenuTitle[Num][1]);
	new level = str_to_num(GLOCK_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3Glock-18 ^1| ^4%s ^1Adli skin aktif edildi.", TAG, GLOCK_MenuTitle[Numara][0]), iPlayerSkin[id][GLOCK] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public GALIL_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wGalil Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_GALIL_Menu");

	for(new i; i < sizeof(GALIL_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));
		num = str_to_num(GALIL_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][GALIL] == str_to_num(GALIL_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", GALIL_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", GALIL_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", GALIL_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", GALIL_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_GALIL_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(GALIL_MenuTitle[Num][1]);
	new level = str_to_num(GALIL_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3Galil ^1| ^4%s ^1Adli skin aktif edildi.", TAG, GALIL_MenuTitle[Numara][0]), iPlayerSkin[id][GALIL] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public DEAGLE_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wDeagle Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_DEAGLE_Menu");

	for(new i; i < sizeof(DEAGLE_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));

		num = str_to_num(DEAGLE_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));

		if(iPlayerSkin[id][DEAGLE] == str_to_num(DEAGLE_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", DEAGLE_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", DEAGLE_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", DEAGLE_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", DEAGLE_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_DEAGLE_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Num = str_to_num(data);
	new Numara = str_to_num(DEAGLE_MenuTitle[Num][1]);
	new level = str_to_num(DEAGLE_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3Deagle ^1| ^4%s ^1Adli skin aktif edildi.", TAG, DEAGLE_MenuTitle[Numara][0]), iPlayerSkin[id][DEAGLE] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public AWP_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wAwp Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_AWP_Menu");

	for(new i; i < sizeof(AWP_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));

		num = str_to_num(AWP_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		if(iPlayerSkin[id][AWP] == str_to_num(AWP_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", AWP_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", AWP_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", AWP_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", AWP_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_AWP_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(AWP_MenuTitle[Num][1]);
	new level = str_to_num(AWP_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3AWP ^1| ^4%s ^1Adli skin aktif edildi.", TAG, AWP_MenuTitle[Numara][0]), iPlayerSkin[id][AWP] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public AK47_Menu(const id)
{
	static TempString[512], gRank[32], STR[8], num;
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wAK47 Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_AK47_Menu");

	for(new i; i < sizeof(AK47_MenuTitle); i++)
	{
		num_to_str(i, STR, charsmax(STR));

		num = str_to_num(AK47_MenuTitle[i][2]);
		get_rankname(num, gRank, charsmax(gRank));
		
		if(iPlayerSkin[id][AK47] == str_to_num(AK47_MenuTitle[i][1])) {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\d%s", AK47_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\d%s \d| \d%s", AK47_MenuTitle[i][0], gRank);
			}
		}
		else {
			if(num == 0) {
				formatex(TempString, charsmax(TempString), "\y%s", AK47_MenuTitle[i][0]);
			}
			else {
				formatex(TempString, charsmax(TempString), "\y%s \d| \r%s", AK47_MenuTitle[i][0], gRank);
			}
		}

		menu_additem(menu, TempString, STR);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_AK47_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);

	new Num = str_to_num(data);
	new Numara = str_to_num(AK47_MenuTitle[Num][1]);
	new level = str_to_num(AK47_MenuTitle[Num][2]);

	if(get_user_level(id) >= level) client_print_color(id, print_team_red, "^1[^4%s^1] ^3AK47 ^1| ^4%s ^1Adli skin aktif edildi.", TAG, AK47_MenuTitle[Num][0]), iPlayerSkin[id][AK47] = Numara;
	else client_print_color(id, print_team_red, "^1[^4%s^1] ^3Yeterli Rutbeye Sahip degilsin!", TAG);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public BICAK_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wBicak Menu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_BicakMenu");

	formatex(TempString, sizeof(TempString), "\yClassic Knife");
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "\yBayonet");
	menu_additem(menu, TempString, "2");

	formatex(TempString, sizeof(TempString), "\yBowie");
	menu_additem(menu, TempString, "3");
	
	formatex(TempString, sizeof(TempString), "\yButterfly");
	menu_additem(menu, TempString, "4");

	formatex(TempString, sizeof(TempString), "\yFlip");
	menu_additem(menu, TempString, "5");

	formatex(TempString, sizeof(TempString), "\yKarambit");
	menu_additem(menu, TempString, "7");

	formatex(TempString, sizeof(TempString), "\yM9 Bayonet");
	menu_additem(menu, TempString, "8");

	formatex(TempString, sizeof(TempString), "\yTalon");
	menu_additem(menu, TempString, "10");

	formatex(TempString, sizeof(TempString), "\yStiletto");
	menu_additem(menu, TempString, "11");

	formatex(TempString, sizeof(TempString), "\yParacord");
	menu_additem(menu, TempString, "12");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_BicakMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	switch(Numara)
	{
		case 1: CLASSIC_Knife(id);
		case 2: BAYONET_KNIFE(id);
		case 3: BOWIE_KNIFE(id);
		case 4: BUTTERFLY_KNIFE(id);
		case 5: FLIP_KNIFE(id);
		case 7: KARAMBIT_KNIFE(id);
		case 8: M9BAYONET_KNIFE(id);
		case 10: TALON_KNIFE(id);
		case 11: STILETTO_KNIFE(id);
		case 12: PARACORD_KNIFE(id);
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public PARACORD_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wStiletto Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_PARACORDMenu");

	for(new i; i < sizeof(PARACORD_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == PARACORD && iPlayerKnife[id][PARACORD] == i) formatex(TempString, charsmax(TempString), "\d%s", PARACORD_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", PARACORD_MenuTitle[i][0]);
		menu_additem(menu, TempString, PARACORD_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_PARACORDMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = PARACORD;
	iPlayerKnife[id][PARACORD] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Paracord ^1| ^4%s ^1Adli skin aktif edildi.", TAG, PARACORD_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public STILETTO_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wStiletto Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_STILETTOMenu");

	for(new i; i < sizeof(STILETTO_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == STILETTO && iPlayerKnife[id][STILETTO] == i) formatex(TempString, charsmax(TempString), "\d%s", STILETTO_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", STILETTO_MenuTitle[i][0]);
		menu_additem(menu, TempString, STILETTO_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_STILETTOMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = STILETTO;
	iPlayerKnife[id][STILETTO] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Stiletto ^1| ^4%s ^1Adli skin aktif edildi.", TAG, STILETTO_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public TALON_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wTalon Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_TALONMenu");

	for(new i; i < sizeof(TALON_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == TALON && iPlayerKnife[id][TALON] == i) formatex(TempString, charsmax(TempString), "\d%s", TALON_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", TALON_MenuTitle[i][0]);
		menu_additem(menu, TempString, TALON_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_TALONMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = TALON;
	iPlayerKnife[id][TALON] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Talon ^1| ^4%s ^1Adli skin aktif edildi.", TAG, TALON_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public M9BAYONET_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wM9 Bayonet Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_M9BAYONETMenu");

	for(new i; i < sizeof(M9BAYONET_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == M9BAYONET && iPlayerKnife[id][M9BAYONET] == i) formatex(TempString, charsmax(TempString), "\d%s", M9BAYONET_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", M9BAYONET_MenuTitle[i][0]);
		menu_additem(menu, TempString, M9BAYONET_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_M9BAYONETMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = M9BAYONET;
	iPlayerKnife[id][M9BAYONET] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3M9 Bayonet ^1| ^4%s ^1Adli skin aktif edildi.", TAG, M9BAYONET_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public KARAMBIT_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wKarambit Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_KARAMBITMenu");

	for(new i; i < sizeof(KARAMBIT_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == KARAMBIT && iPlayerKnife[id][KARAMBIT] == i) formatex(TempString, charsmax(TempString), "\d%s", KARAMBIT_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", KARAMBIT_MenuTitle[i][0]);
		menu_additem(menu, TempString, KARAMBIT_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_KARAMBITMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = KARAMBIT;
	iPlayerKnife[id][KARAMBIT] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Karambit ^1| ^4%s ^1Adli skin aktif edildi.", TAG, KARAMBIT_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public FLIP_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wFlip Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_FLIPMenu");

	for(new i; i < sizeof(FLIP_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == FLIP && iPlayerKnife[id][FLIP] == i) formatex(TempString, charsmax(TempString), "\d%s", FLIP_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", FLIP_MenuTitle[i][0]);
		menu_additem(menu, TempString, FLIP_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_FLIPMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = FLIP;
	iPlayerKnife[id][FLIP] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Flip ^1| ^4%s ^1Adli skin aktif edildi.", TAG, FLIP_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public BUTTERFLY_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wButterfly Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_ButterflyMenu");

	for(new i; i < sizeof(BUTTERFLY_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == BUTTERFLY && iPlayerKnife[id][BUTTERFLY] == i) formatex(TempString, charsmax(TempString), "\d%s", BUTTERFLY_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", BUTTERFLY_MenuTitle[i][0]);
		menu_additem(menu, TempString, BUTTERFLY_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_ButterflyMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = BUTTERFLY;
	iPlayerKnife[id][BUTTERFLY] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Butterfly ^1| ^4%s ^1Adli skin aktif edildi.", TAG, BUTTERFLY_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public BOWIE_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wBowie Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_BOWIEMenu");

	for(new i; i < sizeof(BOWIE_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == BOWIE && iPlayerKnife[id][BOWIE] == i) formatex(TempString, charsmax(TempString), "\d%s", BOWIE_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", BOWIE_MenuTitle[i][0]);
		menu_additem(menu, TempString, BOWIE_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_BOWIEMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = BOWIE;
	iPlayerKnife[id][BOWIE] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Bowie ^1| ^4%s ^1Adli skin aktif edildi.", TAG, BOWIE_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public BAYONET_KNIFE(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wBayonet Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_BAYONETMenu");

	for(new i; i < sizeof(BAYONET_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == BAYONET && iPlayerKnife[id][BAYONET] == i) formatex(TempString, charsmax(TempString), "\d%s", BAYONET_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", BAYONET_MenuTitle[i][0]);
		menu_additem(menu, TempString, BAYONET_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_BAYONETMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = BAYONET;
	iPlayerKnife[id][BAYONET] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Bayonet ^1| ^4%s ^1Adli skin aktif edildi.", TAG, BAYONET_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public CLASSIC_Knife(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wClassic Knife Skin", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_CLASSICMenu");

	for(new i; i < sizeof(KNIFE_MenuTitle); i++)
	{
		if(iPlayerKnifeA[id] == Default && iPlayerKnife[id][Default] == i) formatex(TempString, charsmax(TempString), "\d%s", KNIFE_MenuTitle[i][0]);
		else formatex(TempString, charsmax(TempString), "\y%s", KNIFE_MenuTitle[i][0]);
		menu_additem(menu, TempString, KNIFE_MenuTitle[i][1]);
	}

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_CLASSICMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	iPlayerKnifeA[id] = Default;
	iPlayerKnife[id][Default] = Numara;
	client_print_color(id, print_team_red, "^1[^4%s^1] ^3Classic Knife ^1| ^4%s ^1Adli skin aktif edildi.", TAG, KNIFE_MenuTitle[Numara][0]);

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public Eldiven_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wEldiven Menu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_EldivenMenu");
	
	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 0 ? "\dDriver \d| \dCrimson Weave" : "\yDriver \d| \yCrimson Weave");
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 1 ? "\dDriver \d| \dImperial Plaid" : "\yDriver \d| \yImperial Plaid");
	menu_additem(menu, TempString, "2");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 2 ? "\dDriver \d| \dKing Snake" : "\yDriver \d| \yKing Snake");
	menu_additem(menu, TempString, "3");
	
	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 3 ? "\dSport \d| \dBronze" : "\ySport \d| \yBronze");
	menu_additem(menu, TempString, "4");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 4 ? "\dSport \d| \dPandora's Box" : "\ySport \d| \yPandora's Box");
	menu_additem(menu, TempString, "5");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 5 ? "\dSport \d| \dOmega" : "\ySport \d| \yOmega");
	menu_additem(menu, TempString, "6");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 6 ? "\dSport \d| \dAztec Green" : "\ySport \d| \yAztec Green");
	menu_additem(menu, TempString, "7");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 7 ? "\dSport \d| \dAmphibious" : "\ySport \d| \yAmphibious");
	menu_additem(menu, TempString, "8");

	formatex(TempString, sizeof(TempString), "%s", iPlayerGlove[id] == 8 ? "\dSport \d| \dVice" : "\ySport \d| \yVice");
	menu_additem(menu, TempString, "9");

	formatex(TempString, sizeof(TempString), "\wCikis");
	menu_additem(menu, TempString, "0");

	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	menu_setprop(menu, MPROP_PERPAGE, 0);
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_EldivenMenu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);

	if(Numara) iPlayerGlove[id] = Numara - 1;
	switch(Numara)
	{
		case 1: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Driver ^1| ^4Crimson Weave ^1Adli eldiven aktif edildi.", TAG);
		case 2: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Driver ^1| ^4Imperial Plaid ^1Adli eldiven aktif edildi.", TAG);
		case 3: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Driver ^1| ^4King Snake ^1Adli eldiven aktif edildi.", TAG);
		case 4: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Bronze ^1Adli eldiven aktif edildi.", TAG);
		case 5: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Pandora ^1Adli eldiven aktif edildi.", TAG);
		case 6: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Omega ^1Adli eldiven aktif edildi.", TAG);
		case 7: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Aztec Green ^1Adli eldiven aktif edildi.", TAG);
		case 8: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Amphibious ^1Adli eldiven aktif edildi.", TAG);
		case 9: client_print_color(id, print_team_red, "^1[^4%s^1] ^3Sport ^1| ^4Vice ^1Adli eldiven aktif edildi.", TAG);
		case 0: return PLUGIN_CONTINUE;
	}

	static iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(!is_nullent2(iWeapon) && !g_isDead[id])
	{
		ExecuteHamB(Ham_Item_Deploy, iWeapon);	//Will give and error while dead
	}

	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public Gorus_Menu(const id)
{
	static TempString[512];
	
	formatex(TempString, sizeof(TempString), "\y%s \d| \wGorus Menu", TAG2);
	static menu; menu = menu_create(TempString, "MenuHandle_Gorus_Menu");
	
	formatex(TempString, sizeof(TempString), "\yNormal(Default)", TAG);
	menu_additem(menu, TempString, "1");

	formatex(TempString, sizeof(TempString), "\yUzak", TAG);
	menu_additem(menu, TempString, "2");
	
	formatex(TempString, sizeof(TempString), "\yDaha Uzak", TAG);
	menu_additem(menu, TempString, "3");
	
	menu_setprop(menu, MPROP_NUMBER_COLOR, "\r" );
	
	menu_display(id, menu);
	return PLUGIN_HANDLED;
}

public MenuHandle_Gorus_Menu(const id, const menu, const item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new data[6], name[32], access, callback;
	menu_item_getinfo(menu, item, access, data, charsmax(data), name, charsmax(name), callback);
	new Numara = str_to_num(data);
	
	switch(Numara)
	{
		case 1:
		{
			g_fov[id] = 90;
		}
		case 2:
		{
			g_fov[id] = 100;
		}
		case 3:
		{
			g_fov[id] = 105;
		}
	}

	if(!g_isDead[id])
	{
		Event_CurWeapon(id);
		Msg_SetFOV(id, g_fov[id]);
	}
	
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public Crosshair_Menu2(const id)
{
	static Item[128], Str[12];
	
	formatex(Item, charsmax(Item), "\y%s \d| \wCrosshair Menu", TAG2);
	new Menu = menu_create(Item, "Crosshair_Menu_Handler");

	for(new i = 0; i < sizeof(Sprites); i++)
	{
		num_to_str(i, Str, 11);
		formatex(Item, charsmax(Item), "\y%s", Sprites[i][0]);
		menu_additem(Menu, Item, Str);
	}
	
	menu_setprop(Menu, MPROP_NUMBER_COLOR, "\r" );
	menu_display(id, Menu);
	return PLUGIN_HANDLED;
}

public Crosshair_Menu_Handler(const id, const Menu, const Item)
{
	if(Item == MENU_EXIT)
	{
		menu_destroy(Menu);
		return PLUGIN_HANDLED;
	}
	
	new Data[6], Name[64];
	new Access, CallBack;
	menu_item_getinfo(Menu, Item, Access, Data, 5, Name, 63, CallBack);
	
	new Key = str_to_num(Data);

	Crosshair[id] = Key;
	
	client_print_color(id, print_team_red, "^1[^4%s^1] ^4%s ^1| ^3Crosshair Aktif Edildi.", TAG, Sprites[Key][0]);

	//client_cmd(id, "lastinv;wait;wait;wait;wait;wait;wait;wait;wait;lastinv");

	client_cmd(id, "crosshair ^"1^"");
	
	Event_CurWeapon(id);
	return PLUGIN_HANDLED;
}

public Event_CurWeapon(id)
{
	if(g_isDead[id] || !is_user_valid(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;

	static Weapon_ID, Primary, iEntity, WeaponIdType:get_weapon, Sprite_TxT[52];
	Weapon_ID = get_user_weapon(id, Primary);
	iEntity = get_member(id, m_pActiveItem);
	get_weapon = rg_get_weapon(iEntity);
	
	if(is_nullent2(iEntity))
	{
		//client_print_color(id, print_team_red, "a");
		return PLUGIN_CONTINUE;
	}
	
	if(get_weapon == WEAPON_SCOUT || get_weapon == WEAPON_AWP)
	{
		return PLUGIN_HANDLED;
	}
	else
	{
		Hide_Crosshair(id);
		formatex(Sprite_TxT, charsmax(Sprite_TxT), "%s", Sprites[Crosshair[id]][2]);
		
		switch(Weapon_ID)
		{
			case WEAPON_AWP, WEAPON_SCOUT: return PLUGIN_HANDLED;
			case WEAPON_P228 : Msg_WeaponList(id, Sprite_TxT,9,52,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_HEGRENADE : Msg_WeaponList(id, Sprite_TxT,12,1,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_XM1014 : Msg_WeaponList(id, Sprite_TxT,5,32,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_C4 : Msg_WeaponList(id, Sprite_TxT,14,1,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_MAC10 : Msg_WeaponList(id, Sprite_TxT,6,100,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_AUG : 
			{
				if(g_Zoom[id]) Msg_WeaponList(id, augsg_nokta,4,90,-1,-1,0,11,CSW_SHIELD ,0);
				else if(!g_Zoom[id]) Msg_WeaponList(id, Sprite_TxT,4,90,-1,-1,0,11,CSW_SHIELD ,0);
			}
			case WEAPON_SMOKEGRENADE : Msg_WeaponList(id, Sprite_TxT,13,1,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_ELITE : Msg_WeaponList(id, Sprite_TxT,10,120,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_FIVESEVEN : Msg_WeaponList(id, Sprite_TxT,7,100,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_UMP45 : Msg_WeaponList(id, Sprite_TxT,6,100,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_GALIL : Msg_WeaponList(id, Sprite_TxT,4,90,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_FAMAS : Msg_WeaponList(id, Sprite_TxT,4,90,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_USP : Msg_WeaponList(id, Sprite_TxT,6,100,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_GLOCK18 : Msg_WeaponList(id, Sprite_TxT,10,120,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_MP5N : Msg_WeaponList(id, Sprite_TxT,10,120,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_M249 : Msg_WeaponList(id, Sprite_TxT,3,200,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_M3 : Msg_WeaponList(id, Sprite_TxT,5,32,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_M4A1 : Msg_WeaponList(id, Sprite_TxT,4,90,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_TMP : Msg_WeaponList(id, Sprite_TxT,10,120,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_FLASHBANG : Msg_WeaponList(id, Sprite_TxT,11,2,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_DEAGLE : Msg_WeaponList(id, Sprite_TxT,8,35,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_SG552 : 
			{
				if(g_Zoom[id]) Msg_WeaponList(id, augsg_nokta,4,90,-1,-1,0,11,CSW_SHIELD ,0);
				else if(!g_Zoom[id]) Msg_WeaponList(id, Sprite_TxT,4,90,-1,-1,0,11,CSW_SHIELD ,0);
			}
			case WEAPON_AK47 : Msg_WeaponList(id, Sprite_TxT,2,90,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_KNIFE : Msg_WeaponList(id, Sprite_TxT,-1,-1,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
			case WEAPON_P90 : Msg_WeaponList(id, Sprite_TxT,7,100,-1,-1,0,11,CSW_SHIELD ,0), g_Zoom[id] = 0;
		}

		Msg_SetFOV(id, 89);
		Msg_CurWeapon(id, 1, CSW_SHIELD, Primary);
		if(!g_Zoom[id]) Msg_SetFOV(id, g_fov[id]);
		else if(g_Zoom[id]) Msg_SetFOV(id, 50);
	}
	
	return PLUGIN_CONTINUE;
}

public LookWeapon(id)
{
	if(!is_user_valid(id) || g_isDead[id] || !is_user_connected(id)) return HC_CONTINUE;

	static iEntity, fInReload, WeaponIdType:get_weapon;
	
	iEntity = get_member(id, m_pActiveItem);
	fInReload = get_member(iEntity, m_Weapon_fInReload);
	get_weapon = rg_get_weapon(iEntity);
	
	if(is_nullent2(iEntity) || fInReload) return HC_CONTINUE;

	if(get_member(id, m_bResumeZoom)) Msg_SetFOV(id, g_fov[id]);
				
	if(get_entvar(id, var_impulse) == 100)
	{
		if(get_gametime() > g_LookTime[id])
		{
			switch(get_weapon)
			{
				case WEAPON_C4, WEAPON_FLASHBANG, WEAPON_HEGRENADE, WEAPON_SMOKEGRENADE: return HC_CONTINUE;
				default: PlayWeaponState(id, GetWeaponInspect(iEntity));
			}
			set_member(iEntity, m_Weapon_flTimeWeaponIdle, 8.0);

			g_LookTime[id] = get_gametime() + 8.0;
		}
	}

	if(get_member(id, m_afButtonPressed) & IN_ATTACK2)
	{
		switch(get_weapon)
		{
			case WEAPON_AUG, WEAPON_SG552:
			{
				if(get_gametime() > g_ZoomTime[id])
				{
					if(g_Zoom[id]) UnScope(id);
					else Scope(id);

					g_ZoomTime[id] = get_gametime() + 0.1;
				}
			}
			/*case WEAPON_AWP, WEAPON_SCOUT:
			{
				if(get_member(id, m_iFOV) > 40) Msg_SetFOV(id, g_fov[id]);
			}*/
			case WEAPON_M4A1, WEAPON_USP: set_member(iEntity, m_Weapon_flNextSecondaryAttack, 9999.9);
			default: return HC_CONTINUE;
		}
	}

	if(get_member(id, m_afButtonPressed) & IN_RELOAD)
	{
		switch(get_weapon)
		{
			case WEAPON_AUG, WEAPON_SG552:
			{
				if(g_Zoom[id])
					UnScope(id);
			}
			default:
			{
				g_LookTime[id] = 0.0;
				return HC_CONTINUE;
			}
		}
	}

	return HC_CONTINUE;
}

public Scope(id)
{
	if(g_isDead[id] || !is_user_connected(id))
	{
		g_Zoom[id] = 0;
		return;
	}
	g_Zoom[id] = 1;

	static WeaponIdType:wep_id, iWeapon;
	
	iWeapon = get_member(id, m_pActiveItem);
	
	if(is_nullent2(iWeapon)) return;
	wep_id = rg_get_weapon(iWeapon); //WEAPON_ENT(iWeapon);

	switch(wep_id)
	{
		case WEAPON_AUG: set_entvar(id, var_viewmodel, AUG_SCOPE);
		case WEAPON_SG552: set_entvar(id, var_viewmodel, SIG_SCOPE);
	}

	Event_CurWeapon(id);
}

public UnScope(id)
{
	if(g_isDead[id] || !is_user_connected(id) || g_Zoom[id] == 0)
	{
		g_Zoom[id] = 0;
		return;
	}
	g_Zoom[id] = 0;

	static pEntity, WeaponIdType:wep_id;
	
	pEntity = get_member(id, m_pActiveItem);
	if(is_nullent2(pEntity)) return;
	wep_id = rg_get_weapon(pEntity); //WEAPON_ENT(pEntity);

	switch(wep_id)
	{
		case WEAPON_KNIFE:
		{
			set_entvar(id, var_viewmodel, g_KnifeModels[iPlayerKnifeA[id]]);
			ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerKnife[id][iPlayerKnifeA[id]]));
		}

		case WEAPON_M4A1:
		{
			switch(g_M4[id])
			{
				case 0: set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) | WPNSTATE_M4A1_SILENCED);
				case 1: set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) &~ WPNSTATE_M4A1_SILENCED);
			}

			set_member(pEntity, m_Weapon_flNextSecondaryAttack, 9999.9);
			set_entvar(id, var_viewmodel, g_M4Models[g_M4[id]]);
			ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerSkin[id][WeaponSkinID(id, pEntity)]));
		}
		case WEAPON_USP:
		{
			set_member(pEntity, m_Weapon_iWeaponState, get_member(pEntity, m_Weapon_iWeaponState) | WPNSTATE_USP_SILENCED);
			set_member(pEntity, m_Weapon_flNextSecondaryAttack, 9999.9);
			set_entvar(id, var_viewmodel, g_NewModels[get_member(pEntity, m_iId)]);
			ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerSkin[id][WeaponSkinID(id, pEntity)] == 0 ? 0 : iPlayerSkin[id][WeaponSkinID(id, pEntity)]));
		}
		default:
		{
			set_entvar(id, var_viewmodel, g_NewModels[get_member(pEntity, m_iId)]);
			ViewBodySwitch(id, GetBodyIndex(id, iPlayerGlove[id], iPlayerSkin[id][WeaponSkinID(id, pEntity)] == 0 ? 0 : iPlayerSkin[id][WeaponSkinID(id, pEntity)]));
		}
	}

	Event_CurWeapon(id);
}

public CBasePlayer_AddPlayerItem(const pPlayer, const pItem) {
	if(is_entity(pItem) && !g_isDead[pPlayer] && is_user_connected(pPlayer))
	{
		static WeaponIdType:CSWID; CSWID = rg_get_weapon(pItem); //WEAPON_ENT(pItem);
		switch(CSWID)
		{
			case WEAPON_M4A1:
			{
				switch(g_M4[pPlayer])
				{
					case 0: set_member(pItem, m_Weapon_iWeaponState, get_member(pItem, m_Weapon_iWeaponState) | WPNSTATE_M4A1_SILENCED);
					case 1: set_member(pItem, m_Weapon_iWeaponState, get_member(pItem, m_Weapon_iWeaponState) &~ WPNSTATE_M4A1_SILENCED);
				}

				set_member(pItem, m_Weapon_flNextSecondaryAttack, 9999.9);
			}
			case WEAPON_USP:
			{
				set_member(pItem, m_Weapon_iWeaponState, get_member(pItem, m_Weapon_iWeaponState) | WPNSTATE_USP_SILENCED);
				set_member(pItem, m_Weapon_flNextSecondaryAttack, 9999.9);
			}
			case WEAPON_AWP:
			{
				message_begin(MSG_ONE, get_user_msgid("WeaponList"), _, pPlayer);
				write_string("awp_scope_custom");
				write_byte(1);
				write_byte(30);
				write_byte(-1);
				write_byte(-1);
				write_byte(0);
				write_byte(2);
				write_byte(get_member(pItem, m_iId));
				write_byte(0);
				message_end();

				emessage_begin(MSG_ONE, get_user_msgid("CurWeapon"), _, pPlayer);
				ewrite_byte(1);
				ewrite_byte(get_member(pItem, m_iId));
				ewrite_byte(rg_get_weapon_info(get_member(pItem, m_iId), WI_GUN_CLIP_SIZE));
				emessage_end();
			}
			case WEAPON_SCOUT:
			{
				message_begin(MSG_ONE, get_user_msgid("WeaponList"), _, pPlayer);
				write_string("scout_scope_custom");
				write_byte(2);
				write_byte(90);
				write_byte(-1);
				write_byte(-1);
				write_byte(0);
				write_byte(9);
				write_byte(get_member(pItem, m_iId));
				write_byte(0);
				message_end();

				emessage_begin(MSG_ONE, get_user_msgid("CurWeapon"), _, pPlayer);
				ewrite_byte(1);
				ewrite_byte(get_member(pItem, m_iId));
				ewrite_byte(rg_get_weapon_info(get_member(pItem, m_iId), WI_GUN_CLIP_SIZE));
				emessage_end();
			}
		}
	}
}

public Hook_weapon_awp(id) { 
	engclient_cmd(id, "weapon_awp");
	return PLUGIN_HANDLED;
}

public Hook_weapon_scout(id) { 
	engclient_cmd(id, "weapon_scout");
	return PLUGIN_HANDLED;
}

public message()
{
	if(get_msg_args() != 5 || get_msg_argtype(3) != ARG_STRING || get_msg_argtype(5) != ARG_STRING)
	{
		return PLUGIN_CONTINUE;
	}

	new arg2[16];
	get_msg_arg_string(3, arg2, 15);
	if(equal(arg2, "#Game_radio"))
	{
		return PLUGIN_HANDLED;
	}
	
	new arg4[20];
	get_msg_arg_string(5, arg4, 19);
	if(equal(arg4, "#Fire_in_the_hole"))
		return PLUGIN_HANDLED;
	
	return PLUGIN_CONTINUE;
}

public msg_audio()
{
	if(get_msg_args() != 3 || get_msg_argtype(2) != ARG_STRING) {
		return PLUGIN_CONTINUE;
	}

	new arg2[20];
	get_msg_arg_string(2, arg2, 19);
	if(equal(arg2[1], "!MRAD_FIREINHOLE"))
	{
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;
}

public radio(id)
{
	if(g_isDead[id]) return PLUGIN_HANDLED;

	new key3 = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9);
	
	new menu_body3[512];
	new len3 = format(menu_body3,511,"\rRadio Commands^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "^n\ " );
	len3 += format( menu_body3[len3], 511-len3, "\w1. Hadi Hadi^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w2. Geri Cekil^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w3. Guzel^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w4. Olumsuz^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w5. Yardim Lazim^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w6. Tesekkur Ederim^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w7. Bolge Temiz^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w8. Dikkat Keskin Nisanci^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "\w9. Sevinc^n\ ");
	len3 += format( menu_body3[len3], 511-len3, "^n\ " );
	len3 += format( menu_body3[len3], 511-len3, "\w0. Exit");
	
	show_menu(id,key3,menu_body3);
	return PLUGIN_HANDLED;
} 

public radiocmd(id, key3)
{
	if(g_isDead[id]) return PLUGIN_HANDLED;
	if(g_RadioTimer[id]) return PLUGIN_HANDLED;

	new iReceiverTeam;
	new iSenderTeam = get_member(id, m_iTeam);
	new ResourcePath[32+(2*32)];

	for(new i = 1; i <= maxplayer; i++)
	{
		if(!is_user_connected(i) || !is_user_valid(i))
		{
			continue;
		}
		
		iReceiverTeam = get_member(i, m_iTeam);

		if(iReceiverTeam != iSenderTeam && any:iReceiverTeam != TEAM_SPECTATOR) {
			continue;
		}

		switch(key3)
		{
			case 0:
			{
				client_print(i, print_chat, "%n (RADIO): Hadi Hadi", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 1:
			{
				client_print(i, print_chat, "%n (RADIO): Geri Cekil", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 2:
			{
				client_print(i, print_chat, "%n (RADIO): Guzel", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 3:
			{
				client_print(i, print_chat, "%n (RADIO): Olumsuz", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 4:
			{
				client_print(i, print_chat, "%n (RADIO): Yardim Lazim", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 5:
			{
				client_print(i, print_chat, "%n (RADIO): Tesekkur Ederim", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 6:
			{
				client_print(i, print_chat, "%n (RADIO): Bolge Temiz", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 7:
			{
				client_print(i, print_chat, "%n (RADIO): Dikkat Keskin Nisanci", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			case 8:
			{
				client_print(i, print_chat, "%n (RADIO): Sevinc", id);
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[id][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_RADIO[key3+18]);
					} 
				}
				else
				{
					switch(g_PlayerAgent[id][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+9]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_RADIO[key3+18]);
					}
				}
			}
			default: return PLUGIN_HANDLED;
		}
		rg_send_audio(i, ResourcePath);
	}

	g_RadioTimer[id] = true;
	set_task(4.5, "RadioTimer", id);

	return PLUGIN_HANDLED;
}

public RadioTimer(id) {
	g_RadioTimer[id] = false;
	return PLUGIN_HANDLED;
}

public Radio_Pre(pSender, szMsgID[], szMsgVerbose[]) {
	if(szMsgVerbose[0] == EOS || !equal(szMsgVerbose, "#Fire_in_the_hole")) {
		return HC_SUPERCEDE;
	}

	new iReceiverTeam;
	new iSenderTeam = get_member(pSender, m_iTeam);
	new WeaponIdType:pGrenade = rg_get_user_weapon(pSender);
	new ResourcePath[32+(2*32)];
	
	for(new i = 1; i <= maxplayer; i++) {
		if(get_member(i, m_bIgnoreRadio)) {
			continue;
		}
		
		iReceiverTeam = get_member(i, m_iTeam);
		
		if(iReceiverTeam != iSenderTeam && any:iReceiverTeam != TEAM_SPECTATOR) {
			continue;
		}

		switch(pGrenade) {
			case WEAPON_HEGRENADE: {
				client_print(i, print_chat, "%n (RADIO): Patlayici Bomba Atiyorum!", pSender);

				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[pSender][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[0]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[3]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[6]);
					}
				}
				else
				{
					switch(g_PlayerAgent[pSender][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[0]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[3]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[3]);
					}
				}
			}
			case WEAPON_SMOKEGRENADE: {
				client_print(i, print_chat, "%n (RADIO): Sis Bombasi Atiyorum!", pSender);
				
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[pSender][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[2]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[5]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[8]);
					}
				}
				else
				{
					switch(g_PlayerAgent[pSender][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[2]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[5]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[8]);
					}
				}
			}
			case WEAPON_FLASHBANG: {
				client_print(i, print_chat, "%n (RADIO): Flash Bombasi Atiyorum!", pSender);
				
				if(any:iReceiverTeam == TEAM_TERRORIST)
				{
					switch(g_PlayerAgent[pSender][0])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[1]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[4]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", TERROR_THROWING[7]);
					}
				}
				else
				{
					switch(g_PlayerAgent[pSender][1])
					{
						case 0: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[1]);
						case 1: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[4]);
						case 2: formatex(ResourcePath, charsmax(ResourcePath), "%s", CT_THROWING[7]);
					}
				}
			}
			default: {
				return HC_CONTINUE;
			}
		}
		
		rg_send_audio(i, ResourcePath);
	}
	
	return HC_SUPERCEDE;
}

public fw_AddToFullPack_Post(es, e, ent, host, hostflags, player, pSet)
{
	if(!is_user_connected(host) || !is_user_valid(host))
		return FMRES_IGNORED;

	if(is_nullent2(ent))//!is_entity(ent))
		return FMRES_IGNORED;

	if(g_isDead[host])
		return FMRES_IGNORED;

	if(g_Zoom[host] == 1)
		return FMRES_IGNORED;
	
	static Ent_Classname[64], iEnt, WeaponIdType:get_weapon;
	get_entvar(ent, var_classname, Ent_Classname, charsmax(Ent_Classname));
	iEnt = get_member(host, m_pActiveItem);
	get_weapon = rg_get_weapon(iEnt);

	if(is_nullent2(iEnt))
		return FMRES_IGNORED;
	
	if(g_win != 2)
	{
		if (!strcmp(Ent_Classname, "screen_sprites"))
		{
			set_es(es, ES_MoveType, MOVETYPE_FOLLOW);
			set_es(es, ES_RenderMode, kRenderTransAlpha);
			set_es(es, ES_RenderAmt, 255);
			switch(get_weapon)
			{
				case WEAPON_KNIFE: set_es(es, ES_Body, 1);
				default: set_es(es, ES_Body, 3);
			}
			set_es(es, ES_Skin, host);
			set_es(es, ES_AimEnt, host);
			set_es(es, ES_Frame, float(g_win));
			if(g_fov[host] == 100) set_es(es, ES_Scale, 0.0325);
			else if(g_fov[host] == 105) set_es(es, ES_Scale, 0.0355);
			else set_es(es, ES_Scale, 0.0305);

			return FMRES_HANDLED;
		}
	}

	if (!strcmp(Ent_Classname, "wep_muzzleflash") && g_duman[host] != 1)
	{
		if(get_gametime() < Values[host][1])
		{
			switch(get_weapon)
			{
				case WEAPON_KNIFE: return FMRES_HANDLED;
				case WEAPON_ELITE:
				{
					if(get_entvar(host, var_weaponanim) == ELITE_SHOOTLEFT5) set_es(es, ES_Body, 1);
					else if(get_entvar(host, var_weaponanim) == ELITE_SHOOTRIGHT5) set_es(es, ES_Body, 2);
					set_es(es, ES_Scale, 0.08);
				}
				case WEAPON_GALIL: set_es(es, ES_Scale, 0.35), set_es(es, ES_Body, 1);
				case WEAPON_M4A1: if(g_M4[host] == 1) set_es(es, ES_Scale, 0.15), set_es(es, ES_Body, 1);
				default: set_es(es, ES_Body, 1);//, set_es(es, ES_Scale, 0.35)
			}

			set_es(es, ES_Skin, host);
			set_es(es, ES_AimEnt, host);
			set_es(es, ES_RenderAmt, 255);
			set_es(es, ES_Frame, Values[host][0]);
		}
		return FMRES_HANDLED;
	}

	return FMRES_IGNORED;
}

public fw_CheckVisibility(iEnt, pSet)
{
	static Ent_Classname[64];
	get_entvar(iEnt, var_classname, Ent_Classname, charsmax(Ent_Classname));

	if(!strcmp(Ent_Classname, "wep_muzzleflash") || !strcmp(Ent_Classname, "screen_sprites")) //  || !strcmp(Ent_Classname, "scoreboard_sprites") 
	{
		forward_return(FMV_CELL, 1);
		return FMRES_SUPERCEDE;
	}
	
	return FMRES_IGNORED;
}

public ViewBodySwitch(pPlayer, iValue)
{
	iBodyIndex[pPlayer] = iValue;
}

public CGrenade_DefuseBombStart(const this, const player)
{
	new team;
	
	if(get_gametime() > defuse_sesengel)
	{
		for(new id = 1; id <= maxplayer; id++)
		{
			if(!is_user_valid(id) || !is_user_connected(id)) continue;

			team = get_member(id, m_iTeam);

			if(any:team != TEAM_CT) continue;
			
			PlaySound(id, CT_DEFUSING_BOMB[g_PlayerAgent[player][1]]);
		}
		defuse_sesengel = get_gametime() + 5.0;
	}
}

public bomb_planting(planter) {
	new team;
	
	if(get_gametime() > planting_sesengel)
	{
		for(new id = 1; id <= maxplayer; id++)
		{
			if(!is_user_valid(id) || !is_user_connected(id)) continue;

			team = get_member(id, m_iTeam);

			if(any:team != TEAM_TERRORIST) continue;
			
			PlaySound(id, T_PLANTINGBOMB[g_PlayerAgent[planter][0]]);
		}
		planting_sesengel = get_gametime() + 5.0;
	}
}

native HaritaOyla();

public RoundEnd(WinStatus:status, ScenarioEventEndRound:event, Float:tmDelay)
{
	switch(event)
	{
		case ROUND_TERRORISTS_WIN, ROUND_CTS_WIN, ROUND_GAME_RESTART, ROUND_NONE, ROUND_BOMB_DEFUSED: for(new i; i < sizeof stopsound; i++) client_cmd(0, "mp3 stop %s", stopsound[i]);
		case ROUND_GAME_COMMENCE:
		{
			if(task_exists(1996)) remove_task(1996);
			iSeconds = g_warmtime++;
			set_task( 1.0, "TaskShowCountdown", 1996, _, _, "a", g_warmtime);
			g_warmup = true;
			set_task(float(g_warmtime), "WarmupEnd");
		}
	}

	remove_task(2000);

	switch(status)
	{
		case WINSTATUS_CTS: g_win = 1;
		case WINSTATUS_TERRORISTS: g_win = 0;
		default: g_win = 2;
	}

	for(new id = 1; id <= maxplayer; id++)
	{
		if(!is_user_connected(id) || !is_user_valid(id))
			continue;
		
		PlaySound(id, ROUND_SOUNDS[2]);
	}

	static tur; tur = get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins);

	if(tur == 30)
	{
		set_cvar_num("mp_round_infinite", 1);
		set_cvar_num("mp_freezetime", 100);

		HaritaOyla();
	}

	if(tur == 15)
	{
		set_task(1.0, "takimlari_degis", 1444);
	}
}

public TaskShowCountdown()
{
	set_dhudmessage( 255, 255, 255, 0.45, 0.21, 0, 1.0, 0.8, 0.5, 0.5 );
	show_dhudmessage( 0, "[ISINMA TURU]^n         %d", iSeconds-- );
	set_cvar_num("mp_round_infinite", 1);

	set_member_game(m_bCTCantBuy, true);
	set_member_game(m_bTCantBuy, true);
}

public WarmupEnd()
{
	g_warmup = false;
	set_cvar_num("mp_round_infinite", 0);
	set_cvar_num( "sv_restart", 1 );
	client_print_color(0, print_team_red, "^1[^4%s^1] ^3Isinma Sona Erdi.", TAG);
	client_print_color(0, print_team_red, "^1[^4%s^1] ^3Restart Atiliyor.", TAG);

	set_member_game(m_bCTCantBuy, false);
	set_member_game(m_bTCantBuy, false);
}

public takimlari_degis()
{
	new kayit, kayit2, team;
	for(new id = 1; id <= maxplayer; id++)
	{
		if(!is_user_connected(id) || !is_user_valid(id))
			continue;
		
		team = get_member(id, m_iTeam);

		if(any:team == TEAM_TERRORIST)
		{
			rg_set_user_team(id, TEAM_CT);
		}
		else if(any:team == TEAM_CT)
		{
			rg_set_user_team(id, TEAM_TERRORIST);
		}
	}

	client_print_color(0, print_team_red, "^1[^4%s^1] ^3Takimlar Degistiriliyor", TAG);
	client_print_color(0, print_team_red, "^1[^4%s^1] ^3Takimlar Degistiriliyor", TAG);
	client_print_color(0, print_team_red, "^1[^4%s^1] ^3Takimlar Degistiriliyor", TAG);

	kayit = get_member_game(m_iNumCTWins);
	kayit2 = get_member_game(m_iNumTerroristWins);

	set_member_game(m_iNumTerroristWins, kayit);
	set_member_game(m_iNumCTWins, kayit2);

	remove_task(1444);
}

public Message_TextMsg( const MsgId, const MsgDest, const id )
{
	new szMsg[ 192 ]; get_msg_arg_string( 2, szMsg, charsmax(szMsg) );

	if(equal(szMsg, "#Bomb_Planted"))
	{
		set_task(float(get_pcvar_num(pointnum) - 2), "C4_ExplodeSound", 2000);
		set_task(float(get_pcvar_num(pointnum) - 12), "C4_ExplodeSound2", 2000);

		for(new id = 1; id <= maxplayer; id++)
		{
			if(!is_user_connected(id) || !is_user_valid(id))
				continue;
			
			PlaySound(id, "csgonew4/bombplanted.mp3");
		}
	}

	return PLUGIN_CONTINUE;
}

public C4_ExplodeSound()
{
	for(new id = 1; id <= maxplayer; id++)
	{
		if(!is_user_connected(id) || !is_user_valid(id))
			continue;
		
		PlaySound(id, "csgonew4/arm_bomb.mp3");
	}
}

public C4_ExplodeSound2()
{
	for(new id = 1; id <= maxplayer; id++)
	{
		if(!is_user_connected(id) || !is_user_valid(id))
			continue;
		
		PlaySound(id, "csgonew4/bombtenseccount.mp3");
	}
}

public PlayerBlind(const index, const inflictor, const attacker, const Float:fadeTime, const Float:fadeHold, const alpha, Float:color[3])
{	
	client_cmd(index, "spk %s", SOUNDS2[0]);
	set_task(8.0, "seskes", index);
}

public seskes(id)
{
	client_cmd(id, "mp3 stop %s", SOUNDS2[0]);
}

public EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	if (sample[7] == 'd' && ((sample[8] == 'i' && sample[9] == 'e') || (sample[8] == 'e' && sample[9] == 'a')))
	{
		switch(get_member(id, m_iTeam))
		{
			case TEAM_TERRORIST :
			{
				rh_emit_sound2(id, 0, CHAN_STATIC, TERROR_DEATH[g_PlayerAgent[id][0]], volume, attn, flags, pitch);
			}
			case TEAM_CT :
			{
				rh_emit_sound2(id, 0, CHAN_STATIC, CT_DEATH[g_PlayerAgent[id][1]], volume, attn, flags, pitch);
			}
		}
		return FMRES_SUPERCEDE;
	}

	new i;
	for(i = 0; i < sizeof ESKISESLER; i++) {
		if(pev_valid(id))
		{
			if(equal(ESKISESLER[i], sample)) {
				if(i == 8)
				{
					if(iPlayerKnifeA[id] == BUTTERFLY)
					{
						rh_emit_sound2(id, 0, CHAN_STATIC, "weapons/silahseslerinew3/knife_deploy2.wav", volume, attn, flags, pitch);
					}
					else
					{
						rh_emit_sound2(id, 0, CHAN_STATIC, YENISESLER[i], volume, attn, flags, pitch);
					}
				}
				else
				{
					rh_emit_sound2(id, 0, CHAN_STATIC, YENISESLER[i], volume, attn, flags, pitch);
				}
				return FMRES_SUPERCEDE;
			}
		}
	}

	new ResourcePath[32+(2*32)];
	for (i = 0; i < sizeof Ses; i++)
	{ 
		if(i >= 59 && i < 144) formatex(ResourcePath, charsmax(ResourcePath), "player/%s.wav", Ses[i]);
		else formatex(ResourcePath, charsmax(ResourcePath), "weapons/%s.wav", Ses[i]);
		if(equal(sample, ResourcePath))  
		{
			return FMRES_SUPERCEDE; 
		} 
	}	

	if(equal(sample, "weapons/c4_plant.wav") || equal(sample, "items/kevlar.wav") || equal(sample, "weapons/c4_disarmed.wav") || equal(sample, "weapons/c4_beep5.wav")) return FMRES_SUPERCEDE;

	return FMRES_IGNORED;
}

public CBasePlayer_TakeDamage(const victim, pevInflictor, pevAttacker, Float:flDamage, bitsDamageType)
{
	if(is_user_valid(victim) && is_user_valid(pevAttacker) && is_user_connected(victim) && bitsDamageType != DMG_GRENADE)
	{
		if(get_member(victim, m_iTeam) != get_member(pevAttacker, m_iTeam))
		{
			new gun, hitZone;
			get_user_attacker(victim, gun, hitZone);

			if(hitZone == HIT_HEAD && WeaponIdType:rg_get_user_weapon(pevAttacker) == WEAPON_KNIFE) //WeaponIdType:get_member(get_member(pevAttacker, m_pActiveItem), m_iId) != WEAPON_KNIFE)
			{
				rh_emit_sound2(victim, 0, CHAN_STATIC, SOUNDS2[1], 0.8, 0.7, 0, PITCH_NORM);
			}
		}
	}
	return HC_CONTINUE;
}

public plugin_natives()
{
	register_native("GloveBodyID", "GetGloveBodyID", 1);
}

public GetGloveBodyID(id)
{
	return GetBodyIndex(id, iPlayerGlove[id], 0);
}

stock PlayWeaponState(pPlayer, iWeaponAnim)
{
	UTIL_SendWeaponAnim(pPlayer, iWeaponAnim, iBodyIndex[pPlayer]);
}

public SPEC_OBS_IN_EYE(iTaskData[], iPlayer)
{
	UTIL_SendWeaponAnim(iPlayer, iTaskData[1], iTaskData[0]);
}

public plugin_precache()
{
	//register_forward(FM_PrecacheModel, "Forward_PrecacheModel");	//Unprecache old viewmodels
	register_forward(FM_PrecacheSound, "Forward_PrecacheSound");

	new i, buffer[32+(2*32)];

	for(i = 0; i < sizeof(AGENT_MODELT); i++)
	{
		format(buffer, sizeof(buffer), "models/player/%s/%s.mdl", AGENT_MODELT[i], AGENT_MODELT[i]);
		engfunc(EngFunc_PrecacheModel, buffer);
		copy(buffer[strlen(buffer)-4], charsmax(buffer) - (strlen(buffer)-4), "T.mdl");
		if (file_exists(buffer)) engfunc(EngFunc_PrecacheModel, buffer);
	}

	for(i = 0; i < sizeof(AGENT_MODELCT); i++)
	{
		format(buffer, sizeof(buffer), "models/player/%s/%s.mdl", AGENT_MODELCT[i], AGENT_MODELCT[i]);
		engfunc(EngFunc_PrecacheModel, buffer);
		copy(buffer[strlen(buffer)-4], charsmax(buffer) - (strlen(buffer)-4), "T.mdl");
		if (file_exists(buffer)) engfunc(EngFunc_PrecacheModel, buffer);
	}

	for(i = 0; i < sizeof(DISTANT); i++)
	{	
		formatex(buffer, charsmax(buffer), "csgonew4/distant/%s.wav", DISTANT[i]);
		engfunc(EngFunc_PrecacheSound, buffer);
	}

	for (i = 0; i < sizeof g_NewModels; i++)
	{
		engfunc(EngFunc_PrecacheModel, g_NewModels[i]);	//Precache now new
	}
	
	for(i = 0; i < sizeof g_KnifeModels; i++) engfunc(EngFunc_PrecacheModel, g_KnifeModels[i]);	//Precache now new

	for(i = 0; i < sizeof g_M4Models; i++) engfunc(EngFunc_PrecacheModel, g_M4Models[i]);	//Precache now new

	for(i = 0; i < sizeof(Sprites); i++)
	{
		precache_generic(Sprites[i][1]);
		precache_generic(Sprites[i][3]);
	}

	for (i = 0; i < sizeof EL_BASI_CT; i++)
	{
		engfunc(EngFunc_PrecacheSound, EL_BASI_CT[i]);
	}

	for (i = 0; i < sizeof EL_BASI_T; i++)
	{
		engfunc(EngFunc_PrecacheSound, EL_BASI_T[i]);
	}

	for(i = 0; i < sizeof YENISESLER; i++) {
		engfunc(EngFunc_PrecacheSound, YENISESLER[i]);
	}

	for(i = 0; i < sizeof stopsound; i++) {
		engfunc(EngFunc_PrecacheSound, stopsound[i]);
	}

	for(i = 0; i < sizeof TERROR_THROWING; i++)
	{
		engfunc(EngFunc_PrecacheSound, TERROR_THROWING[i]);
	}

	for(i = 0; i < sizeof TERROR_RADIO; i++)
	{
		engfunc(EngFunc_PrecacheSound, TERROR_RADIO[i]);
	}

	for(i = 0; i < sizeof CT_THROWING; i++)
	{
		engfunc(EngFunc_PrecacheSound, CT_THROWING[i]);
	}

	for(i = 0; i < sizeof CT_RADIO; i++)
	{
		engfunc(EngFunc_PrecacheSound, CT_RADIO[i]);
	}

	for(i = 0; i < sizeof TERROR_DEATH; i++)
	{
		engfunc(EngFunc_PrecacheSound, TERROR_DEATH[i]);
	}

	for(i = 0; i < sizeof CT_DEATH; i++)
	{
		engfunc(EngFunc_PrecacheSound, CT_DEATH[i]);
	}

	for(i = 0; i < sizeof CT_DEFUSING_BOMB; i++)
	{
		engfunc(EngFunc_PrecacheSound, CT_DEFUSING_BOMB[i]);
	}

	for(i = 0; i < sizeof T_PLANTINGBOMB; i++)
	{
		engfunc(EngFunc_PrecacheSound, T_PLANTINGBOMB[i]);
	}

	engfunc(EngFunc_PrecacheGeneric, "sprites/custom_augsg_scope.txt");

	engfunc(EngFunc_PrecacheGeneric, "sprites/awp_scope_custom.txt");
	engfunc(EngFunc_PrecacheGeneric, "sprites/scout_scope_custom.txt");
	engfunc(EngFunc_PrecacheModel, "sprites/custom_scopes_reapi.spr");

	g_SmokePuff_SprId = engfunc(EngFunc_PrecacheModel, "sprites/wall_puff1.spr");

	for (i = 0; i < sizeof ROUND_SOUNDS; i++)
	{
		engfunc(EngFunc_PrecacheSound, ROUND_SOUNDS[i]);
	}

	for(i = 0; i < sizeof SOUNDS2; i++) {
		engfunc(EngFunc_PrecacheSound, SOUNDS2[i]);
	}

	for(i = 0; i < sizeof WEAPONS_SHOOT_SOUND; i++) {
		engfunc(EngFunc_PrecacheSound, WEAPONS_SHOOT_SOUND[i]);
	}

	engfunc(EngFunc_PrecacheModel, AUG_SCOPE);
	engfunc(EngFunc_PrecacheModel, SIG_SCOPE);

	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/movement1.wav");

	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/knife_inspect.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/knife_deploy2.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a1_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a1_boltforward.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a1_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a1_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a1_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m4a4_cliphit.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ak47_boltpull.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ak47_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ak47_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ak47_draw.wav");

	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/aug_boltpull.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/aug_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/aug_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/aug_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/aug_cliptap.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/awp_boltdown.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/awp_boltup.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/awp_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/awp_cliptap.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/awp_draw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/c4_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/c4_initiate.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press1.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press2.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press3.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press4.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press5.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press6.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/key_press7.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_1.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_2.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_3.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_4.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_5.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_6.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_7.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_8.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/deagle_lookat_9.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_hammer.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_slide.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/elite_taunt_tap.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_boltforward.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_cliphit.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/famas_draw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/fiveseven_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/fiveseven_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/fiveseven_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/fiveseven_slideback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/fiveseven_sliderelease.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/galil_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/galil_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/galil_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/galil_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/galil_draw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/glock_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/glock_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/glock_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/glock_slideback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/glock_sliderelease.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/gd_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/gd_pinpull.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/gd_throw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_boxin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_boxout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_chain.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_coverdown.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_coverup.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/m249_pump.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mac10_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mac10_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mac10_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mac10_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mac10_draw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp5_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp5_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp5_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp5_slideback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp5_slideforward.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp9_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp9_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp9_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp9_slideback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/mp9_slideforward.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/nova_bolt.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/nova_draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/nova_insert.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/p90_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/p90_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/p90_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/p90_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/p90_tap.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/sg553clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/sg553clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/sg553draw.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/sg553pull.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/sg553release.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_cliptap.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ssg_draw.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ump45_boltback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ump45_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ump45_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ump45_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/ump45_deploy.wav");
	
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/usp_slideback.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/usp_sliderelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/usp_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/usp_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/usp_draw.wav");

	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/tec9_boltpull.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/tec9_boltrelease.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/tec9_clipin.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/tec9_clipout.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/tec9_draw.wav");

	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/backstab.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look01_a.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look01_b.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look02_a.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look02_b.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look03_a.wav");
	engfunc(EngFunc_PrecacheSound, "weapons/silahseslerinew3/look03_b.wav");

	engfunc(EngFunc_PrecacheModel, SPRITES2[0]);
	engfunc(EngFunc_PrecacheModel, SPRITES2[1]);

	new Muzzleflash = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));
	set_pev(Muzzleflash, pev_classname, "wep_muzzleflash");
	set_pev(Muzzleflash, pev_scale, 0.15);
	engfunc(EngFunc_SetModel, Muzzleflash, SPRITES2[0]);
	set_pev(Muzzleflash, pev_rendermode, kRenderTransAdd);
	set_pev(Muzzleflash, pev_renderamt, 0.0);

	new WIN = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));
	set_pev(WIN, pev_classname, "screen_sprites");
	set_pev(WIN, pev_scale, 0.0305);
	engfunc(EngFunc_SetModel, WIN, SPRITES2[1]);
	set_pev(WIN, pev_rendermode, kRenderTransTexture);
	set_pev(WIN, pev_renderamt, 0.0);
}

public Forward_PrecacheModel(const iModels[])
{
	for (new i; i < sizeof g_OldModels; i++) 
	{ 
		if(!strcmp(iModels, g_OldModels[i]))  
		{  
			forward_return(FMV_CELL, 0);
			
			return FMRES_SUPERCEDE;  
		}  
	}
	
	return FMRES_IGNORED;  	
}

public Forward_PrecacheSound(const Sound[])
{
	new ResourcePath[32+(2*32)];
	for (new i; i < sizeof Ses; i++) 
	{ 
		if(i >= 59 && i < 144) formatex(ResourcePath, charsmax(ResourcePath), "player/%s.wav", Ses[i]);
		else formatex(ResourcePath, charsmax(ResourcePath), "weapons/%s.wav", Ses[i]);
		if(equal(Sound, ResourcePath))  
		{  
			forward_return(FMV_CELL, 0);
		
			return FMRES_SUPERCEDE;  
		} 
	}	
	return FMRES_IGNORED;  	
}

//Anim func
stock UTIL_SendWeaponAnim(pPlayer, iAnim, iBody) 
{
	set_entvar(pPlayer, var_weaponanim, iAnim);
	
	message_begin(MSG_ONE, SVC_WEAPONANIM, _, pPlayer);
	write_byte(iAnim);
	write_byte(iBody);
	message_end();

	if(get_entvar(pPlayer, var_iuser1)) 
		return;

	for(new id = 1; id <= maxplayer; id++)
	{
		if(!is_user_connected(id) || !g_isDead[id] || get_entvar(id, var_iuser2) != pPlayer) // get_entvar(id, var_iuser1) != OBS_IN_EYE ||
			continue;

		set_entvar(id, var_weaponanim, iAnim);

		message_begin(MSG_ONE, SVC_WEAPONANIM, _, id);
		write_byte(iAnim);
		write_byte(iBody);
		message_end();
	}
}

stock WeaponSkinID(id, iEntity)
{
	new SkinID;
	switch(WeaponIdType:rg_get_weapon(iEntity))
	{
		case WEAPON_AK47: SkinID = 0;
		case WEAPON_AWP: SkinID = 1;
		case WEAPON_DEAGLE: SkinID = 2;
		case WEAPON_GALIL: SkinID = 3;
		case WEAPON_GLOCK18: SkinID = 4;
		case WEAPON_M4A1: SkinID = g_M4[id] == 0 ? 5 : 6;
		case WEAPON_P90: SkinID = 7;
		case WEAPON_USP: SkinID = 8;
		default: SkinID = 0;
	}
	return SkinID;
}

stock GetBodyIndex(id, glove, skin)
{
	static Index, team;
	team = get_member(id, m_iTeam);

	if(any:team == TEAM_TERRORIST)
	{
		Index = g_PlayerAgent[id][0] == 2 ? 2 : 0;
	}
	else if(any:team == TEAM_CT)
	{
		Index = 1;
	}
	Index += glove * 3;
	Index += skin * 27;

	return Index;
}

stock GetWeaponInspect(iEntity)
{
	static InspectAnim, id;

	switch(WeaponIdType:rg_get_weapon(iEntity))
	{
		case WEAPON_P228, WEAPON_M3: InspectAnim = 7;
		case WEAPON_SCOUT, WEAPON_M249: InspectAnim = 5;
		case WEAPON_MAC10, WEAPON_AUG, WEAPON_FIVESEVEN, WEAPON_UMP45, WEAPON_GALIL, WEAPON_FAMAS, WEAPON_AWP, WEAPON_MP5N, WEAPON_TMP, WEAPON_SG552, WEAPON_AK47, WEAPON_P90: InspectAnim = 6;
		case WEAPON_DEAGLE:
		{
			InspectAnim = random_num(0, 100);
			if(InspectAnim >= 75)
			{
				InspectAnim = 7;
			}
			else
			{
				InspectAnim = 6;
			}
		}
		case WEAPON_ELITE: InspectAnim = 16;
		case WEAPON_GLOCK18: InspectAnim = 13;
		case WEAPON_M4A1: InspectAnim = 14;
		case WEAPON_USP:
		{
			if(!(get_member(iEntity, m_Weapon_iWeaponState) & WPNSTATE_USP_SILENCED)) InspectAnim = 17;
			else InspectAnim = 16;
		}
		case WEAPON_KNIFE:
		{
			id = get_member(iEntity, m_pPlayer);

			if(iPlayerKnifeA[id] == Default) InspectAnim = random_num(8, 9);
			else if(iPlayerKnifeA[id] == BUTTERFLY) InspectAnim = random_num(8, 10);
			else if(iPlayerKnifeA[id] == STILETTO) InspectAnim = random_num(8, 10);
			else if(iPlayerKnifeA[id] == PARACORD) InspectAnim = random_num(8, 9);
			else InspectAnim = 8;
		}
		default: InspectAnim = 0;
	}
	
	return InspectAnim;
}

stock GetWeaponDrawAnim(iEntity)
{
	static DrawAnim, id;
	
	switch(WeaponIdType:rg_get_weapon(iEntity))
	{
		case WEAPON_P228, WEAPON_M3: DrawAnim = 6;
		case WEAPON_SCOUT, WEAPON_M249: DrawAnim = 4;
		case WEAPON_MAC10, WEAPON_AUG, WEAPON_UMP45, WEAPON_GALIL, WEAPON_FAMAS, WEAPON_MP5N, WEAPON_TMP, WEAPON_SG552, WEAPON_AK47, WEAPON_P90: DrawAnim = 2;
		case WEAPON_ELITE: DrawAnim = 15;
		case WEAPON_FIVESEVEN, WEAPON_AWP, WEAPON_DEAGLE: DrawAnim = 5;
		case WEAPON_USP:
		{
			if(!(get_member(iEntity, m_Weapon_iWeaponState) & WPNSTATE_USP_SILENCED)) DrawAnim = 14;
			else DrawAnim = 6;
		}
		case WEAPON_M4A1: DrawAnim = 5;
		case WEAPON_GLOCK18: DrawAnim = 8;
		case WEAPON_HEGRENADE, WEAPON_FLASHBANG, WEAPON_SMOKEGRENADE: DrawAnim = 3;
		case WEAPON_C4: DrawAnim = 1;	
		case WEAPON_KNIFE:
		{
			id = get_member(iEntity, m_pPlayer);

			if(iPlayerKnifeA[id] == BUTTERFLY) DrawAnim = random_num(0, 1) ? 3 : 11;
			else DrawAnim = 3;
		}
		default: DrawAnim = 0;
	}
	
	return DrawAnim;
}

stock WeaponIdType:rg_get_weapon(const iEntity)
{
	if(!is_nullent2(iEntity))
	{
		return get_member(iEntity, m_iId);
	}

	return WEAPON_NONE;
}

stock WeaponIdType:rg_get_user_weapon(const pPlayer) {
	new pWeapon = get_member(pPlayer, m_pActiveItem);
	
	if(!is_nullent2(pWeapon)) {
		return get_member(pWeapon, m_iId);
	}
	
	return WEAPON_NONE;
}

stock Hide_Crosshair(id)
{
	message_begin(MSG_ONE, Message_New[Message_HideWeapon], _, id);
	write_byte(HUD_HIDE_CROSS | HUD_HIDE_FLASH);
	message_end();
}

stock Msg_CurWeapon(id, Active, WeaponID, ClipAmmo)
{
	message_begin(MSG_ONE, Message_New[Message_CurWeapon], {0, 0, 0}, id);
	write_byte(Active);
	write_byte(WeaponID);
	write_byte(ClipAmmo);
	message_end();
}

stock Msg_WeaponList(id, const WeaponName[], PrimaryAmmoID, PrimaryAmmoMaxAmount, SecondaryAmmoID, SecondaryAmmoMaxAmount, SlotID, NumberInSlot, WeaponID, Flags)
{
	message_begin(MSG_ONE,Message_New[Message_WeaponList], {0, 0, 0}, id);
	write_string(WeaponName);
	write_byte(PrimaryAmmoID);
	write_byte(PrimaryAmmoMaxAmount);
	write_byte(SecondaryAmmoID);
	write_byte(SecondaryAmmoMaxAmount);
	write_byte(SlotID);
	write_byte(NumberInSlot);
	write_byte(WeaponID);
	write_byte(Flags);
	message_end();
}

stock Msg_SetFOV(id, Degrees)
{
	message_begin(MSG_ONE, Message_New[Message_SetFov], {0, 0, 0}, id);
	write_byte(Degrees);
	message_end();
}

stock PlaySound(id, const sound[])
{
	if(equal(sound[strlen(sound)-4], ".mp3")) client_cmd(id, "mp3 play ^"sound/%s^"", sound);
	else client_cmd(id, "spk ^"%s^"", sound);
}

stock Make_BulletHole(id, Float:Origin[3], Float:Damage)
{
	// Find target
	static Decal; Decal = random_num(41, 45);
	static LoopTime; 
	
	if(Damage > 100.0) LoopTime = 2;
	else LoopTime = 1;
	
	for(new i = 0; i < LoopTime; i++)
	{
		// Put decal on "world" (a wall)
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_WORLDDECAL);
		engfunc(EngFunc_WriteCoord, Origin[0]);
		engfunc(EngFunc_WriteCoord, Origin[1]);
		engfunc(EngFunc_WriteCoord, Origin[2]);
		write_byte(Decal);
		message_end();
		
		// Show sparcles
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
		write_byte(TE_GUNSHOTDECAL);
		engfunc(EngFunc_WriteCoord, Origin[0]);
		engfunc(EngFunc_WriteCoord, Origin[1]);
		engfunc(EngFunc_WriteCoord, Origin[2]);
		write_short(id);
		write_byte(Decal);
		message_end();
	}
}

stock Make_BulletSmoke(id, TrResult)
{
	static Float:vecSrc[3], Float:vecEnd[3], TE_FLAG;
	
	get_weapon_attachment(id, vecSrc);
	global_get(glb_v_forward, vecEnd);
	
	xs_vec_mul_scalar(vecEnd, 8192.0, vecEnd);
	xs_vec_add(vecSrc, vecEnd, vecEnd);

	get_tr2(TrResult, TR_vecEndPos, vecSrc);
	get_tr2(TrResult, TR_vecPlaneNormal, vecEnd);
	
	xs_vec_mul_scalar(vecEnd, 2.5, vecEnd);
	xs_vec_add(vecSrc, vecEnd, vecEnd);
	
	TE_FLAG |= TE_EXPLFLAG_NODLIGHTS;
	TE_FLAG |= TE_EXPLFLAG_NOSOUND;
	TE_FLAG |= TE_EXPLFLAG_NOPARTICLES;
		
	engfunc(EngFunc_MessageBegin, MSG_PAS, SVC_TEMPENTITY, vecEnd, 0);
	write_byte(TE_EXPLOSION);
	engfunc(EngFunc_WriteCoord, vecEnd[0]);
	engfunc(EngFunc_WriteCoord, vecEnd[1]);
	engfunc(EngFunc_WriteCoord, vecEnd[2] - 10.0);
	write_short(g_SmokePuff_SprId);
	write_byte(2);
	write_byte(50);
	write_byte(TE_FLAG);
	message_end();
}

stock get_weapon_attachment(id, Float:output[3], Float:fDis = 40.0)
{ 
	static Float:vfEnd[3], viEnd[3];
	get_user_origin(id, viEnd, 3);
	IVecFVec(viEnd, vfEnd);
	
	static Float:fOrigin[3], Float:fAngle[3];
	
	get_entvar(id, var_origin, fOrigin);
	get_entvar(id, var_view_ofs, fAngle);
	
	xs_vec_add(fOrigin, fAngle, fOrigin);
	
	static Float:fAttack[3];
	
	xs_vec_sub(vfEnd, fOrigin, fAttack);
	xs_vec_sub(vfEnd, fOrigin, fAttack);
	
	static Float:fRate;
	
	fRate = fDis / vector_length(fAttack);
	xs_vec_mul_scalar(fAttack, fRate, fAttack);
	
	xs_vec_add(fOrigin, fAttack, output);
}

stock GetRandomAlive(target_index)
{
	new iAlive, id;
	
	for (id = 1; id <= maxplayer; id++)
	{
		if (!g_isDead[id])
			iAlive++;
		
		if (iAlive == target_index)
			return id;
	}
	return -1;
}

stock Canli_kisiler()
{
	new iAlive, id;
	
	for (id = 1; id <= maxplayer; id++)
	{
		if (is_user_valid(id) && is_user_connected(id) && !g_isDead[id])
			iAlive++;
	}
	
	return iAlive;
}

stock GetPlayingCount(const Team)
{
	new iPlaying, id, team;
	
	for (id = 1; id <= maxplayer; id++)
	{
		if (!is_user_valid(id) || !is_user_connected(id) || g_isDead[id])
			continue;
		
		team = get_member(id, m_iTeam);
		
		if (any:team != TEAM_SPECTATOR && any:team != TEAM_UNASSIGNED)
		{
			if(Team == 0 && any:team == TEAM_TERRORIST) iPlaying++;
			else if(Team == 1 && any:team == TEAM_CT) iPlaying++;
			else if(Team == 2) iPlaying++;
		}
	}
	
	return iPlaying;
}