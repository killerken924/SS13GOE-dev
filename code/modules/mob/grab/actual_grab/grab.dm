/mob/living/carbon/human/proc/make_grab(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/victim, var/grab_tag)
	if(!can_make_grab(attacker,victim))
		return 0
	new/obj/item/grab(attacker,victim)
	to_chat(world,"oof")
	return 1




/obj/item/grab
	name = "grab"

	var/mob/living/carbon/human/victim = null
	var/mob/living/carbon/human/attacker = null
	//icon='icons/mob/grabs.dmi'
	var/target_zone
	var/obj/item/organ/external/GrabbedOrgan
	w_class = ITEM_SIZE_NO_CONTAINER
	var/datum/actual_grab/grab
	icon='icons/mob/grabs.dmi'
	icon_state="weak"

/obj/item/grab/New(mob/living/carbon/human/_attacker,mob/living/carbon/human/_victim)
	..()
	attacker=_attacker
	victim	=_victim

	target_zone = attacker.zone_sel.selecting
	GrabbedOrgan= victim.get_organ(target_zone)
	attacker.put_in_active_hand(src)
	grab=new/datum/actual_grab/weak(src)
	attacker.visible_message("<span class='danger'>[attacker] grabbed [victim] by the [GrabbedOrgan]!</span>")
	victim.forceMove(attacker.loc)
	update_icons()

/obj/item/grab/proc/upgrade()
	if(grab.upgrade)
		grab.Upgrade()
	else
		to_chat(attacker,"<span class='danger'>You can not upgrade anymore!</span>")
	update_icons()

/obj/item/grab/proc/downgrade()
	if(grab.downgrade)
		grab.Downgrade()
	else
		qdel(src)
	update_icons()

/obj/item/grab/proc/update_icons()
	icon_state="grab_[grab.name]"
	return
/obj/item/grab/Process()
	grab.Grab_Process()
	if(!attacker||!victim)
		del src
	return
	if(!victim.grabbed_by.Find[src])
		victim.grabbed_by+=src
	grab.Grab_Process()


/obj/item/grab/proc/init()
	victim.update_canmove()
	adjust_position()
	update_icons()

/obj/item/grab/attack_self(mob/user)
	if(istype(grab,/datum/actual_grab/carry))
		to_chat(attacker,"<span class='danger'> You had to drop him first</span>")
		return 0
	if(user.a_intent==I_HELP)
		downgrade()
	else
		upgrade()
	return

/obj/item/grab/attack(mob/M, mob/living/user)
	//smack into shit
	to_chat(world,"attack")
	return

/obj/item/grab/dropped()
	qdel(src)
	return

/obj/item/grab/Destroy()
	attacker.visible_message("<span class='danger'>[attacker] lets go of [victim]'s [GrabbedOrgan.name]!</span>")
	if(victim)
		victim.grabbed_by=null
		victim.reset_plane_and_layer()
		victim = null
	if(attacker)
		attacker = null
	loc = null
	qdel(grab)
	return ..()

/mob/living/carbon/proc/can_make_grab(var/mob/living/carbon/human/attacker, var/mob/living/carbon/human/victim, var/grab_tag)
	// can't grab non-carbon/human/'s
	if(attacker==victim)
		return 0
	if(!istype(victim))
		return 0

	if(attacker.anchored || victim.anchored)
		return 0

	if(!attacker.Adjacent(victim))
		return 0

	for(var/obj/item/grab/G in victim.grabbed_by)
		if(G.attacker == attacker)//&& G.target_zone == target_zone)
			to_chat(attacker, "<span class='notice'>You already grabbed [victim]'s [G.GrabbedOrgan.name].</span>")
			return 0
	return 1



