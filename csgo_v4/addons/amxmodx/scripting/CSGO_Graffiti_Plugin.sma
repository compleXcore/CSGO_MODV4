/// https://i.hizliresim.com/3O9D9r.png

#include <amxmodx>
#include <engine>
#include <fakemeta>

#define PLUGIN "CSGO Grafiti Plugin"
#define VERSION "2.0"
#define AUTHOR "Fatih ~ EjderYa"

new Bot_Player[33]

#define GRAFFITI_SOUND "Grafiti_Print.wav"
#define GRAFFITI_MODEL "sprites/csgonew4/graffiti.spr"

#define Grafiti_Max_Colour_Client 12
#define Grafiti_Max_Seymbol_Client 22
#define Field_Control_Constant 50.0

new Graffiti_Drawing_Second[33] , Graffiti_Colour[33] , Graffiti_Symbol[33] , Menu_Status[33] , ent_Menu[33] , Second
new cvar_graffiti_reload_time , cvar_graffiti_visibility_time , cvar_graffiti_fade_away_time , cvar_graffiti_distance

/*
new const Float:g_Colors[][3] =
{
//	R	G	B
	{255.0,	255.0,	0.0},	// 0
	{255.0,	195.0,	0.0},	// 1
	{255.0,	143.0,	0.0},	// 2
	{255.0,	91.0,	4.0},	// 3
	{255.0,	9.0,	19.0},	// 4
	{220.0,	8.0,	158.0},	// 5
	{166.0,	26.0,	166.0},	// 6
	{111.0,	37.0,	167.0},	// 7
	{0.0,	122.0,	218.0},	// 8
	{0.0,	122.0,	67.0},	// 9
	{0.0,	184.0,	74.0},	// 10
	{255.0,	255.0,	255.0},	// 11
	{132.0,	208.0,	32.0}	// 12
	
}*/

public plugin_init() {

	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	cvar_graffiti_reload_time = register_cvar("graffiti_reload_time","45")
	cvar_graffiti_visibility_time = register_cvar("graffiti_visibility_time","25")
	cvar_graffiti_fade_away_time = register_cvar("graffiti_fade_away_time","30")
	cvar_graffiti_distance = register_cvar("graffiti_distance","150.0")
	
	register_dictionary("CSGO_Grafiti.txt")
	
	Start_Second_Increase()
}

