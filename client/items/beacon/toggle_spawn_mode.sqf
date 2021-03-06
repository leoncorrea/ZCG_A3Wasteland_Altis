/*********************************************************#
# @@ScriptName: toggle_spawn_mode.sqf
# @@Author: Nick 'Panaetius' 
# @@Create Date: 2013-09-11 15:11:52
# @@Modify Date: 2013-09-15 23:28:23
# @@Function: Swaps between halo jump and regular spawn
#*********************************************************/

#include "mutex.sqf"
#define ANIM "AinvPknlMstpSlayWrflDnon_medic"
#define DURATION 5
#define ERR_CANCELLED "Changing spawn permissions cancelled"
#define ERR_TOO_FAR_AWAY "Changing spawn permissions failed as you moved too far away!"
#define ERR_SOMEONE_ELSE_TAKEN "Changing spawn permissions failed, as someone else finished packing it up before you!"
#define ERR_NO_GROUP "You must be in a group to enable group spawn restrictions"

private ["_beacon", "_error", "_hasFailed", "_success"];
_beacon = [] call mf_items_spawn_beacon_nearest;
_error = [_beacon] call mf_items_spawn_beacon_can_pack;
if (_error != "") exitWith {[_error, 5] call mf_notify_client};

_hasFailed = {
	private ["_progress", "_beacon", "_caller", "_failed", "_text"];
	_progress = _this select 0;
	_beacon = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case not(alive player): {}; // player dead, no error msg needed
		case not(vehicle player == player): {};
        case (isNull _beacon): {_text = ERR_SOMEONE_ELSE_TAKEN};
		case not(player distance _beacon < 5): {_text = ERR_TOO_FAR_AWAY};
		case (doCancelAction): {doCancelAction = false; _text = ERR_CANCELLED};
		//case (count units group player < 2): {_text = ERR_NO_GROUP};
		default {
			_text = format["Spawn beacon is %1%2 updated", round(_progress*100), "%"];
			_failed = false;
        };
    };
    [_failed, _text];
};

_currentSpawnMode = _beacon getVariable ["haloJump", false];

MUTEX_LOCK_OR_FAIL;
_success = true; //[DURATION, ANIM, _hasFailed, [_beacon]] call mf_util_playUntil;
MUTEX_UNLOCK;

if (_success) then {
	if (_currentSpawnMode) then {
		["The Spawn Beacon now spawns players on the ground", 5] call mf_notify_client;
		_beacon setVariable ['haloJump', false, true];
	} else {
		["The Spawn Beacon now spawns players with a Halo Jump", 5] call mf_notify_client;
		_beacon setVariable ['haloJump', true, true];
	};
	
	_beacon setVariable ["GenerationCount", 0, true];
	
	updateBeacon = _beacon;
	publicVariableServer "updateBeacon";
};
