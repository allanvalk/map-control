// Map sector control by Ares aka FunnyCookieEver >> https://steamcommunity.com/id/funnycookieever/
// Version 0.30

/* Side codes
0 - neutral
1 - west
2 - east
3 - resistance
*/

// Init

ARES_activationDistance = 1000;
ARES_aiBehaviour = "default";
ARES_logistics = true;
ARES_activeFactions = [resistance];

/* ARES_logistics
Enable ambient logistic routes and logistic system
*/

/* ARES_aiBehaviour
0 - default
1 - attack
2 - defence
*/

// Defines

/// west

ARES_WEST_Fireteam = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam");
ARES_WEST_Squad = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad");
ARES_WEST_AT = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AT");
ARES_WEST_Officer = "B_Soldier_VR_F";

ARES_WEST_Vehicles_Support = ["B_Truck_01_Repair_F", "B_Truck_01_fuel_F", "B_Truck_01_ammo_F"];
ARES_WEST_Vehicles_Car = ["B_MRAP_01_F", "B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"];
ARES_WEST_Vehicles_APC = ["B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"];
ARES_WEST_Vehicles_Tank = ["B_MBT_01_cannon_F"];
ARES_WEST_Vehicles_AA = ["B_APC_Tracked_01_AA_F"];

/// east

ARES_EAST_Fireteam = (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam");
ARES_EAST_Squad = (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad");
ARES_EAST_AT = (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT");
ARES_EAST_Officer = "O_Soldier_VR_F";

ARES_EAST_Vehicles_Support = ["O_Truck_03_repair_F", "O_Truck_03_fuel_F", "O_Truck_03_ammo_F"];
ARES_EAST_Vehicles_Car = ["O_MRAP_02_F", "O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F"];
ARES_EAST_Vehicles_APC = ["O_APC_Wheeled_02_rcws_v2_F", "O_APC_Tracked_02_cannon_F"];
ARES_EAST_Vehicles_Tank = ["O_MBT_02_cannon_F"];
ARES_EAST_Vehicles_AA = ["O_APC_Tracked_02_AA_F"];

/// resistance

ARES_GUER_Fireteam = (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam");
ARES_GUER_Squad = (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad");
ARES_GUER_AT = (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam_AT");
ARES_GUER_Officer = "I_Soldier_VR_F";

ARES_GUER_Vehicles_Support = ["B_Truck_01_Repair_F", "B_Truck_01_fuel_F", "B_Truck_01_ammo_F"];
ARES_GUER_Vehicles_Car = ["I_MRAP_03_F", "I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"];
ARES_GUER_Vehicles_APC = ["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"];
ARES_GUER_Vehicles_Tank = ["I_MBT_03_cannon_F"];
ARES_GUER_Vehicles_AA = ["I_LT_01_AA_F"];

/// civilian
/*
ARES_CIV_Fireteam = ();
ARES_CIV_Squad = ();
ARES_CIV_AT = ();
ARES_CIV_Officer = "";
*/
// Functions

ARES_convoyHandler = {
	params ["_side", "_type", "_startSector", "_endSector"];

	_convoyList = [];
	_roadList = [];
	_sidePrefabString = "ARES_";
	_start = getPosATL ([getPosATL _startSector, 300] call BIS_fnc_nearestRoad);
	_end = getPosATL ([getPosATL _endSector, 300] call BIS_fnc_nearestRoad);

	switch (_side) do {
		case west: { 
			_sidePrefabString = _sidePrefabString + "WEST";
		};
		case east: {
			_sidePrefabString = _sidePrefabString + "EAST";
		};
		case resistance: { 
			_sidePrefabString = _sidePrefabString + "GUER";
		};
		default { };
	};

	switch (_type) do {
		case "general": { 
			_vehiclePrefab = _sidePrefabString + "_Vehicles_Car";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 1)];
			_convoyList append _vehicle;
			_vehiclePrefab = _sidePrefabString + "_Vehicles_APC";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 0)];
			_convoyList append _vehicle;
			_vehiclePrefab = _sidePrefabString + "_Vehicles_Support";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 0)];
			_convoyList append _vehicle;
			_vehiclePrefab = _sidePrefabString + "_Vehicles_Support";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 1)];
			_convoyList append _vehicle;
			_vehiclePrefab = _sidePrefabString + "_Vehicles_Support";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 2)];
			_convoyList append _vehicle;
			_vehiclePrefab = _sidePrefabString + "_Vehicles_Car";
			_prefab = call compile _vehiclePrefab;
			_vehicle = [(_prefab select 0)];
			_convoyList append _vehicle;
		};
		case "repair": { };
		case "fuel": { };
		case "ammo": { };
		case "trasnport": { };
		default { };
	};

	_convoyGroup = createGroup _side;
	_convoyVehicles = [];

	_convoyGroup setFormation "COLUMN";
	_convoyGroup setBehaviour "SAFE";

	[_start, _end, _side, _convoyGroup, _convoyList, _convoyVehicles] spawn {
		params ["_start", "_end", "_side", "_convoyGroup", "_convoyList", "_convoyVehicles"];

		{
			_vehicle = [_start, ([_start, _end] call BIS_fnc_dirTo), _x, _side] call BIS_fnc_spawnVehicle;
			_convoyVehicles append [(_vehicle select 0)];
			if (_forEachIndex == 0) then {
				_waypoint = _convoyGroup addWaypoint [_end, 0];
				_waypoint setWaypointBehaviour "SAFE";
				_waypoint setWaypointFormation "COLUMN";
				_waypoint setWaypointSpeed "LIMITED";
			};
			(_vehicle select 0) setVehiclePosition [_start, [], 0, "CAN_COLLIDE"];
			units (_vehicle select 2) joinSilent _convoyGroup;
			waitUntil { (_vehicle select 0) distance _start > 15 };
		} forEach _convoyList;
		_waypoint = currentWaypoint _convoyGroup;
		[_convoyGroup, _waypoint] setWaypointStatements ["true", "[[_convoyGroup]] call deleteAnything; [[_convoyVehicles]] call deleteAnything;"];
	};
};

