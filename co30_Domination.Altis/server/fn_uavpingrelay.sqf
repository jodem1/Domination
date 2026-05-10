// by Domination fork — validate UAV ping and fan out to group members only
//#define __DEBUG__
#include "..\x_setup.sqf"

params ["_unit", "_posASL"];

if (!isServer) exitWith {};
if (missionNamespace getVariable ["d_with_uavping_sync", 1] == 0) exitWith {};
if (owner _unit != remoteExecutedOwner) exitWith {};
if !(_unit isKindOf "Man" && {isPlayer _unit}) exitWith {};
if (_posASL isEqualType [] && {count _posASL < 3}) exitWith {};

private _uav = getConnectedUAV _unit;
if (isNull _uav) exitWith {};
if (_posASL distance (getPosASL _uav) > 12000) exitWith {};

private _grp = group _unit;
if (isNull _grp) exitWith {};

private _dur = missionNamespace getVariable ["d_uavping_duration", 10];
private _exp = serverTime + _dur;
[netId _unit, name _unit, _posASL, _exp] remoteExecCall ["d_fnc_uavpingshow", _grp, false];
