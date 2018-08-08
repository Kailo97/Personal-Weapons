// Decompilation by Maxim "Kailo" Telezhenko, 2018

#include <sdktools>
#include <cstrike>
#include <skins_weapons>

#include "PW_Bonus/file1.sp"
#include "PW_Bonus/file2.sp"
#include "PW_Bonus/file3.sp"
#include "PW_Bonus/file4.sp"

public Plugin:myinfo = {
	name = "[P.W] module bonus",
	description = "Модуль бонусов дл� плагина Personal Weapons",
	author = "DEN (skype: cssrs2_ky39i)",
	url = "www.infozona-51.ru",
	version = "4.3"
}; // address: 10592 // codestart: 0

public OnPluginStart() // address: 1548436
{
	Func1472636();
	Func1484996();
	Func1516880();
	AutoExecConfig(true, "[PW]Bonus", "sourcemod/skins_weapons");
}

public OnMapStart() // address: 1549512
{
	Func1476732(0, 3);
}

public OnMapEnd() // address: 1556716
{
	Func1527400();
	Func1493428();
}

public OnClientPutInServer(client) // address: 1557960
{
	Func1496940(client);
}

public OnClientDisconnect(client) // address: 1558944
{
	Func1499968(client);
}
