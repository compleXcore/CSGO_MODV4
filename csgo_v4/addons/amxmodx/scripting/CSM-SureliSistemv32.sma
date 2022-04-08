// Eklentinin orjinali BlackSmoke'dan alýnmýþtýr, fakat çok hatalý vede çok düzensiz olduðu için baþtan aþaðý harita oylama sistemide dahil CSmiLeFaCe tarafýndan yeniden yazýlmýþtýr.

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#define MAX_MAP		250

new g_iTimerVote[33];
new g_iNumRTV;
new g_iPlayerProcc;
new bool:g_LastRound;
new b_HasRTV[33];
new Float:g_iLastSec[33];
new bool:g_Vote;
new bool:b_HasAlreadyVoted[33];
new iAllVoted;
new sonuc;
new SmiLe[MAX_MAP][250],configsdir[250],komutdosyasi[250],CSmiLeFaCe[MAX_MAP][250],CSmiLeFaCee,FaCe[6],LeFa[6];
new REKLAMCVAR;
new REKLAM[32];
#define TimeVote 30
new bironcekiharita;
new bironcekiharitacevir[32];
new ondanbironcekiharita;
new ondanbironcekiharitacevir[32];
new ondanbirbironcekiharita;
new ondanbirbironcekiharitacevir[32];
new elsonunubekle

public plugin_init()
{
	register_plugin("CSM Harita Sistemi [RTV]", "3.2", "-CSmiLeFaCe");
	
	register_clcmd("say /RTV", "RockTheVote")
	register_clcmd("say !RTV", "RockTheVote")
	register_clcmd("say .RTV", "RockTheVote")
	register_clcmd("say /haritalar", "oynanilanharitalarinsirasi")
	register_clcmd("say !haritalar", "oynanilanharitalarinsirasi")
	register_clcmd("say .haritalar", "oynanilanharitalarinsirasi")
	register_concmd("say nextmap", "Show_Nextmap")
	
	register_menucmd(register_menuid("VoteMenu"), 1023, "ActionVoteMenu");
	
	register_logevent("RoundEnd", 2, "1=Round_End")
	elsonunubekle = register_cvar("csm_elsonunubekle","0")
	bironcekiharita = register_cvar("csm_bironcekiharita","YOK") 
	get_pcvar_string(bironcekiharita,bironcekiharitacevir,31)
	ondanbironcekiharita = register_cvar("csm_ondanbironcekiharita","YOK") 
	get_pcvar_string(ondanbironcekiharita,ondanbironcekiharitacevir,31)
	ondanbirbironcekiharita = register_cvar("csm_ondanbirbironcekiharita","YOK") 
	get_pcvar_string(ondanbirbironcekiharita,ondanbirbironcekiharitacevir,31)
	
	new suankimap[250];
	get_mapname(suankimap,249);
	
	set_cvar_string("csm_ondanbirbironcekiharita", ondanbironcekiharitacevir);
	set_cvar_string("csm_ondanbironcekiharita", bironcekiharitacevir);
	set_cvar_string("csm_bironcekiharita", suankimap);
	//set_task(45.0, "ClCmdVote", _, _, _, "d") //Buradaki 45 timeleft'in bitmesine kaç saniye kala çalýþacaðýný gösterir.
	
	register_cvar("amx_nextmap", "");
	set_cvar_string("amx_nextmap", "");
	REKLAMCVAR = register_cvar("csm_sayreklam","Lost Player")
	get_pcvar_string(REKLAMCVAR,REKLAM,31)
	
}
public oynanilanharitalarinsirasi(id){
	new suankimap[250];
	get_mapname(suankimap,249);
	ChatColor(id,"Oynanilan haritalarin sirasi; !team%s !y--> !team%s !y--> !team%s !y--> !team%s",ondanbirbironcekiharitacevir,ondanbironcekiharitacevir ,bironcekiharitacevir, suankimap);
}
public plugin_natives()
{
	register_native("HaritaOyla", "ClCmdVote", 1)  //Baþka eklentiler ile birleþtirmek için native kullandým. 
}
public Show_Nextmap(id)
{
	new harita[32]
	get_cvar_string("amx_nextmap",harita,sizeof(harita) - 1)
	

	if(harita[0])
	{
		ChatColor(id, "!teamSonraki Harita: !g%s", harita)
	}
	else
		ChatColor(id, "!teamSonraki Harita daha oylanmadi.")
		
	
}

public RoundEnd()
	if(g_LastRound)
		set_task(1.0, "changelevel");

