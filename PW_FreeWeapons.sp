// Decompilation by Maxim "Kailo" Telezhenko, 2019

#include <skins_weapons>

new Handle:g_var1036 = INVALID_HANDLE; // address: 1036 // codestart: 0
new Handle:g_var1040 = INVALID_HANDLE; // address: 1040 // codestart: 0
new Handle:g_var1044[66] = {INVALID_HANDLE, ...}; // address: 1044 // zero // codestart: 0
new g_var1308[66]; // address: 1308 // zero // codestart: 0
new g_var1572 = 3600; // address: 1572 // codestart: 0
public Plugin:myinfo = {
	name = "[P.W] module Free weapons",
	description = "Модуль бесплатное оружие для плагина Personal Weapons",
	author = "DEN (skype: cssrs2_ky39i)",
	url = "www.infozona-51.ru",
	version = "4.2",
}; // address: 1744 // codestart: 0

public OnPluginStart() // address: 1467224
{
	decl String:var256[256];
	g_var1036 = SQL_Connect("Skins_Weapons", true, var256, 256);
	if (g_var1036 == INVALID_HANDLE)
	{
		SetFailState(var256);
		return;
	}
	decl String:var264[8];
	SQL_ReadDriver(g_var1036, var264, 7);
	if (!StrEqual(var264, "mysql", false))
	{
		SQL_TQuery(g_var1036, SQL_DefCallback, "CREATE TABLE IF NOT EXISTS `free` (order_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, custom_id INTEGER, weapon VARCHAR(15), FOREIGN KEY(custom_id) REFERENCES user(custom_id));", 0, DBPriority:1);
	}
	else
	{
		SQL_TQuery(g_var1036, SQL_DefCallback, "CREATE TABLE IF NOT EXISTS `free` (order_id INT(16) AUTOINCREMENT NOT NULL, custom_id INT(16), weapon CHAR(16), PRIMARY KEY(order_id), FOREIGN KEY(custom_id) REFERENCES user(custom_id));", 0, DBPriority:1);
	}
	HookEvent("player_spawn", OnPlayerSpawn, EventHookMode:1);
	RegConsoleCmd("sm_freeweapons", Command, _, 0);
	RegConsoleCmd("sm_fw", Command, _, 0);
	RegConsoleCmd("sm_weapons", Command, _, 0);
	RegConsoleCmd("sm_weapon", Command, _, 0);
	for (new var268 = 1; var268 <= MaxClients; var268++)
	{
		if (IsClientInGame(var268))
		{
			OnClientPostAdminCheck(var268);
		}
	}
	HookConVarChange(CreateConVar("sm_startweapons_time", "1", "Время в часах на которое выдается бесплатное оружие", 0, false, 0.0, false, 0.0), OnConVarChangeTime);
	AutoExecConfig(true, "[PW]FreeWeapons", "sourcemod/skins_weapons");
}

public OnConVarChangeTime(Handle:convar, const String:oldValue[], const String:newValue[]) // address: 1476400
{
	g_var1572 = StringToInt(newValue, 10) * 3600;
}

public SQL_DefCallback(Handle:owner, Handle:hndl, const String:error[], any:data) // address: 1478244
{
	if (hndl == INVALID_HANDLE)
	{
		LogError(error);
	}
}

public OnMapEnd() // address: 1479768
{
	if (g_var1040)
	{
		CloseHandle(g_var1040);
	}
}

public OnMapStart() // address: 1481320
{
	for (new var4 = 1; var4 <= MaxClients; var4++)
	{
		if (g_var1044[var4])
		{
			ClearArray(g_var1044[var4]);
		}
		else
		{
			g_var1044[var4] = CreateArray(16, 0);
		}
	}
	g_var1040 = CreateKeyValues("Free", _, _);
	if (!FileToKeyValues(g_var1040, "addons/sourcemod/data/skins_weapons/free_weapons.txt"))
	{
		SetFailState("File not found data/skins_weapons/free_weapons.txt");
		return;
	}
}

public OnClientPostAdminCheck(client) // address: 1483300
{
	g_var1308[client] = 0;
	if (!IsFakeClient(client))
	{
		new var4 = GetIDClient_SkinsWeapons(client);
		decl String:var76[72];
		FormatEx(var76, 70, "SELECT weapon FROM `free` WHERE `custom_id` = %d", var4);
		SQL_TQuery(g_var1036, OnClientPutInServer_DB, var76, GetClientUserId(client), DBPriority:1);
		g_var1308[client] = NewClient_SkinsWeapons(client);
	}
}

