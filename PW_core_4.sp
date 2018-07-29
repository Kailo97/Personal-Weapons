// Decompilation by Maxim "Kailo" Telezhenko, 2018

#include <adminmenu>
#include <sdkhooks>
#include <sdktools>
#include "PW/file1.sp"
#include "PW/file2.sp"
#include "PW/file3.sp"
#include "PW/file4.sp"
#include "PW/file5.sp"
#include "PW/file6.sp"
#include "PW/file7.sp"

public Plugin:myinfo = {
	name = "Personal Weapons",
	description = "Персональное оружие игроков + бонусы и инвентарь.",
	author = "DEN (skype: cssrs2_ky39i)",
	url = "www.infozona-51.ru",
	version = "4.3"
}; // address: 37376 // codestart: 0

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("GetIDClient_SkinsWeapons", Native_GetIDClient);
	CreateNative("AddWeapon_SkinsWeapons", Native_SetWeapon);
	CreateNative("DelWeapon_SkinsWeapons", Native_DelWeapon);
	CreateNative("CheckSkinWeapon_SkinsWeapons", Native_CheckSkinWeapon);
	CreateNative("CheckWeapon_SkinsWeapons", Native_CheckWeapon);
	CreateNative("AddTime_SkinsWeapons", Native_AddTimeWeapon);
	CreateNative("EnableWeapon_SkinsWeapons", Native_EnableWeapon);
	CreateNative("NewClient_SkinsWeapons", Native_CheckNewClient);
	CreateNative("SetOnSequences_SkinsWeapons", Native_SequenceClient);
	MarkNativeAsOptional("GetUserMessageType");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbAddString");
	RegPluginLibrary("skins_weapons");
	return APLRes:0;
}

public OnPluginStart() // address: 1742260
{
	Func1469220();
	Func1679324();
	Func1603704();
	Func1548308();
	Func1498260();
	AutoExecConfig(true, "Skins-Weapons", "sourcemod/skins_weapons");
}

public OnPluginEnd() // address: 1744116
{
	Func1500944();
}

public OnMapStart() // address: 1745420
{
	Func1605664();
}

public OnMapEnd() // address: 1752716
{
	Func1710740();
	Func1609116();
}

public OnClientDisconnect_Post(client) // address: 1754136
{
	Func1532380(client);
}

public OnClientAuthorized(client, const String:auth[]) // address: 1755352
{
	Func1685040(client, auth);
}

public OnClientPutInServer(client) // address: 1757332
{
	Func1530316(client);
}

public OnClientDisconnect(client) // address: 1758864
{
	Func1534408(client);
	Func1619800(client);
}

public OnClientPostAdminCheck(client) // address: 1759784
{
	if (IsClientConnected(client))
	{
		QueryClientConVar(client, "cl_allowdownload", CvarChecking_AllowDownload, client);
	}
}

public CvarChecking_AllowDownload(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[]) // address: 1761312
{
	if (StringToInt(cvarValue, 10) == 0)
	{
		KickClient(client, "Включите скачку файлов с сервера: cl_allowdownload 1");
	}
	else
	{
		if (IsClientConnected(client))
		{
			QueryClientConVar(client, "cl_downloadfilter", CvarChecking_DownloadFilter, client);
		}
	}
}

public CvarChecking_DownloadFilter(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[]) // address: 1762556
{
	if (strcmp(cvarValue, "all", false))
	{
		KickClient(client, "Включите скачку файлов с сервера: cl_downloadfilter all");
	}
}
