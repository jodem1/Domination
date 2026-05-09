// by Domination fork — intercept Shift+T when operating UAV; vanilla ping does not sync from UAV feed
//#define __DEBUG__
#include "..\x_setup.sqf"

params ["_disp", "_key", "_shift", "_ctrl", "_alt"];

if (missionNamespace getVariable ["d_with_uavping_sync", 1] == 0) exitWith {false};

// DIK_T = 20 (default tactical ping with Shift)
if (!(_key == 20 && _shift && {!_ctrl && !_alt})) exitWith {false};
if (!d_player_canu) exitWith {false};

private _uav = getConnectedUAV player;
if (isNull _uav) exitWith {false};

private _ar = UAVControl _uav;
private _controlling = false;
if (count _ar == 4) then {
	if (
		(_ar # 0 == player && {(_ar # 1) in ["GUNNER", "DRIVER"]})
		|| {_ar # 2 == player && {(_ar # 3) in ["GUNNER", "DRIVER"]}}
	) then {
		_controlling = true;
	};
} else {
	if (_ar # 0 == player && {(_ar # 1) in ["GUNNER", "DRIVER"]}) then {
		_controlling = true;
	};
};
if (!_controlling) exitWith {false};

private _t = missionNamespace getVariable ["d_uavping_lastsend", -1e9];
if (time - _t < 1.5) exitWith {true};

private _from = positionCameraToWorld [0, 0, 0];
private _to = positionCameraToWorld [0, 0, 1e7];
private _hits = lineIntersectsSurfaces [AGLToASL _from, AGLToASL _to, cameraOn, objNull, true, 1, "NONE", "NONE"];
private _posASL = if (_hits isEqualTo []) then {
	AGLToASL (screenToWorld [0.5, 0.5])
} else {
	(_hits # 0) # 0
};

missionNamespace setVariable ["d_uavping_lastsend", time];
[player, _posASL] remoteExecCall ["d_fnc_uavpingrelay", 2];
true