public OnClientDisconnect(client) // address: 1484588
{
	ClearArray(g_var1044[client]);
}

public OnClientPutInServer_DB(Handle:owner, Handle:hndl, const String:error[], any:data) // address: 1485908
{
	new var4 = GetClientOfUserId(data);
	if (var4 < 1 || hndl == INVALID_HANDLE)
	{
		return;
	}
	decl String:var20[16];
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, var20, 16, _);
		PushArrayString(g_var1044[var4], var20);
	}
}

public OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast) // address: 1487464
{
	new var4 = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!var4)
	{
		return;
	}
	if (IsClientInGame(var4) && GetClientTeam(var4) > 1 && g_var1308[var4])
	{
		g_var1308[var4] = 0;
		CreateTimer(0.1, Timer_Menu, GetClientUserId(var4), 0);
	}
}

public Action:Timer_Menu(Handle:timer, any:data) // address: 1488752
{
	new var4 = GetClientOfUserId(data);
	if (var4 < 1)
	{
		return;
	}
	Func1490704(var4);
}

Func1490704(arg12) // address: 1490704
{
	new Handle:var4 = CreateMenu(SelectList, MenuAction:28);
	SetMenuTitle(var4, "МЕНЮ ОРУЖИЯ:\n \n");
	AddMenuItem(var4, "", "Выбрать оружие из списка", 0);
	if (EnableWeapon_SkinsWeapons(arg12, 2))
	{
		AddMenuItem(var4, "", "Играть со стандартным оружием", 0);
	}
	else
	{
		AddMenuItem(var4, "", "Играть со стандартным оружием [+]", 0);
	}
	if (GetUserFlagBits(arg12) & 16384)
	{
		AddMenuItem(var4, "", "Информация об оружии \n \n", 0);
		AddMenuItem(var4, "", "Очистка Базы Данных", 0);
	}
	else
	{
		AddMenuItem(var4, "", "Информация об оружии", 0);
	}
	DisplayMenu(var4, arg12, 0);
}

public SelectList(Handle:menu, MenuAction:action, param1, param2) // address: 1492128
{
	switch (action)
	{
		case 16:
		{
			CloseHandle(menu);
		}
		case 4:
		{
			switch (param2)
			{
				case 0:
				{
					Func1494208(param1);
				}
				case 1:
				{
					static Float:g_var3916[66]; // address: 3916 // zero // codestart: 0
					new Float:var4 = GetGameTime();
					if (g_var3916[param1] < var4)
					{
						if (EnableWeapon_SkinsWeapons(param1, 2))
						{
							EnableWeapon_SkinsWeapons(param1, 0);
						}
						else
						{
							EnableWeapon_SkinsWeapons(param1, 1);
						}
						g_var3916[param1] = 5.0 + var4;
					}
					else
					{
						PrintToChat(param1, "\x04[P.W]\x01 Переключение будет доступно через %d сек.", RoundToCeil(g_var3916[param1] - var4));
					}
					Func1490704(param1);
				}
				case 2:
				{
					Func1502036(param1);
				}
				case 3:
				{
					Func1509168(param1);
				}
			}
		}
	}
}

Func1494208(arg12) // address: 1494208
{
	new Handle:var4 = CreateMenu(SelectWeapon, MenuAction:28);
	SetMenuExitBackButton(var4, true);
	SetMenuTitle(var4, "FREE WEAPONS:\n \n");
	if (KvGotoFirstSubKey(g_var1040, false))
	{
		decl String:var20[16];
		decl String:var36[16];
		do
		{
			if (KvGetSectionName(g_var1040, var20, 16) && var20[0] && strcmp(var20, "info", true)) // Array
			{
				Func1513368(var20, var36, 16);
				if (FindStringInArray(g_var1044[arg12], var20) != -1)
				{
					AddMenuItem(var4, var20, var36, 1);
				}
				else
				{
					AddMenuItem(var4, var20, var36, 0);
				}
			}
		}
		while (KvGotoNextKey(g_var1040, false));
		KvGoBack(g_var1040);
	}
	KvGoBack(g_var1040);
	if (GetMenuItemCount(var4) == 0)
	{
		AddMenuItem(var4, "", "Не найдены модели в файле", 1);
	}
	DisplayMenu(var4, arg12, 0);
}

public SelectWeapon(Handle:menu, MenuAction:action, param1, param2) // address: 1495972
{
	switch (action)
	{
		case 16:
		{
			CloseHandle(menu);
		}
		case 8:
		{
			if (param2 == -6)
			{
				Func1490704(param1);
			}
		}
		case 4:
		{
			decl String:var16[16];
			GetMenuItem(menu, param2, var16, 16, _, _, 0);
			Func1497636(param1, var16);
		}
	}
}

