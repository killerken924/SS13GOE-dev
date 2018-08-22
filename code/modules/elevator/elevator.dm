
/obj/structure/elevator_doors
	name="Elevator Door"
	var/isopen=0
	icon='icons/obj/elevator.dmi'
	icon_state="Elevator_Door_0"
	anchored=TRUE

/obj/structure/elevator_doors/proc/Toggle_door(N)
	if(!N)
		isopen=!isopen
	else
		isopen=N
	Handle_Door()

/obj/structure/elevator_doors/proc/Handle_Door()
	if(isopen)
		visible_message("<span class='danger'>[src] closes</span>")
		for(var/mob/M in src.loc)
			M.gib()
		density=1
	else
		density=0
	update_icons()

/obj/structure/elevator_doors/proc/update_icons()
	icon_state="Elevator_Door_[isopen]"
	return







