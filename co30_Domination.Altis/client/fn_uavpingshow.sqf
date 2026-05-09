// by Domination fork — show group UAV ping (map + 3D list for Draw3D)
//#define __DEBUG__
#include "..\x_setup.sqf"

params ["_srcNetId", "_pingerName", "_posASL", "_expireAt"];

if (_posASL isEqualType [] && {count _posASL < 3}) exitWith {};

private _notes = missionNamespace getVariable ["d_uavping_notes", []];
private _filtered = [];
{
	if (count _x >= 4) then {
		_x params ["_pASL", "_exp", "_txt", "_mname"];
		private _oldSrc = if (count _x > 4) then {_x # 4} else {""};
		if (_oldSrc isNotEqualTo "" && {_oldSrc isEqualTo _srcNetId}) then {
			deleteMarkerLocal _mname;
		} else {
			_filtered pushBack _x;
		};
	};
} forEach _notes;

private _mname = format ["d_uavping_%1_%2_%3", floor serverTime, floor (random 1e8), clientOwner];
[
	_mname,
	ASLToAGL _posASL,
	"ICON",
	"ColorYellow",
	[0.75, 0.75],
	format ["UAV ping: %1", _pingerName],
	0,
	"mil_dot"
] call d_fnc_CreateMarkerLocal;

_filtered pushBack [_posASL, _expireAt, format ["UAV: %1", _pingerName], _mname, _srcNetId];
missionNamespace setVariable ["d_uavping_notes", _filtered];