public Create_Graffiti(id,Float:Origin[3], Float:Angles[3], Float:vNormal[3]){
	
	
	Graffiti_Drawing_Second[id] = Second
	new MODEL_ent = create_entity("env_sprite");
	
	if (is_valid_ent(MODEL_ent) )
	{
		
		Origin[0] += (vNormal[0] * 0.5);
		Origin[1] += (vNormal[1] * 0.5);
		Origin[2] += (vNormal[2] * 0.5);
		
		entity_set_string(MODEL_ent, EV_SZ_classname, "CSGO_Grafiti" );
		entity_set_model(MODEL_ent, GRAFFITI_MODEL);
		entity_set_vector(MODEL_ent, EV_VEC_angles, Angles ) ;
		//set_pev( MODEL_ent, pev_rendermode, kRenderTransAlpha)
		set_pev( MODEL_ent, pev_rendermode, kRenderTransTexture)
		
		
		
		new Seymbol
		if ( Graffiti_Symbol[id] > Grafiti_Max_Seymbol_Client - 1 ) Seymbol = random_num(0,Grafiti_Max_Seymbol_Client - 1)
		else Seymbol = Graffiti_Symbol[id]
		entity_set_float(MODEL_ent, EV_FL_frame, float(Seymbol) );
		
		//if ( Seymbol == 0 ) 	entity_set_float(MODEL_ent, EV_FL_scale, 0.13);
		//else	
		entity_set_float(MODEL_ent, EV_FL_scale, 0.25);
		
		
		
		/*if ( Seymbol != 0 ){
			new Colour
			if ( Graffiti_Colour[id] > Grafiti_Max_Colour_Client ) Colour = random_num(0,Grafiti_Max_Colour_Client)
			else Colour = Graffiti_Colour[id]
			set_pev(MODEL_ent, pev_rendercolor , g_Colors[Colour]) 
		} else */
		set_pev(MODEL_ent, pev_rendercolor , {255.0,255.0,255.0}) 
		
		
		
		set_pev( MODEL_ent, pev_renderamt, 255.0)
		entity_set_origin(MODEL_ent, Origin);
		emit_sound(MODEL_ent, CHAN_ITEM, GRAFFITI_SOUND, 0.70, ATTN_NORM, 0, PITCH_NORM)
		set_task(get_pcvar_float(cvar_graffiti_visibility_time),"Remove_Graffiti",MODEL_ent)
		
		
		
		
	}
	
	return PLUGIN_CONTINUE
	
}
public overflow_graffiti_detect(Float:i_Origin[3], Float:i_Angles[3], Float:vNormal[3]){
	
	
	new Float:Origin[3] , Float:Angles[3]
	Angles[0] = i_Angles[0]
	
	
	Origin[0] = i_Origin[0] + (vNormal[0] * 0.5);
	Origin[1] = i_Origin[1] + (vNormal[1] * 0.5);
	Origin[2] = i_Origin[2] + (vNormal[2] * 0.5);		
	
	
	Origin[0] = i_Origin[0] + floatcos(i_Angles[1] , degrees ) * 5.0
	Origin[1] = i_Origin[1] + floatsin(i_Angles[1] , degrees ) * 5.0
	Origin[2] = i_Origin[2] + floatsin(i_Angles[2] , degrees ) * 5.0 * floatpower(2.0,0.5)
	
	new Status
	
	Angles[1] = i_Angles[1] + 270.0
	Angles[2] = i_Angles[2] + 45.0
	Status += Spawn_in_wall_detect(Origin,Angles)
	Angles[2] -= 90.0
	Status += Spawn_in_wall_detect(Origin,Angles)
	Angles[1] += 180.0
	Status += Spawn_in_wall_detect(Origin,Angles)
	Angles[2] += 90.0
	Status += Spawn_in_wall_detect(Origin,Angles)
	
	
	if ( Status != 4 )
		return false
	
	
	return true
	
}

public Spawn_in_wall_detect(Float:Origin[3],Float:Angles[3]){
	
	new Float:New_Origin[3]
	New_Origin[0] = Origin[0] + floatcos(Angles[1] , degrees ) * Field_Control_Constant / 2.0
	New_Origin[1] = Origin[1] + floatsin(Angles[1] , degrees ) * Field_Control_Constant / 2.0
	New_Origin[2] = Origin[2] + floatsin(Angles[2] , degrees ) * Field_Control_Constant * floatpower(2.0,0.5) / 2.0
	
	
	if(engfunc(EngFunc_PointContents, New_Origin) == CONTENTS_EMPTY) /// IN WALL : 1   -   OUT WALL 0
		return false
	
	return true
	
	
}
public plugin_precache(){
	precache_model(GRAFFITI_MODEL)
	precache_sound(GRAFFITI_SOUND);
	
}

public client_putinserver(id){
	Graffiti_Drawing_Second[id] = Second - get_pcvar_num(cvar_graffiti_reload_time)
	Graffiti_Colour[id] = Grafiti_Max_Colour_Client + 1
	Graffiti_Symbol[id] = Grafiti_Max_Seymbol_Client
	Bot_Player[id] = is_user_bot( id )
	
}

public Symbol_and_Colur_Control(id,Graffiti_ent){

	
	if( pev_valid(ent_Menu[id]) ) {
		new Float:Colour[3]
		/*if ( Graffiti_Symbol[id] != 0 ){
			if ( Graffiti_Colour[id] == Grafiti_Max_Colour_Client +1 )
			{
				Colour[0] = 50.0
				Colour[1] = 50.0
				Colour[2] = 50.0
			}
			else
			{
				Colour[0] = g_Colors[Graffiti_Colour[id]][0]
				Colour[1] = g_Colors[Graffiti_Colour[id]][1]
				Colour[2] = g_Colors[Graffiti_Colour[id]][2]
			}
		}
		else*/
		Colour[0] = 255.0 , Colour[1] = 255.0 , Colour[2] = 255.0
	
		set_pev( Graffiti_ent , pev_rendercolor , Colour )
		set_pev( Graffiti_ent , pev_frame , float(Graffiti_Symbol[id]) )
	}

}

