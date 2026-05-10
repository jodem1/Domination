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
private _mtype = "mil_box";
private _label = format ["UAV (%1)", _pingerName];
[
	_mname,
	ASLToAGL _posASL,
	"ICON",
	"ColorWhite",
	[0.75, 0.75],
	_label,
	0,
	_mtype
] call d_fnc_CreateMarkerLocal;

_filtered pushBack [_posASL, _expireAt, _label, _mname, _srcNetId, _mtype];
missionNamespace setVariable ["d_uavping_notes", _filtered];

private _lastSnd = missionNamespace getVariable ["d_uavping_last_snd", -1e9];
if (time - _lastSnd > 1) then {
	playSound ["TacticalPing", true];
	missionNamespace setVariable ["d_uavping_last_snd", time];
};
