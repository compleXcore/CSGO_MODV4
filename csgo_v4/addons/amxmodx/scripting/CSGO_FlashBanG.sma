#include <amxmodx>

new const PLUGIN[] = "CSGO_FlashBanG";
new const VERSION[] = "2.0";
new const AUTHOR[] = "By.KinG";

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_event("ScreenFade", "ScreenFade_FlashbanG", "be", "4=255", "5=255", "6=255", "7>199");
}

public ScreenFade_FlashbanG(ID)
{
	new Alpha = read_data(7);
	
	if(Alpha == 255)
	{
		message_begin(MSG_ONE, get_user_msgid("ScreenFade"), {0, 0, 0}, ID);
		write_short(1<<15);
		write_short(1<<10);
		write_short(1<<12);
		write_byte(255);
		write_byte(255);
		write_byte(255);
		write_byte(255);
		message_end();
	}
}
