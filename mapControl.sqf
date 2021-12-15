// Map sector control by Ares aka FunnyCookieEver >> https://steamcommunity.com/id/funnycookieever/
// Version 0.16

/*
0 - neutral
1 - west
2 - east
3 - resistance
*/

// Functions

ARES_mapControl = {
	_allSectors = [];
	_allControllers = [];
	_allMarkers = [];

	ARES_allSectors = _allSectors;
	ARES_allControllers = _allControllers;
	ARES_allMarkers = _allMarkers;
};

ARES_initSectors = {
	_allSectorsLocations = nearestLocations [mapCenter, ["NameCity", "NameCityCapital", "NameVillage"], 12000];

	_allSectors = [];
	_allControllers = [];
	_allMarkers = [];
	
	{
		_allSectors pushBack locationPosition _x;
	} forEach _allSectorsLocations;

	{
		_sectorController = createVehicle ["Sign_Arrow_F", _x];
		_sectorController setVehiclePosition [getPos _sectorController, [], 0, "CAN_COLLIDE"];
		_sectorController setVariable ["ARES_sectorController", 0, true];
		hideObjectGlobal _sectorController;
		_sectorController enableSimulationGlobal false;
		_allControllers pushBack _sectorController; 
		_sectorMarker = createMarker [str _sectorController, _x];
		_sectorMarker setMarkerType "c_unknown";
		_allMarkers pushBack _sectorMarker; 
	} forEach _allSectors;

	ARES_allSectors append _allSectors;
	ARES_allControllers append _allControllers;
	ARES_allMarkers append _allMarkers;
};

ARES_setSector = {
	{
		if (_x inArea "AO_BLUFOR" || _x inArea "AO_BLUFOR_1" || _x inArea "AO_BLUFOR_2" || _x inArea "AO_BLUFOR_3") then { [_x, 1, false] call ARES_updateSector; };
		if (_x inArea "AO_OPFOR" || _x inArea "AO_OPFOR_1" || _x inArea "AO_OPFOR_2" || _x inArea "AO_OPFOR_3") then { [_x, 2, false] call ARES_updateSector; };
		if (_x inArea "AO_GUER" || _x inArea "AO_GUER_1" || _x inArea "AO_GUER_2" || _x inArea "AO_GUER_3") then { [_x, 3, false] call ARES_updateSector; };
	} forEach ARES_allControllers;
};

ARES_updateSector = {
	params ["_sectorController", "_sectorOwner", "_notify"];

	_sectorController setVariable ["ARES_sectorController", _sectorOwner, true];
	if (_notify != false) then {
		switch (_sectorOwner) do {
			case 0: { str _sectorController setMarkerType "c_unknown"; [civilian] remoteExecCall ["ARES_notifySector", 0]; };
			case 1: { str _sectorController setMarkerType "b_unknown"; [west] remoteExecCall ["ARES_notifySector", 0]; };
			case 2: { str _sectorController setMarkerType "o_unknown"; [east] remoteExecCall ["ARES_notifySector", 0]; };
			case 3: { str _sectorController setMarkerType "n_unknown"; [resistance] remoteExecCall ["ARES_notifySector", 0]; };
			default { str _sectorController setMarkerType "c_unknown"; [civilian] remoteExecCall ["ARES_notifySector", 0]; };
		};
	} else {
		switch (_sectorOwner) do {
			case 0: { str _sectorController setMarkerType "c_unknown"};
			case 1: { str _sectorController setMarkerType "b_unknown"};
			case 2: { str _sectorController setMarkerType "o_unknown"};
			case 3: { str _sectorController setMarkerType "n_unknown"};
			default { str _sectorController setMarkerType "c_unknown"};
		};
	};
	
};