ARES_convoyAmbientController = { // TODO: Add deletion on completion functionality
	sleep 300;

	while {ARES_logistics} do {

		_requestSideNum = 0;
		_sideSectorList = [];

		_currentSide = selectRandom ARES_activeFactions;

		switch (_currentSide) do {
			case west: { _requestSideNum = 1 };
			case east: { _requestSideNum = 2 };
			case resistance: { _requestSideNum = 3 };
			default { };
		};

		{
			if (_x getVariable "ARES_sectorController" == _requestSideNum) then {
				_sideSectorList pushBack _x;
			};
		} forEach ARES_allControllers;

		_startSector = selectRandom _sideSectorList;

		_sideSectorList = _sideSectorList - [_startSector];

		_endSector = selectRandom _sideSectorList;

		[_currentSide, "general", _startSector, _endSector] call ARES_convoyHandler;

		sleep 1800;
	};
};

ARES_populateBuilding = {
	params ["_side", "_group", "_building"];

	_buildingPositions = [_building] call BIS_fnc_buildingPositions;
	_popultaionGroup = [getPos _building, _side, _group] call BIS_fnc_spawnGroup;

	{
		if (count _buildingPositions != 0) then {
			_position = selectRandom _buildingPositions;
			_buildingPositions deleteAt (_buildingPositions findIf {_position in _buildingPositions});
			_x setPos _position;
			doStop _x;
		} else {
			deleteVehicle _x;
		};
	} forEach units _popultaionGroup;

	_popultaionGroup;
};

ARES_populatePatrol = {
	params ["_side", "_group", "_sector"];

	_popultaionGroup = [_sector, _side, _group] call BIS_fnc_spawnGroup;
	[_popultaionGroup, _sector, 100] call BIS_fnc_taskPatrol;

	_popultaionGroup;
};

ARES_populateDefence = {
	params ["_side", "_group", "_sector"];

	_randomPosition = _sector getPos [random 250, random 90];
	_safePosition = [_randomPosition, 0, 150, 5, 0, 20, 0] call BIS_fnc_findSafePos;

	_popultaionGroup = [_safePosition, _side, _group] call BIS_fnc_spawnGroup;
	[_popultaionGroup, _safePosition] call BIS_fnc_taskDefend;

	_popultaionGroup;
};

