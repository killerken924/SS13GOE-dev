/datum/map/PlanetSide
	name = "Planetside"
	full_name = "Planet Side"
	path = "PlanetSide"

	lobby_icon = 'maps/GardenofEden/GOE_lobby.dmi'
	lobby_tracks = list(/music_track/westvirginia)//Firestarter

	station_levels = list(1, 2)//, 3)
	contact_levels = list(1, 2)//, 3)
	player_levels = list(1, 2, 3)
	procgeneration_levels=list(1)
	procgeneration_materials=list(1=list("Floor"=/turf/simulated/floor/asteroid,"Wall"=/turf/simulated/mineral))
	procgeneration_areas=list(1=/area/planetside/miningunexplored_procedural)


	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"

	base_floor_type = /turf/simulated/mineral

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	//welcome_sound = 'sound/effects/cowboysting.ogg'

/obj/turbolift_map_holder/PlanetSide
	name = "planetside map placeholder"
	depth = 2
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/planetside/lift_1,
		/area/planetside/lift_2
		)