ARES_activateSector = {
	params ["_sectorController"];

	while {alive _sectorController} do {
		if (((({side _x == west && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != west && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 1)) then {
			[west] remoteExecCall ["ARES_attackSector", 0];
			_sectorMarker = createMarker [str (getPos _sectorController), getMarkerPos str _sectorController];
			_sectorMarker setMarkerType "selector_selectedMission";
			sleep 60;
			if (((({side _x == west && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != west && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 1)) then {
				[_sectorController, 1, true] call ARES_updateSector;
			};
			deleteMarker _sectorMarker;
		};
		if (((({side _x == east && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != east && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 2)) then {
			[east] remoteExecCall ["ARES_attackSector", 0];
			_sectorMarker = createMarker [str (getPos _sectorController), getMarkerPos str _sectorController];
			_sectorMarker setMarkerType "selector_selectedMission";
			sleep 60;
			if (((({side _x == east && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != east && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 2)) then {
				[_sectorController, 2, true] call ARES_updateSector;
			};
			deleteMarker _sectorMarker;
		};
		if (((({side _x == resistance && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != resistance && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 3)) then {
			[resistance] remoteExecCall ["ARES_attackSector", 0];
			_sectorMarker = createMarker [str (getPos _sectorController), getMarkerPos str _sectorController];
			_sectorMarker setMarkerType "selector_selectedMission";
			sleep 60;
			if (((({side _x == resistance && _x distance _sectorController < 300} count allUnits) / 2) > {(side _x != resistance && side _x != civilian) && _x distance _sectorController < 300} count allUnits) && (_sectorController getVariable ["ARES_sectorController", 0] != 3)) then {
				[_sectorController, 3, true] call ARES_updateSector;
			};
			deleteMarker _sectorMarker;
		};
		sleep 60;
	};
};

ARES_notifySector = {
	params ["_side"];

	switch (_side) do {
		case west: { ["Default",["Карта", "Сектор захвачен", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_airdrop_ca.paa"]] call BIS_fnc_showNotification };
		case east: { ["Default",["Карта", "Сектор захвачен", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_cluster_ca.paa"]] call BIS_fnc_showNotification };
		case resistance: { ["Default",["Карта", "Сектор захвачен", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_minedispenser_ca.paa"]] call BIS_fnc_showNotification };
		case civilian: { ["Default",["Карта", "Сектор захвачен", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_leaflets_ca.paa"]] call BIS_fnc_showNotification };
		default { ["Default",["Карта", "Сектор захвачен", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_leaflets_ca.paa"]] call BIS_fnc_showNotification };
	};
};

ARES_attackSector = {
	params ["_side"];

	switch (_side) do {
		case west: { ["Default",["Карта", "Сектор атакован", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_airdrop_ca.paa"]] call BIS_fnc_showNotification };
		case east: { ["Default",["Карта", "Сектор атакован", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_cluster_ca.paa"]] call BIS_fnc_showNotification };
		case resistance: { ["Default",["Карта", "Сектор атакован", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_minedispenser_ca.paa"]] call BIS_fnc_showNotification };
		case civilian: { ["Default",["Карта", "Сектор атакован", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_leaflets_ca.paa"]] call BIS_fnc_showNotification };
		default { ["Default",["Карта", "Сектор атакован", "\A3\ui_f_orange\Data\CfgOrange\Missions\orange_leaflets_ca.paa"]] call BIS_fnc_showNotification };
	};
};

ARES_createSector = {
	if (!isServer) exitWith {};
	params ["_position", "_side"];
	
	_sectorController = createVehicle ["Sign_Arrow_F", _position];
	_sectorController setVehiclePosition [getPos _sectorController, [], 0, "CAN_COLLIDE"];
	_sectorController setVariable ["ARES_sectorController", 0, true];
	hideObjectGlobal _sectorController;
	_sectorController enableSimulationGlobal false;
	ARES_allControllers pushBack _sectorController; 
	_sectorMarker = createMarker [str _sectorController, _position];
	_sectorMarker setMarkerType "c_unknown";
	ARES_allMarkers pushBack _sectorMarker;

	[_sectorController, _side, false] call ARES_updateSector;
};

ARES_saveSectors = {
	_savedSectors = [];

	{
		_sectorData = [[getPos _x, _x getVariable ["ARES_sectorController", 0]]];
		_savedSectors append _sectorData;
	} forEach ARES_allControllers;

	profileNamespace setVariable ["ARES_savedSectors", _savedSectors];
};

ARES_loadSectors = {
	_savedSectors = profileNamespace getVariable ["ARES_savedSectors", [[]]];
	{
		_sectorControllerPosition = (_x select 0);
		_sectorOwner = (_x select 1);

		[_sectorControllerPosition, _sectorOwner] call ARES_createSector;

	} forEach _savedSectors;
};

// Init

if (isServer) then {
	[] call ARES_mapControl;
	if (("autoLoad" call BIS_fnc_getParamValue) == 0) then {
		[] call ARES_initSectors;
		[] call ARES_setSector;
		{
			[_x] spawn ARES_activateSector;
		} forEach ARES_allControllers;
		// [[19426.4,1048.89,146.025], 1] call ARES_createSector;
	};
};