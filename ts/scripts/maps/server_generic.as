#include "func_vehicle_custom"
#include "ts/ts_script_loader"

void MapInit()
{
	// Parameter1: Register Hooks (assuming I'm supposed to set it to true)
	// Parameter2: Enable debug output
	VehicleMapInit(true, false);
    	
	TS_LoadWeapons();
}