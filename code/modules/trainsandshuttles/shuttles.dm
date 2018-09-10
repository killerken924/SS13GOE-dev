var/list/advancedshuttle_landmarks=list()
/obj/effect/advanced_shuttle_landmark
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101
/obj/effect/advanced_shuttle_landmark/Initialize()
	advancedshuttle_landmarks+=src

	..()
/obj/effect/advanced_shuttle_landmark/Destroy()
	advancedshuttle_landmarks-=src
	world.log<<"destroyed [src]"
	return ..()
/obj/effect/advanced_shuttle_landmark/shuttle_landing_spot
	name="Shuttle Planetary Landing"
	var/landing_zone_name="Shuttle Planetary Landing 1"


/obj/effect/advanced_shuttle_landmark/shuttle_transit_spot
	name="Shuttle Planetary Transit"
	var/transit_zone_name="Shuttle Planetary Transit"


/turf/simulated/floor/main_shuttle_floor
	name="Floor"
	icon = 'icons/obj/elevator.dmi'
	icon_state = "Floor"
	var/datum/advancedshuttle/shuttle=null
	var/shuttle_name="Planetary Shuttle"
/turf/simulated/floor/main_shuttle_floor/verb/shuttlemove()
	if(shuttle)
		shuttle.Move()


/turf/simulated/floor/main_shuttle_floor/Initialize()//New()
	if(!shuttle)
		if(shuttle_list[shuttle_name])
			shuttle=shuttle_list[shuttle_name]
		else
			shuttle=new/datum/advancedshuttle(src)
			shuttle_list+=shuttle_name
			shuttle_list[shuttle_name]=shuttle
	..()

/mob/living/carbon/human/verb/get_advancedshuttle_landmarks()
	to_chat(src,"advancedshuttle_landmarks.len=[advancedshuttle_landmarks.len]")
	for(var/C in advancedshuttle_landmarks)
		to_chat(src,"[C]")
