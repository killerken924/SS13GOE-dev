var/list/shuttle_list=list()
/datum/advancedshuttle
	var/list/turflist=list()
	var/list/cordlist=list()

	var/area/docked
	var/area/landed
	var/area/intermission
	var/area/location

	var/turf/simulated/floor/main_shuttle_floor/centerturf

	var/landing_zone="Shuttle Planetary Landing 1"
	var/transit_zone="Shuttle Planetary Transit"
	var/shuttle_name="Planetary Shuttle"
	var/list/landing_zones=list()
	var/list/shuttle_transit_spots=list()

/datum/advancedshuttle/New(turf/cntr)
	docked=GLOB.using_map.Default_Shuttle_Docked
	landed=GLOB.using_map.Default_Shuttle_Landed
	intermission=GLOB.using_map.Default_Shuttle_Intermission
	Make_Landing_Sights(cntr)
///datum/advancedshuttle/proc/get_cords(turf/T)
//	var/delta_x=centerturf.x-T.x
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

/datum/advancedshuttle/proc/Move(area/target)
	if(!target)
		if(location==landed)
			target=docked
		else if(location==docked)
			target=landed
	if(target)
		var/area/origin=locate(location)
		var/area/destination=locate(target)
		origin.move_contents_to(destination)
		location=target