public RockTheVote(id)
{
	if(g_Vote)
	{
		ChatColor(id, "!teamOylama basladi.")
		return PLUGIN_CONTINUE;
	}
	if(b_HasRTV[id])
	{
		ChatColor(id, "!teamOylama icin hazirsiniz.")
		return PLUGIN_CONTINUE;
	}
	new iNum, szPlayers[32];
	get_players(szPlayers, iNum, "hc")

	g_iNumRTV++;

	b_HasRTV[id] = true;
	if(g_iNumRTV == iNum)
	{
		ChatColor(0, "!teamKatilimci!g(%d) !teamgerekli sayiya ulasti. Harita oylamasi geliyor..", g_iNumRTV)
		set_task(5.0, "ClCmdVote");
	}
	else
		ChatColor(0, "!teamOylama icin !g%d !teamkadar istege ihtiyacimiz var !gsay /RTV", iNum-g_iNumRTV)
		
	return PLUGIN_HANDLED;
}

public LoadMapsInVote()
{
	get_configsdir(configsdir,249);
	
	new szMapName[ 64 ];
	get_mapname( szMapName, 63 );
	new satirsayisi,sonuc;
	
	format(komutdosyasi,249,"%s/maps.ini",configsdir);
	
	for(new i=0,deger;i<MAX_MAP;i++){
		sonuc = read_file(komutdosyasi,i,SmiLe[i],249,satirsayisi);
		if(sonuc != 0){
			CSmiLeFaCee++;
			CSmiLeFaCe[CSmiLeFaCee] = SmiLe[i];
			deger++;}
	}
}


public ClCmdVote(){
	client_cmd(0, "spk Gman/gman_choose2")
	set_cvar_float("mp_timelimit", 0.0)
	startvote()
	new yazi[256]
	format(yazi, 255,"Harita Oylama Zamani[%d Saniye]^n",TimeVote-10)
	set_hudmessage(255, 255, 255, 0.0, 0.35, 2, 6.0, 5.0)
	show_hudmessage(0, yazi)
	set_task(1.0, "ValueVote", _, _, _, "a", 10);
}

public ValueVote()
{
	
	new yazi[256]
	format(yazi, 255,"Harita Oylama Zamani[%d Saniye]^n",TimeVote-10)
	
	static timer = 10
	timer--
	switch(timer)
	{
		case 0: 
		{
			ChatColor(0, "!teamHarita oylamasi !gAKTIF")
			g_Vote = true;
			FaCe[0] = 0;
			FaCe[1] = 0;
			FaCe[2] = 0;
			FaCe[3] = 0;
			FaCe[4] = 0;
			arrayset(FaCe, 0, sizeof(FaCe));
			arrayset(g_iTimerVote, TimeVote-10, 33);
			arrayset(b_HasAlreadyVoted, false, 33);
			set_task(float(TimeVote)-5, "endvote");
			timer = 10;
			set_cvar_string("amx_nextmap", "[Oylamada]");
		}
		case 1:
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,1, CSmiLeFaCe[LeFa[0]], FaCe[0] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,2, CSmiLeFaCe[LeFa[1]], FaCe[1] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,3, CSmiLeFaCe[LeFa[2]], FaCe[2] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,4, CSmiLeFaCe[LeFa[3]], FaCe[3] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,5, CSmiLeFaCe[LeFa[4]], FaCe[4] * g_iPlayerProcc)
			for(new q; q < 5; q++)
			{
				format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
			}
			format(yazi, 255,"%s^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
			set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
			show_hudmessage(0, yazi)
		}
		case 2:
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
			//format(yazi, 255,"%s^n^n%d. %s [YÃ¼zde %d]",yazi,2, CSmiLeFaCe[LeFa[1]], FaCe[1] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,3, CSmiLeFaCe[LeFa[2]], FaCe[2] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,4, CSmiLeFaCe[LeFa[3]], FaCe[3] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,5, CSmiLeFaCe[LeFa[4]], FaCe[4] * g_iPlayerProcc)
			for(new q; q < 4; q++)
			{
				format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
			}
			format(yazi, 255,"%s^n^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
			set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
			show_hudmessage(0, yazi)
		}
		case 3:
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
			//format(yazi, 255,"%s^n^n^n%d. %s [YÃ¼zde %d]",yazi,3, CSmiLeFaCe[LeFa[2]], FaCe[2] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,4, CSmiLeFaCe[LeFa[3]], FaCe[3] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,5, CSmiLeFaCe[LeFa[4]], FaCe[4] * g_iPlayerProcc)
			for(new q; q < 3; q++)
			{
				format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
			}
			format(yazi, 255,"%s^n^n^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
			set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
			show_hudmessage(0, yazi)
		}
		case 4:
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
			//format(yazi, 255,"%s^n^n^n^n%d. %s [YÃ¼zde %d]",yazi,4, CSmiLeFaCe[LeFa[3]], FaCe[3] * g_iPlayerProcc)
			//format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,5, CSmiLeFaCe[LeFa[4]], FaCe[4] * g_iPlayerProcc)
			for(new q; q < 2; q++)
			{
				format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
			}
			format(yazi, 255,"%s^n^n^n^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
			set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
			show_hudmessage(0, yazi)
		}
		case 5:
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
			//format(yazi, 255,"%s^n^n^n^n^n%d. %s [YÃ¼zde %d]",yazi,5, CSmiLeFaCe[LeFa[4]], FaCe[4] * g_iPlayerProcc)
			for(new q; q < 1; q++)
			{
				format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
			}
			format(yazi, 255,"%s^n^n^n^n^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
			set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
			show_hudmessage(0, yazi)
		}
			
		default: 
		{
			ChatColor(0, "!teamHarita oylamasinin baslamasina !g%d saniye..", timer)
		}
	}
}

