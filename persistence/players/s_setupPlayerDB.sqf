//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

doSavePlayerData = {
	_array = _this select 1;
	
	_handle = _array spawn sqlite_savePlayer;	
	_clientId = owner (_array select 2);
	_sendResponse = _array select 3;
	
	waitUntil {sleep 0.1; scriptDone _handle};
	confirmSave = _sendResponse;
	_clientId publicVariableClient 'confirmSave';
} call mf_compile;

"savePlayerData" addPublicVariableEventHandler
{
	_this spawn doSavePlayerData; //need to call this with spawn otherwise the waitUntil wouldn't work
};

"requestPlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	_UID = getPlayerUID _player;
	
	if (_UID call sqlite_exists) then
	{
		applyPlayerData = _UID call sqlite_readPlayer;
	}
	else
	{
		applyPlayerData = [];
	};

	(owner _player) publicVariableClient "applyPlayerData";
};

