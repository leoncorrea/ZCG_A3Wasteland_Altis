//	@file Name: c_applyPlayerData.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

private ["_varValue", "_i", "_in", "_exe", "_backpack", "_sendToServer", "_uid", "_items"];
diag_log format["applyPlayerDBValues called with %1", _this];
_varValue = _this;
_uid = _varValue select 0;

// Donation error catch
if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {};

//if there is not a value for items we care about exit early
if (isNil '_varValue') exitWith {};

removeUniform player; 

_uniform = (_varValue select 6);
if (_uniform != "") then {
	player addUniform _uniform;
};

removeVest player; 

_vest = (_varValue select 5);
if (_vest != "") then {
	player addVest _vest;
};

removeBackpack player; 
_backpack = (_varValue select 7);
if (_backpack != "") then {
	player addBackpack _backpack;
};

removeHeadgear player; 
_headgear = (_varValue select 9);
if (_headgear != "") then {
	player addHeadgear _headgear;
};
_goggles = (_varValue select 8);
if( _goggles != "") then {
	player addGoggles _goggles;
};

_items = _varValue select 17;

// Inventory item section. Use mf_inventory_all as set up by the mf_inv system
{
	if ((_x select 2 ) == "inventoryItem") then {
		_entry = call compile (_x select 3); 
		[_entry select 0, _entry select 1, true] call mf_inventory_add;
	};
} forEach _items;

{
	if( (_x select 2 )== "Vest") then {
		_name = (_x select 3);
		
		player addItemToVest _name;
	};
} forEach _items;

{
	if( (_x select 2 ) == "Backpack") then {
		_name = (_x select 3);
		
		player addItemToBackpack _name;
	};
} forEach _items;

{
	if( (_x select 2 )== "Items") then {
		_name = (_x select 3);
		player addItemToUniform _name;
	};
} forEach _items;

player addWeapon (_varValue select 12);
player addWeapon (_varValue select 14);
player addWeapon (_varValue select 13);

{
	if( (_x select 2 )== "PrimaryWeaponItem") then {
		_name = (_x select 3);
		if (_name != "") then
		{
			player addPrimaryWeaponItem _name;
		};
	};
} forEach _items;
	
{
	if( (_x select 2 )== "SecondaryWeaponItem") then {
		_name = (_x select 3);
		if (_name != "") then
		{
			player addSecondaryWeaponItem _name;
		};
	};
} forEach _items;

{
	if( (_x select 2 )== "HandgunWeaponItem") then {
		_name = (_x select 3);
		if (_name != "") then
		{
			player addHandgunItem _name;
		};
	};
} forEach _items;

{
	if( (_x select 2 )== "AssignedItem") then {
		_name = (_x select 3);
		_inCfgWeapons = isClass (configFile >> "cfgWeapons" >> _name);
		if (_inCfgWeapons) then {
			// Its a 'weapon'
			player addWeapon _name;
		} else {
			player linkItem _name;
		};
	};
} forEach _items;

player setPos (call compile (_varValue select 10));

player setDir (parseNumber (_varValue select 11));
player setVariable ["cmoney", parseNumber (_varValue select 2), true];
player setDamage (parseNumber (_varValue select 4));
hungerLevel = parseNumber (_varValue select 15);
thirstLevel = parseNumber (_varValue select 16);
player switchMove "aidlppnemstpsraswrfldnon0s";