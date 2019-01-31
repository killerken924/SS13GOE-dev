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
	var/travel_direction=SOUTH

	var/warm_up_time=50
	var/warming_up=0
	var/start_warm_up_time=50

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
/datum/advancedshuttle/proc/Start_Warm_Up(target)
	if(!target)
		if(location==landed)
			target=docked
		else if(location==docked)
			target=landed
	if(!warming_up)
		warming_up=1
		start_warm_up_time=world.time
		destination=target
		warming_up_advanced_shuttles+=src
		playsound(centerturf,'sound/effects/5secwarmup.ogg', 100, 1,skiprandfreq=1)

/datum/advancedshuttle/proc/Warm_Up(target)
	warming_up=0
	start_warm_up_time=0
	warming_up_advanced_shuttles-=src
	Start_Warp(destination)

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
		Apply_G_Force(travel_direction)
		Move(intermission)
		moving_advanced_shuttles+=src


/datum/advancedshuttle/proc/Can_Drop()
	if(launched_time+transit_speed<world.time)
		return TRUE
	return FALSE

/datum/advancedshuttle/proc/Drop_From_Warp()
	if(destination&&location!=destination)
		to_chat(world,"dropped from warp,destination=[destination]")
		moving_advanced_shuttles-=src
		moving=0
		Apply_G_Force(turn(travel_direction, 180))//opposite of forward.
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

/datum/advancedshuttle/proc/Apply_G_Force(direction)
	world.log<<"Apply g called direciton=[direction]"
	for(var/turf/T in turflist)
		for(var/atom/movable/A in T.contents)
			if(!A.anchored)
				world.log<<"throwning [A] at [Get_Farthest_Turf(T,direction)] direciton=[direction]"
				A.throw_at(Get_Farthest_Turf(T,direction),10)
	return 1

/datum/advancedshuttle/proc/Get_Farthest_Turf(turf/T,direction)
	if(T&&direction)
		var/list/turfs_2_return=list()
		for(var/turf/TT in turflist)
			if(get_dir(T,TT)==direction)
				turfs_2_return+=TT
		var/turf/furthest
		for(var/turf/TT in turflist)
			if(!furthest)
				furthest=TT
				continue
			if(furthest)
				switch(direction)
					if(NORTH)
						if(TT.y>furthest.y)
							furthest=TT
							continue
					if(SOUTH)
						if(TT.y<furthest.y)
							furthest=TT
							continue
					if(EAST)
						if(TT.x>furthest.x)
							furthest=TT
							continue
					if(WEST)
						if(TT.x<furthest.x)
							furthest=TT
							continue
		if(!furthest)
			furthest=get_step(T,direction)
		return furthest
	return get_step(T,direction)

/datum/advancedshuttle/proc/Make_Warp_Sound()
	for(var/turf/T in turflist)
		for(var/mob/M in T.contents)
			M<<'sound/effects/placeholdershipsound.ogg'







