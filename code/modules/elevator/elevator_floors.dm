/turf/simulated/floor/elevator_floor
	name="Elevator Floor"
	icon = 'icons/obj/elevator.dmi'
	icon_state = "Floor"
	var/datum/elevator/E=null
/turf/simulated/floor/elevator_floor/New(t,datum/elevator/Elv)
	E=Elv
	..(t)
/turf/simulated/floor/main_elevator_floor
	name="Elevator Floor"
	icon = 'icons/obj/elevator.dmi'
	icon_state = "Floor"
	var/datum/elevator/E=null

//turf/simulated/floor/main_elevator_floor/New(t)
	//E=new/datum/elevator(src)
//	..(t)