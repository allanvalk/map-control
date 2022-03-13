// execVM

_nil = [] execVM "mapControl.sqf";

deleteAnything = {
	params ["_input"];
	{
		if ((typeName _x) == "OBJECT") then {
			deleteVehicle _x;
		};
		if ((typeName _x) == "STRING") then {
			deleteMarker _x;
		};
		if ((typeName _x) == "GROUP") then {
			{
				deleteVehicle _x;
			} forEach units _x;
		};
		if ((typeName _x) == "ARRAY") then {
			{
				deleteVehicle _x;
			} forEach _x;
		};
	} forEach _input;
};

[] spawn {
	sleep 15;
	while {true} do {
		game removeCuratorEditableObjects [ARES_allControllers, true];
		sleep 5;
	};
};