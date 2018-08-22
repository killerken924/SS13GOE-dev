/obj/structure/elevator
	icon='icons/obj/elevator.dmi'
/obj/machinery/elevator_button
	name="Elevator Console"
	icon='icons/obj/elevator.dmi'
	icon_state="panel"
	var/datum/elevator/E=null
	anchored=1
	density=1
	var/activated=0
	var/timer_num=3
	var/timer=0
	var/datum/elevatorfloor/selected=null
/obj/machinery/elevator_button/New(t,datum/elevator/elv)
	E=elv
	..(t)

/obj/machinery/elevator_button/attack_generic(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator_button/attack_hand(var/mob/user)
	return Do_Button(user)

/obj/machinery/elevator_button/interact(var/mob/user)
	return

/obj/machinery/elevator_button/Process()
	if(stat & (BROKEN))
		return
	if(activated)
		if(timer<world.time)
			E.Do_Elevator(src)

/obj/machinery/elevator_button/proc/Do_Button(var/mob/user)//next_floor
	if(!istype(user)) return

	var/dat = list()
	if(!activated)
		dat += "<html><body><hr><b>Lift panel</b><hr>"
		for(var/datum/elevatorfloor/F in E.SelectableFloor)
			//if(!E.current_floor==F)
			dat += "<a href='?src=\ref[src];move_to_[F.name]=1'>:[F.name]</font></a><br>"
	else
		dat += "<html><body><hr><b>Activated</b><hr>"
	var/datum/browser/popup = new(user, "turbolift_panel", "Lift Panel", 230, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return

/obj/machinery/elevator_button/OnTopic(user, href_list)
	if(!E.moving&&!activated)
		for(var/datum/elevatorfloor/F in E.SelectableFloor)
			if(href_list["move_to_[F.name]"])
				if(E.current_floor==F)
					return
				selected=F
				activated=1
				timer=world.time+timer_num
				playsound(loc, "sound/effects/lift2.ogg", 50, 1)
	Do_Button(user)
	..()