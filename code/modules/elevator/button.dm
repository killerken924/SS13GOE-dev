/obj/structure/elevator/button
	name="Elevator Console"
	var/datum/elevator/E=null
/obj/structure/elevator/button/attack_generic(var/mob/user)
	return attack_hand(user)

/obj/structure/elevator/button/attack_hand(var/mob/user)
	return interact(user)
/obj/structure/elevator/button/interact(var/mob/user)
	return