public startvote()
{		
	CSmiLeFaCee = 0;
	LoadMapsInVote()
	new suankimap[250];
	get_mapname(suankimap,249);
	if(CSmiLeFaCee >= 6){
		LeFa[0] = random_num(1,CSmiLeFaCee);
		LeFa[1] = random_num(1,CSmiLeFaCee);
		LeFa[2] = random_num(1,CSmiLeFaCee);
		LeFa[3] = random_num(1,CSmiLeFaCee);
		LeFa[4] = random_num(1,CSmiLeFaCee);
		for(new i = 0;i<5;i++){
			for(new j = 0;j<5;j++){
				if(i == j)
					continue;
					
				if(LeFa[i] == LeFa[j] ||  equal(CSmiLeFaCe[LeFa[i]],suankimap) || equal(CSmiLeFaCe[LeFa[i]],bironcekiharitacevir) || equal(CSmiLeFaCe[LeFa[i]],ondanbironcekiharitacevir)){
					LeFa[i] = random_num(1,CSmiLeFaCee); // ||
					i = 0;}
					
			}
		}
	}
	
	return PLUGIN_HANDLED;
}


public ChooseMap(id)
{
	if(!g_Vote)
		return PLUGIN_CONTINUE;
		
	if(b_HasAlreadyVoted[id]){
		new yazi[256]
		format(yazi, 255,"Harita Oylama Zamani[%d Saniye]^n", g_iTimerVote[id])
		for(new q; q < 5; q++)
		{
			format(yazi, 255,"%s^n%d. %s [YÃ¼zde %d]",yazi,q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
		}
		format(yazi, 255,"%s^n^nGeÃ§erli oy sayisi [%d]",yazi,iAllVoted)
		set_hudmessage(255, 255, 255, 0.0, 0.35, 0, 6.0, 1.0)
		show_hudmessage(id, yazi)
		return PLUGIN_HANDLED;
	}
	else{
	
		new szMenu[512], iLen, iKey
		iLen = format(szMenu[iLen], charsmax(szMenu)-iLen, "\yHarita Oylama Zamani^n\dOylamanin bitmesine \r%d \dSaniye^n", g_iTimerVote[id])
		for(new q; q < 5; q++)
		{
			if(!b_HasAlreadyVoted[id])
				iLen += format(szMenu[iLen], charsmax(szMenu)-iLen, "^n\r%d. \w%s \d[\yYÃ¼zde %d\d]",q+1, CSmiLeFaCe[LeFa[q]], FaCe[q] * g_iPlayerProcc)
		}
		
		if(!b_HasAlreadyVoted[id])
		{
			iKey |= MENU_KEY_0;
			iLen += format(szMenu[iLen], charsmax(szMenu)-iLen, "^n^n\r0. \wOylamaya Katilma")
		}
		
		iLen += format(szMenu[iLen], charsmax(szMenu)-iLen, "^n^n\yGeÃ§erli oy sayisi: \r%d", iAllVoted) 
		
		iKey |= MENU_KEY_0|MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5
		
		if(b_HasAlreadyVoted[id])
			iKey &= ~(MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5);
		
		show_menu(id, iKey, szMenu, -1, "VoteMenu");
		return PLUGIN_HANDLED;
	}
}

public ActionVoteMenu(id, iKey)
{
	if(!g_Vote)
		return PLUGIN_CONTINUE;
		
	new szName[32]
	get_user_name(id, szName, 31)
	
	if(iKey == 9)
	{
		if(!b_HasAlreadyVoted[id])
			ChatColor(0, "!g%s !teamoylamaya katilmadi.", szName);
		b_HasAlreadyVoted[id] = true;
		return PLUGIN_CONTINUE;
	}
	
	iAllVoted++;
	FaCe[iKey]++
	client_cmd(id, "spk Gman/gman_noreg")
	b_HasAlreadyVoted[id] = true;
	ChatColor(0, "!g%s !teamoyuncusunun sectigi harita !g%s", szName, CSmiLeFaCe[LeFa[iKey]]);
	
	return PLUGIN_HANDLED;
}

public endvote()
{
	new kazanan = LeFa[0], eniyiharita = FaCe[0];
	for(new i = 0; i <5; i++){
		if(FaCe[i] > eniyiharita){
			kazanan = LeFa[i];
			eniyiharita = FaCe[i];}
	}
	
	g_Vote = false;
	if(!is_map_valid(CSmiLeFaCe[kazanan]))
	{
		FaCe[0] = 0;
		FaCe[1] = 0;
		FaCe[2] = 0;
		FaCe[3] = 0;
		FaCe[4] = 0;
		iAllVoted = 0; 
		client_cmd(0, "spk Gman/gman_nowork")
		set_task(5.0, "ClCmdVote");
		ChatColor(0, "!teamSeÃ§ilen harita !g%s ^"!ycstrike/maps!g^" !teamklasÃ¶rÃ¼nde !gYOK.!teamOylama islemi yeniden yapilacak.", CSmiLeFaCe[kazanan])
		return PLUGIN_HANDLED;
	}
	
	ChatColor(0, "!teamSonraki Harita: !g%s", CSmiLeFaCe[kazanan])
	set_cvar_string("amx_nextmap", CSmiLeFaCe[kazanan]);
	sonuc = kazanan;
	
	if(get_pcvar_num(elsonunubekle) == 1){
		g_LastRound = true;
		set_dhudmessage( 149,68,0, -1.0, -0.70, 2, 4.0, 11.0, 0.01, 1.5 )
		show_dhudmessage(0, "Sonraki Harita: %s^nHarita el sonunda degisecek",CSmiLeFaCe[kazanan])
	}
	else{
		set_task(1.0, "changelevel");
	}
	
	return PLUGIN_HANDLED;
}
public changelevel()
{
	set_cvar_float("mp_timelimit", 0.0);
	set_dhudmessage( 0,255,0, -1.0, -0.40, 0, 11.0, 6.0, 0.1, 1.5 )
	show_dhudmessage(0, "^nHarita %s olarak degistiriliyor", CSmiLeFaCe[sonuc]) 
	//client_cmd(0, "spk Gman/gman_wise")
	new iNum, szPlayers[32];
	get_players(szPlayers, iNum)
	for(new i; i < iNum; i++)
	{
		client_cmd(szPlayers[i], "drop;wait;wait;wait;wait;wait;drop;wait;wait;wait;wait;wait;drop");
		set_pev(szPlayers[i], pev_flags, pev(szPlayers[i], pev_flags) | FL_FROZEN)
	}
	
	set_task(3.5, "changelevel1");
	set_task(6.0, "changelevel2");
	
	
}
public changelevel1()
{
	new _modName[10]
	get_modname(_modName, 9)
	if (!equal(_modName, "zp"))
	{
		message_begin(MSG_ALL, SVC_INTERMISSION)
		message_end()
	}
}
public changelevel2()
{
	server_cmd("changelevel %s", CSmiLeFaCe[sonuc]);
}
public client_PreThink(id)
{
	if(!g_Vote)
		return;
		
	if(g_iTimerVote[id] <= -1)
		return;
	
	if(iAllVoted)
		g_iPlayerProcc = 100 / iAllVoted;
	else
		g_iPlayerProcc = 0;
	
	if((get_gametime() - g_iLastSec[id]) >= 1.0)
		if(g_iTimerVote[id] != 0)
			g_iTimerVote[id]--, ChooseMap(id), g_iLastSec[id] = get_gametime();
		else
			show_menu(id, 0, "^n"), g_iTimerVote[id] = -1;
}

stock ChatColor(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	format(msg, sizeof(msg), "^1[^4%s^1] %s", REKLAM, msg)
	replace_all(msg, 190, "!g", "^4")
	replace_all(msg, 190, "!y", "^1")
	replace_all(msg, 190, "!team", "^3")
	
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