ARES_populateArea = {
	params ["_side", "_sectorObject", "_armament", "_civilians"];

	_sector = getPos _sectorObject;

	_unitsHandler = [];

	_sidePrefabString = "ARES_";
	
	_buildings = nearestObjects [_sector, ["house"], 300];
	_populationFloor = floor (count _buildings / 3);

	_groupPrefab = "";
	_prefab = call compile _groupPrefab;

	switch (_side) do {
		case west: { 
			_sidePrefabString = _sidePrefabString + "WEST";
		};
		case east: {
			_sidePrefabString = _sidePrefabString + "EAST";
		};
		case resistance: { 
			_sidePrefabString = _sidePrefabString + "GUER";
		};
		default { };
	};

	for [{ private _i = 0 }, { _i < _populationFloor }, { _i = _i + 1 }] do {
		_building = selectRandom _buildings;
		_buildings = _buildings - [_building];

		if (count ([_building] call BIS_fnc_buildingPositions) > 6) then {
			_groupPrefab = _sidePrefabString + "_Squad";
			_prefab = call compile _groupPrefab;
		} else {
			_groupPrefab = _sidePrefabString + "_Fireteam";
			_prefab = call compile _groupPrefab;
		};

		_unitsHandler append ([[_side, _prefab, _building] call ARES_populateBuilding]);
	};

	for [{ private _i = 0 }, { _i < _populationFloor }, { _i = _i + 1 }] do {
		switch (selectRandom [0, 1]) do {
			case 0: { _unitsHandler append ([[_side, _prefab, _sector] call ARES_populatePatrol]); };
			case 1: { _unitsHandler append ([[_side, _prefab, _sector] call ARES_populateDefence]); };
			default { };
		};
	};

	waitUntil { sleep 60; (({_x distance _sectorController < ARES_activationDistance} count allPlayers) == 0) };

	[_unitsHandler] call deleteAnything;
	_sectorController setVariable ["ARES_sectorActive", false, true];
};

ARES_mapControl = {
	_allSectors = [];
	_allControllers = [];
	_allMarkers = [];

	ARES_allSectors = _allSectors;
	ARES_allControllers = _allControllers;
	ARES_allMarkers = _allMarkers;
};

