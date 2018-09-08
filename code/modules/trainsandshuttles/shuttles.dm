var/list/CurrentShuttles=list()//This allows for a list to be transfered between death of the floor it self
/turf/simulated/floor/shuttle_floor
	name="Elevator Floor"
	icon = 'icons/obj/elevator.dmi'
	icon_state = "Floor"
	var/datum/newshuttle/shuttle=null //123,138,3
	var/shuttlename="Planetary Landing Module"
/turf/simulated/floor/shuttle_floor/verb/DoMagic()
	set src in oview(1)
	shuttle.Move()
/turf/simulated/floor/shuttle_floor/New()
	..()
	world.log<<"New floor"
	if(CurrentShuttles["[shuttlename]"])
		shuttle=CurrentShuttles["[shuttlename]"]
	if(!shuttle)
		world.log<<"new shuttle datum"
		shuttle=new/datum/newshuttle(get_area(src).type,GLOB.using_map.Default_Shuttle_Landed,3,123,138,src)
		if(shuttle)
			CurrentShuttles+=shuttlename
			CurrentShuttles[shuttlename]=shuttle

/datum/newshuttle
	var/list/contents=list()
	var/des
	var/x
	var/y
	var/area/landed
	var/area/docked
	var/area/location
	var/list/shuttle=list()
	var/turf/center
	var/z
/datum/newshuttle/New(area/_docked,area/_landed,z,x,y,turf/T)
	Initialize(_docked,_landed,z,x,y,T)


/datum/newshuttle/proc/Initialize(area/_docked,area/_landed,z,x,y,var/turf/centershuttlefloor)
	docked=_docked
	landed=_landed
	if(!_docked)
		docked=GLOB.using_map.Default_Shuttle_Docked
	if(!_landed)
		landed=GLOB.using_map.Default_Shuttle_Landed
	if(centershuttlefloor)
		location=get_area(centershuttlefloor).type
	if(!location)
		location=_docked
	to_chat(world,"location=[location]")
	for(var/turf/T in locate(location))
		contents+=T
		if(get_area(T).type!=location)
			new location(T)
		to_chat(world,"contents+=[T]")


	center=pick(contents)//centershuttlefloor//=pick(contents)
	shuttle=list()
	for(var/turf/T in contents)
		if(T==center)
			continue
		var/xdif=center.x-T.x
		var/ydif=center.y-T.y
		shuttle+=T
		shuttle[T]=list("xdif"=xdif,"ydif"=ydif)


	var/turf/newcenterlocation=locate(x,y,z)

	new _landed(newcenterlocation)
	for(var/turf/T in contents)
		if(T==center)
			continue
		var/list/Tlst=shuttle[T]
		var/xdif=Tlst["xdif"]
		var/ydif=Tlst["ydif"]
		var/turf/tlocation=locate(x+xdif,y+ydif,z)
		new _landed(tlocation)

/datum/newshuttle/proc/Move()
	var/area/destination
	to_chat(world,"Started move")
	if(location==landed)
		destination=docked
	else if(location==docked)
		destination=landed
	to_chat(world,"destination=[destination]")
	if(destination)
		var/area/origin=locate(location)
		destination=locate(destination)
		if(origin==destination)
			to_chat(world,"fail")
			return
		origin.move_contents_to(destination)
		location=destination.type
		to_chat(world,"move")