public Drawing_Graffiti(id){
	
	new Center_Origin[3];
	new Float:vCenter_Origin[3];
	new Float:Angles[3];
	new Float:vNormal[3];
	get_user_origin(id, Center_Origin, 3);
	IVecFVec(Center_Origin, vCenter_Origin);
	new Float:vPlayerCenter_Origin[3];
	new Float:vViewOfs[3];
	entity_get_vector(id, EV_VEC_origin, vPlayerCenter_Origin);
	entity_get_vector(id, EV_VEC_view_ofs, vViewOfs);
	vPlayerCenter_Origin[0] += vViewOfs[0];
	vPlayerCenter_Origin[1] += vViewOfs[1];
	vPlayerCenter_Origin[2] += vViewOfs[2];
	new Float:Player_Aim[3];
	entity_get_vector(id, EV_VEC_v_angle, Angles);
	Player_Aim[0] = vPlayerCenter_Origin[0] + floatcos(Angles[1], degrees ) * get_pcvar_float(cvar_graffiti_distance);	
	Player_Aim[1] = vPlayerCenter_Origin[1] + floatsin(Angles[1], degrees) * get_pcvar_float(cvar_graffiti_distance);
	Player_Aim[2] = vPlayerCenter_Origin[2] + floatsin(-Angles[0], degrees) * get_pcvar_float(cvar_graffiti_distance);
	new Intersection_Status = trace_normal(id, vPlayerCenter_Origin, Player_Aim, vNormal);
	vector_to_angle(vNormal, Angles)
	Angles[1] += 180.0
	
	if ( Graffiti_Drawing_Second[id] + get_pcvar_num(cvar_graffiti_reload_time)  > Second ){
		client_print(id,print_center,"%L",id,"WAIT_SPRITE",Graffiti_Drawing_Second[id] + get_pcvar_num(cvar_graffiti_reload_time)  - Second)
		return PLUGIN_HANDLED
	}
	
	
	if ( !Intersection_Status ){
		client_print(id,print_center,"%L",id,"REMOTE_GROUND")
		return PLUGIN_HANDLED
	}
	
	
	if ( vNormal[2] != 0.0 ){
		client_print(id,print_center,"%L",id,"NOVERTICALWALL")
		return PLUGIN_HANDLED
	}
	
	
	if ( !overflow_graffiti_detect(vCenter_Origin, Angles, vNormal) ){
		client_print(id,print_center,"%L",id,"OVERFLOWING_GRAFFITI")
		return PLUGIN_HANDLED
	}
	
	
	
	
	Create_Graffiti(id,vCenter_Origin, Angles, vNormal)
	return PLUGIN_CONTINUE
	
}

public Remove_Graffiti(ent){
	
	if ( pev_valid(ent) ) {
		new Float:Transparency
		pev( ent, pev_renderamt, Transparency)
		Transparency -= 2.5
		
		if ( Transparency <= 2.5 ){
			remove_entity(ent)
		}
		else
		{
			set_pev( ent, pev_renderamt, Transparency)
			
			set_task(get_pcvar_float(cvar_graffiti_fade_away_time)/102.0,"Remove_Graffiti",ent)
		}
	}
}
public Start_Second_Increase(){
	
	Second++
	set_task(1.0,"Start_Second_Increase")
	
}
public client_impulse(id,impulse){
	
	if ( impulse == 201 )
		if ( is_user_alive(id) ){
		
		Drawing_Graffiti(id)
		return PLUGIN_HANDLED
	}
	
	return PLUGIN_CONTINUE
	
	
}
public Menu_Status_Algilaperceive(id){
	
	if ( Menu_Status[id] != 0 ){
		
		
		if ( Menu_Status[id] > 5 ) Menu_Status[id] = 5
		else Menu_Status[id] -= 1
		
		
		
		set_task(1.0,"Menu_Status_Algilaperceive",id)
		
	}
	else remove_entity(ent_Menu[id])
	
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