ARES_initSectors = {
	_allSectorsLocations = nearestLocations [mapCenter, ["Name", "NameCity", "NameCityCapital", "NameVillage"], 12000];

	_allSectors = [];
	_allControllers = [];
	_allMarkers = [];
	
	{
		_allSectors pushBack locationPosition _x;
	} forEach _allSectorsLocations;

	{
		_sectorController = createVehicle ["Helper_Base_F", _x];
		_sectorController setVehiclePosition [getPos _sectorController, [], 0, "CAN_COLLIDE"];
		_sectorController setVariable ["ARES_sectorController", 0, true];
		_sectorController setVariable ["ARES_sectorActive", false, true];
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
		if ((({_x distance _sectorController < ARES_activationDistance} count allPlayers) > 0) && (_sectorController getVariable "ARES_sectorActive" != true)) then {
			_sectorController setVariable ["ARES_sectorActive", true, true];
			switch (_sectorController getVariable "ARES_sectorController") do {
				case 1: { [west, _sectorController, 1, false] call ARES_populateArea; };
				case 2: { [east, _sectorController, 1, false] call ARES_populateArea; };
				case 3: { [resistance, _sectorController, 1, false] call ARES_populateArea; };
				default {  };
			};
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
	
	_sectorController = createVehicle ["Helper_Base_F", _position];
	_sectorController setVehiclePosition [getPos _sectorController, [], 0, "CAN_COLLIDE"];
	_sectorController setVariable ["ARES_sectorController", 0, true];
	_sectorController setVariable ["ARES_sectorActive", false, true];
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

ARES_defenceSector = {
	params ["_requestSide"];

	_requestSideNum = 0;

	switch (_requestSide) do {
		case west: { _requestSideNum = 1 };
		case east: { _requestSideNum = 2 };
		case resistance: { _requestSideNum = 3 };
		default { };
	};

	_friendlySectorList = [];
	_friendlyPotentialSectorList = [];
	_enemySectorList = [];
	_enemyPotentialSectorList = [];

	{
		if (_x getVariable "ARES_sectorController" == _requestSideNum) then {
			_friendlySectorList pushBack _x;
		};
	} forEach ARES_allControllers;
	
	{
		if (_x getVariable "ARES_sectorController" != _requestSideNum && _x getVariable "ARES_sectorController" != 0) then {
			_enemySectorList pushBack _x;
		};
	} forEach ARES_allControllers;

	_nearestSectors = nearestObjects [selectRandom _friendlySectorList, ["Helper_Base_F"], 12000];
	{
		if (_x getVariable "ARES_sectorController" != _requestSideNum && _x getVariable "ARES_sectorController" != 0) then {
			_enemyPotentialSectorList pushBack _x;
		};
	} forEach _nearestSectors;

	_nearestSectors = nearestObjects [(_enemyPotentialSectorList select 0), ["Helper_Base_F"], 12000];
	{
		if (_x getVariable "ARES_sectorController" == _requestSideNum) then {
			_friendlyPotentialSectorList pushBack _x;
		};
	} forEach _nearestSectors;
	
	_defenceSector = (_friendlyPotentialSectorList select 0);
	_attackSector = (_enemyPotentialSectorList select 0);

	_enemySide = objNull;
	_enemySideCfg = objNull;

	switch (_attackSector getVariable "ARES_sectorController") do {
		case 1: { _enemySide = west };
		case 2: { _enemySide = east };
		case 3: { _enemySide = resistance };
		default { _enemySide = resistance };
	};

	_enemySideCfgFireteam = call compile (format ["ARES_%1_Fireteam", _enemySide]);
	_enemySideCfgSquad = call compile (format ["ARES_%1_Squad", _enemySide]);
	_enemySideCfgAT = call compile (format ["ARES_%1_AT", _enemySide]);

	_targetAssault_1 = [getPos _attackSector, _enemySide, _enemySideCfgSquad] call BIS_fnc_spawnGroup;
	_targetAssault_2 = [getPos _attackSector, _enemySide, _enemySideCfgSquad] call BIS_fnc_spawnGroup;
	_targetAssault_3 = [getPos _attackSector, _enemySide, _enemySideCfgFireteam] call BIS_fnc_spawnGroup;
	_targetAssault_4 = [getPos _attackSector, _enemySide, _enemySideCfgFireteam] call BIS_fnc_spawnGroup;
	_targetAssault_5 = [getPos _attackSector, _enemySide, _enemySideCfgAT] call BIS_fnc_spawnGroup;

	_attackGroups = [_targetAssault_1, _targetAssault_2, _targetAssault_3, _targetAssault_4, _targetAssault_5];
	_aliveUnits = 0;

	{
		_aliveUnits = _aliveUnits + count units _x;
	} forEach _attackGroups;

	{
		_wp = _x addWaypoint [getPos _defenceSector, 100];
		_wp setWaypointType "SAD";
	} forEach _attackGroups;

	[format ["defenceSector%1", _requestSide], _requestSide, ["Противник планирует атаку на данный сектор. Его необходимо удержать.","Удержать сектор",""], getPos _defenceSector, "CREATED", -1, true, true, "", true] call BIS_fnc_setTask;

	timeout = false;

	[] spawn {
		sleep 3600;
		timeout = true;
	};

	waitUntil {sleep 15, (timeout) || (_defenceSector getVariable "ARES_sectorController" != _requestSideNum) || (({ alive _x } count units _targetAssault_1 <= 1) && ({ alive _x } count units _targetAssault_2 <= 1) &&({ alive _x } count units _targetAssault_3 <= 1) &&({ alive _x } count units _targetAssault_4 <= 0) &&({ alive _x } count units _targetAssault_5 <= 1))};

	if ((format ["defenceSector%1", _requestSide] call BIS_fnc_taskState) == "CANCELED") then {
		[_defenceSector, _attackSector getVariable "ARES_sectorController", true] call ARES_updateSector;
	};

	if (_defenceSector getVariable "ARES_sectorController" != _requestSideNum) then {
		[format ["defenceSector%1", _requestSide],"FAILED"] call BIS_fnc_taskSetState;
		[_requestSide] remoteExecCall ["ARES_cancelTask", 2];
	};

	if (timeout || (({ alive _x } count units _targetAssault_1 <= 1) && ({ alive _x } count units _targetAssault_2 <= 1) && ({ alive _x } count units _targetAssault_3 <= 1) && ({ alive _x } count units _targetAssault_4 <= 0) && ({ alive _x } count units _targetAssault_5 <= 1))) then {
		[format ["defenceSector%1", _requestSide],"SUCCEEDED"] call BIS_fnc_taskSetState;
		sleep 1;
		[format ["defenceSector%1", _requestSide],"CREATED"] call BIS_fnc_taskSetState;
		sleep 0.1;
		[format ["defenceSector%1", _requestSide]] call BIS_fnc_deleteTask;
	};

	sleep 120;

	[_attackGroups] call deleteAnything;
};

// Init

if (isServer) then {
	[] call ARES_mapControl;
	if (("autoLoad" call BIS_fnc_getParamValue) == 0) then {
		[] call ARES_initSectors;
		[] call ARES_setSector;

		[[3000.03,2999.8,0], 1] call ARES_createSector;
		[[1990.06,3003.67,0], 1] call ARES_createSector;
		[[3000.08,4999.9,0], 2] call ARES_createSector;
		[[5000.08,4999.96,0], 3] call ARES_createSector;
		[[5000.01,2999.84,0], 0] call ARES_createSector;
		[[4001.52,4009.33,0], 0] call ARES_createSector;

		{
			[_x] spawn ARES_activateSector;
		} forEach ARES_allControllers;

		[] spawn ARES_convoyAmbientController;
	};
};