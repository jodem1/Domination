// by Domination fork — validate UAV ping and fan out to group members only
//#define __DEBUG__
#include "..\x_setup.sqf"

params ["_unit", "_posASL", ["_uavNetId", ""]];

if (!isServer) exitWith {};
if (missionNamespace getVariable ["d_with_uavping_sync", 1] == 0) exitWith {};
if (owner _unit != remoteExecutedOwner) exitWith {};
if !(_unit isKindOf "Man" && {isPlayer _unit}) exitWith {};
if (_posASL isEqualType [] && {count _posASL < 3}) exitWith {};

// Dedicated server often has getConnectedUAV _unit == objNull; client sends UAV netId (see fn_uavpingkeydown)
private _uav = objNull;
if (_uavNetId isEqualType "" && {!(_uavNetId isEqualTo "")}) then {
	_uav = objectFromNetId _uavNetId;
};
if (isNull _uav) then {
	_uav = getConnectedUAV _unit;
};
if (isNull _uav) exitWith {};

private _ar = UAVControl _uav;
private _controlling = false;
if (count _ar == 4) then {
	if (
		(_ar # 0 == _unit && {(_ar # 1) in ["GUNNER", "DRIVER"]})
		|| {_ar # 2 == _unit && {(_ar # 3) in ["GUNNER", "DRIVER"]}}
	) then {
		_controlling = true;
	};
} else {
	if (_ar # 0 == _unit && {(_ar # 1) in ["GUNNER", "DRIVER"]}) then {
		_controlling = true;
	};
};
if (!_controlling) exitWith {};

if (_posASL distance (getPosASL _uav) > 12000) exitWith {};

private _grp = group _unit;
if (isNull _grp) exitWith {};

private _dur = missionNamespace getVariable ["d_uavping_duration", 10];
private _exp = serverTime + _dur;
[netId _unit, name _unit, _posASL, _exp] remoteExecCall ["d_fnc_uavpingshow", _grp, false];