Func1497636(arg12, const String:arg16[]) // address: 1497636
{
	new Handle:var4 = CreateMenu(SelectWeaponName, MenuAction:28);
	SetMenuTitle(var4, "Выберите скин:\n \n");
	SetMenuExitBackButton(var4, true);
	if (KvJumpToKey(g_var1040, arg16, false))
	{
		if (KvGotoFirstSubKey(g_var1040, false))
		{
			decl String:var8[4];
			decl String:var60[52];
			do
			{
				if (KvGetSectionName(g_var1040, var8, 4) && var8[0]) // Array
				{
					KvGetString(g_var1040, NULL_STRING, var60, 51, _);
					if (CheckSkinWeapon_SkinsWeapons(arg12, arg16, var60, false))
					{
						AddMenuItem(var4, arg16, var60, 1);
					}
					else
					{
						AddMenuItem(var4, arg16, var60, 0);
					}
				}
			}
			while (KvGotoNextKey(g_var1040, false));
			KvGoBack(g_var1040);
		}
		KvGoBack(g_var1040);
	}
	if (GetMenuItemCount(var4) == 0)
	{
		AddMenuItem(var4, "", "Не найдены модели в файле", 1);
	}
	DisplayMenu(var4, arg12, 0);
}

public SelectWeaponName(Handle:menu, MenuAction:action, param1, param2) // address: 1499728
{
	switch (action)
	{
		case 16:
		{
			CloseHandle(menu);
		}
		case 8:
		{
			if (param2 == -6)
			{
				Func1494208(param1);
			}
		}
		case 4:
		{
			decl String:var16[16];
			decl String:var68[52];
			GetMenuItem(menu, param2, var16, 16, _, var68, 51);
			if (AddWeapon_SkinsWeapons(param1, var16, var68, g_var1572))
			{
				new var72 = GetIDClient_SkinsWeapons(param1);
				PushArrayString(g_var1044[param1], var16);
				decl String:var160[88];
				FormatEx(var160, 85, "INSERT INTO free (custom_id, weapon) VALUES (%d, '%s')", var72, var16);
				SQL_TQuery(g_var1036, SQL_DefCallback, var160, 0, DBPriority:1);
				new var164 = g_var1572 / 3600 / 24;
				if (var164)
				{
					PrintToChat(param1, "\x04[P.W] \x01Оружие \x03< %s > \x01добавлен в ваш инвентарь на %d дн. %d ч.", var68, var164, g_var1572 / 3600 % 24);
				}
				else
				{
					PrintToChat(param1, "\x04[P.W] \x01Оружие \x03< %s > \x01добавлен в ваш инвентарь на %d ч.", var68, g_var1572 / 3600 % 24);
				}
			}
			else
			{
				PrintToChat(param1, "\x04[P.W] \x01Оружие %s [%s] не найдено в файле models.txt", var68, var16);
				LogError("Not found %s - %s in file models.txt", var16, var68);
			}
			Func1494208(param1);
		}
	}
}

Func1502036(arg12) // address: 1502036
{
	new Handle:var4 = CreateMenu(SelectInfoAll, MenuAction:28);
	SetMenuExitBackButton(var4, true);
	SetMenuTitle(var4, "Информация об оружиях:\n \n");
	if (KvJumpToKey(g_var1040, "info", false))
	{
		if (KvGotoFirstSubKey(g_var1040, false))
		{
			decl String:var108[104];
			do
			{
				if (KvGetSectionName(g_var1040, var108, 101))
				{
					AddMenuItem(var4, var108, var108, 0);
				}
			}
			while (KvGotoNextKey(g_var1040, false));
			KvGoBack(g_var1040);
		}
		KvGoBack(g_var1040);
	}
	if (GetMenuItemCount(var4) == 0)
	{
		AddMenuItem(var4, "", "Нет информации", 1);
	}
	DisplayMenu(var4, arg12, 0);
}

public SelectInfoAll(Handle:menu, MenuAction:action, param1, param2) // address: 1504068
{
	switch (action)
	{
		case 16:
		{
			CloseHandle(menu);
		}
		case 8:
		{
			if (param2 == -6)
			{
				Func1490704(param1);
			}
		}
		case 4:
		{
			decl String:var104[104];
			GetMenuItem(menu, param2, var104, 101, _, _, 0);
			Func1505732(param1, var104);
		}
	}
}

