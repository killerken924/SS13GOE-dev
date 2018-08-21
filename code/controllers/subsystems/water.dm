var/Created_Water=0
var/Current_Water_Amount=0
GLOBAL_LIST_EMPTY(flooded_turfs)
GLOBAL_LIST_EMPTY(water_obj)
PROCESSING_SUBSYSTEM_DEF(water)
	name = "Water"
	wait = 1
	flags = SS_NO_INIT
	priority = SS_PRIORITY_AIR
/datum/controller/subsystem/processing/water/fire(resumed = FALSE)
	if (!resumed)
		current_run = processing.Copy()	// Defined in parent.
	while (GLOB.flooded_turfs.len||GLOB.water_obj.len)
		for(var/obj/effect/actual_water/W in GLOB.water_obj)
			W.do_water()
		return
/mob/living/carbon/human/verb/get_destroyed_and_created_water()
	var/bleh=0
	for(var/obj/effect/actual_water/A in world)
		bleh+=1
	Current_Water_Amount=bleh
	to_chat(world,"[Created_Water]")
	to_chat(world,"[Current_Water_Amount]")

