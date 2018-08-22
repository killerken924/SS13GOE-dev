/obj/elevator_map_holder
	name = "elevator map holder"
	icon = 'icons/obj/elevator.dmi'
	icon_state="Floor"
	var/depth = 2
	var/lift_size_x = 1
	var/lift_size_y = 1

/obj/elevator_map_holder/Initialize()
	. =..()
	var/turf/simulated/floor/main_elevator_floor/Flr=new/turf/simulated/floor/main_elevator_floor(src.loc)
//	var/datum/elevator/E=
	new/datum/elevator(Flr,2,NORTH)
	qdel(src)
	return 1