Func1505732(arg12, const String:arg16[]) // address: 1505732
{
	new Handle:var4 = CreatePanel(INVALID_HANDLE);
	decl String:var116[112];
	FormatEx(var116, 110, "%s\n \n", arg16);
	SetPanelTitle(var4, var116, false);
	if (KvJumpToKey(g_var1040, "info", false))
	{
		if (KvJumpToKey(g_var1040, arg16, false))
		{
			if (KvGotoFirstSubKey(g_var1040, false))
			{
				decl String:var372[256];
				do
				{
					if (KvGetSectionName(g_var1040, var372, 255) && var372[0]) // Array
					{
						KvGetString(g_var1040, NULL_STRING, var372, 255, _);
						DrawPanelText(var4, var372);
					}
				}
				while (KvGotoNextKey(g_var1040, false));
				KvGoBack(g_var1040);
			}
			KvGoBack(g_var1040);
		}
		KvRewind(g_var1040);
	}
	DrawPanelText(var4, "\n \n");
	DrawPanelItem(var4, "Назад \n \n", 0);
	DrawPanelItem(var4, "Выход", 0);
	SendPanelToClient(var4, arg12, Select_Panel, 0);
	CloseHandle(var4);
}

public Select_Panel(Handle:menu, MenuAction:action, param1, param2) // address: 1508252
{
	if (action == MenuAction:4 && param2 == 1)
	{
		Func1502036(param1);
	}
}

Func1509168(arg12) // address: 1509168
{
	new Handle:var4 = CreateMenu(SelectSetting, MenuAction:28);
	SetMenuExitBackButton(var4, true);
	SetMenuTitle(var4, "Очистка Базы Данных:\n \n");
	AddMenuItem(var4, "all", "Удалить все оружия \n \n", 0);
	if (KvGotoFirstSubKey(g_var1040, false))
	{
		decl String:var20[16];
		decl String:var36[16];
		do
		{
			if (KvGetSectionName(g_var1040, var20, 16) && var20[0] && strcmp(var20, "info", true)) // Array
			{
				Func1513368(var20, var36, 16);
				AddMenuItem(var4, var20, var36, 0);
			}
		}
		while (KvGotoNextKey(g_var1040, false));
		KvGoBack(g_var1040);
	}
	KvGoBack(g_var1040);
	DisplayMenu(var4, arg12, 0);
}

public SelectSetting(Handle:menu, MenuAction:action, param1, param2) // address: 1510816
{
	switch (action)
	{
		case 16:
		{
			CloseHandle(menu);
		}
		case 8:
		{
			if (param2 == -6)
			{
				Func1490704(param1);
			}
		}
		case 4:
		{
			decl String:var64[64];
			if (param2 == 0)
			{
				FormatEx(var64, 61, "DELETE FROM free");
				SQL_TQuery(g_var1036, SQL_DefCallback, var64, 0, DBPriority:1);
				for (new var68 = 1; var68 <= MaxClients; var68++)
				{
					if (IsClientInGame(var68))
					{
						ClearArray(g_var1044[var68]);
					}
				}
				PrintToChat(param1, "\x04[P.W] \x01Вы очистили Базу Данных!");
			}
			else
			{
				decl String:var80[16];
				GetMenuItem(menu, param2, var80, 16, _, _, 0);
				FormatEx(var64, 61, "DELETE FROM free WHERE `weapon` = '%s'", var80);
				SQL_TQuery(g_var1036, SQL_DefCallback, var64, 0, DBPriority:1);
				PrintToChat(param1, "\x04[P.W] \x01Вы очистили \x03< %s > \x01 из Базы Данных!", var80);
				for (new var84 = 1; var84 <= MaxClients; var84++)
				{
					if (IsClientInGame(var84))
					{
						new var88 = FindStringInArray(g_var1044[var84], var80);
						if (var88 != -1)
						{
							RemoveFromArray(g_var1044[var84], var88);
						}
					}
				}
			}
			Func1509168(param1);
		}
	}
}

Func1513368(const String:arg12[], String:arg16[], arg20) // address: 1513368
{
	arg20--;
	new var4 = 0;
	while (arg12[var4] || var4 < arg20)
	{
		if (IsCharLower(arg12[var4]))
		{
			arg16[var4] = CharToUpper(arg12[var4]);
		}
		else
		{
			arg16[var4] = arg12[var4];
		}
		var4++;
	}
	arg16[var4] = 0;
}

public Action:Command(client, args) // address: 1515064
{
	if (client > 0)
	{
		Func1490704(client);
	}
	return Action:3;
}
