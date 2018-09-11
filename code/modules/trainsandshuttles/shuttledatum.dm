var/list/shuttle_list=list()
/datum/advancedshuttle
	var/list/turflist=list()
	var/list/cordlist=list()

	var/area/docked
	var/area/landed
	var/area/intermission
	var/area/location
	var/area/destination
	var/turf/simulated/floor/main_shuttle_floor/centerturf

	var/landing_zone="Shuttle Planetary Landing 1"
	var/transit_zone="Shuttle Planetary Transit"
	var/shuttle_name="Planetary Shuttle"
	var/list/landing_zones=list()
	var/list/shuttle_transit_spots=list()
	var/moving=0
	var/transit_speed=50
	var/launched_time=0

/datum/advancedshuttle/New(turf/cntr)
	docked=GLOB.using_map.Default_Shuttle_Docked
	landed=GLOB.using_map.Default_Shuttle_Landed
	intermission=GLOB.using_map.Default_Shuttle_Intermission
	Make_Landing_Sights(cntr)

/datum/advancedshuttle/proc/Make_Landing_Sights(turf/cntr)
	if(cntr)

		centerturf=cntr
		location=docked
		//Make List of turfs
		for(var/turf/T in locate(docked))
			turflist+=T
		world.log<<"world.time=[world.time]"
		//Handle landing zone stuff
		for(var/obj/effect/advanced_shuttle_landmark/shuttle_landing_spot/C in advancedshuttle_landmarks)
			if(landing_zone==C.landing_zone_name)
				landing_zones+=C

		//Handle transit zone stuff
		for(var/obj/effect/advanced_shuttle_landmark/shuttle_transit_spot/C in advancedshuttle_landmarks)
			if(transit_zone==C.transit_zone_name)
				shuttle_transit_spots+=C

		//make cord list
		cordlist=list()
		for(var/turf/T in turflist)
			if(T==centerturf)
				continue
			cordlist+=T
			//cordlist[T]=list("x"=centerturf.x-T.x,"y"=centerturf.y-T.y)//Get x and y deltas, this is for retaining the shape of the shuttle, rigid transformations really...
			cordlist[T]=list("x"=T.x-centerturf.x,"y"=T.y-centerturf.y)//Get x and y deltas, this is for retaining the shape of the shuttle, rigid transformations really...

		//make landing areas
		for(var/obj/effect/advanced_shuttle_landmark/shuttle_landing_spot/C in landing_zones)
			var/turf/landingcenter=C.loc

			new landed(landingcenter)

			for(var/turf/T in turflist-centerturf)
				new landed(locate(landingcenter.x+cordlist[T]["x"],landingcenter.y+cordlist[T]["y"],landingcenter.z))

		//make intermission
		for(var/obj/effect/advanced_shuttle_landmark/shuttle_transit_spot/C in shuttle_transit_spots)
			var/turf/transitcenter=C.loc

			new intermission(transitcenter)

			for(var/turf/T in turflist-centerturf)
				new intermission(locate(transitcenter.x+cordlist[T]["x"],transitcenter.y+cordlist[T]["y"],transitcenter.z))

/datum/advancedshuttle/proc/Start_Warp(target)
	if(!target)
		if(location==landed)
			target=docked
		else if(location==docked)
			target=landed
	if(intermission)
		moving=1
		launched_time=world.time
		destination=target
		Move(intermission)
		moving_advanced_shuttles+=src
		//Make_Warp_Sound()

/datum/advancedshuttle/proc/Can_Drop()
	if(launched_time+transit_speed<world.time)
		return TRUE
	return FALSE

/datum/advancedshuttle/proc/Drop_From_Warp()
	if(destination&&location!=destination)
		to_chat(world,"dropped from warp,destination=[destination]")
		moving_advanced_shuttles-=src
		moving=0
		Move(destination)
		destination=null

/datum/advancedshuttle/proc/Move(target)
	if(!target)
		if(location==landed)
			target=docked
		else if(location==docked)
			target=landed
		else if(location==intermission)
			target=docked

	if(target)
		var/area/origin=locate(location)
		var/area/_destination=locate(target)
		origin.move_contents_to(_destination)
		location=target

/datum/advancedshuttle/proc/Make_Warp_Sound()
	for(var/turf/T in turflist)
		for(var/mob/M in T.contents)
			M<<'sound/effects/placeholdershipsound.ogg'







