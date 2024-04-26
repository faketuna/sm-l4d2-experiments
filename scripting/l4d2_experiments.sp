#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.0.1"

#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3

#include <sourcemod>
#include <sdkhooks>

ConVar g_cvCustomSpeed;

public Plugin myinfo = 
{
    name = "[L4D2] Experiments",
    author = "faketuna",
    description = "Experiments features",
    version = PLUGIN_VERSION,
    url = ""
}

public void OnPluginStart() {
    g_cvCustomSpeed = CreateConVar("l4d2_experiments_survivor_move_speed", "220.0", "Specify the player's base movement speed", FCVAR_NOTIFY);
    
    for(int i = 1; i <= MaxClients; i++) {
        if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i))
            continue;
        hookAll(i);
    }
}

public void OnPluginEnd() {
    for(int i = 1; i <= MaxClients; i++) {
        if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i))
            continue;
        unhookAll(i);
    }
}

public void OnClientPutInServer(int client) {
    hookAll(client);
}

public void OnClientDisconnect(int client) {
    unhookAll(client);
}



void hookAll(int client) {
    SDKHook(client, SDKHook_PreThinkPost, postThink);
}

void unhookAll(int client) {
    SDKUnhook(client, SDKHook_PreThinkPost, postThink);
}

public Action postThink(int client) {
    if(GetClientTeam(client) != TEAM_SURVIVOR || !IsPlayerAlive(client))
        return Plugin_Continue;

    SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", g_cvCustomSpeed.FloatValue);
    return Plugin_Continue;
}