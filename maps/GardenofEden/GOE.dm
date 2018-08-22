#if !defined(using_map_DATUM)

	#include "goe_areas.dm"
	#include "GOE_elevator.dm"
	#include "GOE1.dmm"
	#include "GOE2.dmm"

	//#include "example-2.dmm"
	//#include "example-3.dmm"

	#define using_map_DATUM /datum/map/GOE

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
