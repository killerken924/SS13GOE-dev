/datum/map/GOE
	name = "GOE"
	full_name = "Garden of Eden"
	path = "GOE"

	lobby_icon = 'maps/GardenofEden/GOE_lobby.dmi'
	lobby_tracks = list(/music_track/firestarter)//Firestarter

	station_levels = list(1, 2)//, 3)
	contact_levels = list(1, 2)//, 3)
	player_levels = list(1, 2, 3,4)

	//allowed_spawns = list("Arrivals Shuttle")

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"

	//base_floor_type = /turf/simulated/open

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
	welcome_sound = 'sound/effects/cowboysting.ogg'
	Default_Shuttle_Docked=/area/goe/shuttle/Escape_shuttle_Station
	Default_Shuttle_Landed=/area/goe/shuttle/Escape_shuttle_Landing
	Default_Shuttle_Intermission=/area/goe/shuttle/Escape_shuttle_Intermission
	Intermission_Z=4

	procgeneration_levels=list(3)
	procgeneration_materials=list(1=list("Floor"=/turf/simulated/floor/asteroid,"Wall"=/turf/simulated/mineral))
	procgeneration_areas=list(1=/area/goe/miningunexplored_procedural)