/datum/elevator
	var/name="Elevator"
	var/list/Doors=list()
	var/list/Floors=list()
	var/list/Button=list()
	var/depth=2
	var/turf/mainturf=null
	var/x_size=1
	var/y_size=1
	var/list/SelectableFloor=list()
	var/direction=NORTH
	/*var/list/areas_to_use = list(
		/area/goe/mining_lift_1,
		/area/goe/mining_lift_2
		)*/
	var/list/areas_to_use=list()
	var/datum/elevatorfloor/current_floor=null
	var/datum/elevatorfloor/next_floor=null
	var/moving=0
/datum/elevator/New(turf/startturf,d=2,di=NORTH)
	depth=d
	mainturf=startturf
	direction=di
	Init_Elevator()

/datum/elevator/proc/Init_Elevator()
	//Add Buttons
	Button+=new/obj/machinery/elevator_button(mainturf,src)
	//create starting floor
	for(var/turf/T in block(locate(mainturf.x-x_size,mainturf.y-y_size,mainturf.z),locate(mainturf.x+x_size,mainturf.y+y_size,mainturf.z)))
		T.ChangeTurf(/turf/simulated/floor/elevator_floor,1,1)
		Floors+=T
		for(var/atom/A in T)
			if(!Button.Find(A))
				qdel(T)
		/*
		switch(direction)
			if(NORTH)
				if(T.y-mainturf.y==y_size)//So if the turf is far north and the direciton is north, place a door here.
					Doors+=new/obj/structure/elevator_doors(T)
			if(SOUTH)
				if(mainturf.y-T.y==y_size)//So if the turf is far south and the direciton is south, place a door here.
					Doors+=new/obj/structure/elevator_doors(T)
			if(EAST)
				if(T.x-mainturf.x==x_size)//So if the turf is far east and the direciton is east, place a door here.
					Doors+=new/obj/structure/elevator_doors(T)
			if(WEST)
				if(mainturf.x-T.x==x_size)//So if the turf is far wes and the direciton is west, place a door here.
					Doors+=new/obj/structure/elevator_doors(T)*/
	//Handle other floors and areas
	for(var/zcalc=0;zcalc<=depth-1;zcalc++)
		for(var/turf/T in block(locate(mainturf.x-x_size,mainturf.y-y_size,mainturf.z+zcalc),locate(mainturf.x+x_size,mainturf.y+y_size,mainturf.z+zcalc)))
			if(T.z==mainturf.z)
				continue
			T.ChangeTurf(/turf/simulated/open,1,1)
			Floors+=T
		SelectableFloor+=new/datum/elevatorfloor(mainturf.z+zcalc)
		for(var/turf/T in Floors)
			var/areatype=areas_to_use[T.z]
			var/area/A=new areatype(T)
			var/datum/elevatorfloor/flr=SelectableFloor[T.z]
			if(!flr.area_ref)
				flr.area_ref=A.type
	current_floor=SelectableFloor[mainturf.z]





/datum/elevator/proc/Do_Elevator(obj/machinery/elevator_button/B)
	if(!next_floor)
		next_floor=B.selected
	var/area/origin = locate(current_floor.area_ref)
	var/area/turbolift/destination = locate(next_floor.area_ref)
	if(origin==destination)
		return
	moving=1

	for(var/turf/T in destination)
		for(var/atom/movable/AM in T)
			if(istype(AM, /mob/living))
				var/mob/living/M = AM
				if(next_floor._z<current_floor._z)//if the mob is getting smashed, then it gets gibbed
					M.gib()
			else if(AM.simulated)
				qdel(AM)

	origin.move_contents_to(destination)
	current_floor=next_floor
	moving=0
	B.activated=0
	B.selected=null
	next_floor=null
//datum/elevator/proc/Replace_Floors
/datum/elevatorfloor
	var/_z
	var/name="Floor"
	var/area_ref
/datum/elevatorfloor/New(Z,X,Y)
	_z=Z
	name="Floor [_z]"
/datum/elevatorfloor/proc/set_area_ref(var/ref)
	var/area/turbolift/A = locate(ref)
	if(!istype(A))
		log_debug("Turbolift floor area was of the wrong type: ref=[ref]")
		return
	area_ref = ref
