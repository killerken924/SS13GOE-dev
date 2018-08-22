/obj/structure/elevator
	icon='icons/obj/elevator.dmi'
/obj/structure/elevator/button
	name="Elevator Console"
	icon_state="panel"
	var/datum/elevator/E=null
	anchored=1
/obj/structure/elevator/button/New(t,datum/elevator/elv)
	E=elv
	..(t)
/obj/structure/elevator/button/attack_generic(var/mob/user)
	return attack_hand(user)
/obj/structure/elevator/button/attack_hand(var/mob/user)
	return Do_Button(user)
/obj/structure/elevator/button/interact(var/mob/user)
	return
/obj/structure/elevator/button/proc/Do_Button(var/mob/user)//next_floor
	if(!istype(user)) return

	var/dat = list()
	dat += "<html><body><hr><b>Lift panel</b><hr>"

	for(var/datum/elevatorfloor/F in E.SelectableFloor)
		//if(!E.current_floor==F)
		dat += "<a href='?src=\ref[src];move_to_[F.name]=1'>:[F.name]</font></a><br>"
	var/datum/browser/popup = new(user, "turbolift_panel", "Lift Panel", 230, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return
/obj/structure/elevator/button/OnTopic(user, href_list)
	if(!E.moving)
		for(var/datum/elevatorfloor/F in E.SelectableFloor)
			if(href_list["move_to_[F.name]"])
				E.next_floor=F
				E.Do_Elevator()
				return
	..()