// by Domination fork — group-synced tactical ping while controlling a UAV (Shift+T)
//#define __DEBUG__
#include "..\x_setup.sqf"

if (!hasInterface) exitWith {};
if (missionNamespace getVariable ["d_with_uavping_sync", 1] == 0) exitWith {};

0 spawn {
	scriptName "d_uavping_init";
	waitUntil {!isNull player && {!isNull findDisplay 46}};
	missionNamespace setVariable ["d_uavping_notes", []];
	(findDisplay 46) displayAddEventHandler ["KeyDown", {_this call d_fnc_uavpingkeydown}];
};
