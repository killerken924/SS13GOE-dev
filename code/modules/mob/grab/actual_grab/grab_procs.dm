/obj/item/grab/proc/force_danger()
	return
/obj/item/grab/proc/adjust_position(var/force = 0)
	to_chat(world,"called adjust_position")
//	if(force)	victim.forceMove(attacker.loc)

/obj/item/grab/proc/stop_move()
	return grab.stop_move
/obj/item/grab/proc/can_absorb()
	return
/obj/item/grab/proc/force_stand()
	if(istype(grab,/datum/actual_grab/carry))
		return 1
	return grab.body_shield
/obj/item/grab/proc/restrains()
	return
/obj/item/grab/proc/throw_held()
	return grab.throw_held()
/obj/item/grab/proc/handle_resist()
	return
/obj/item/grab/proc/shield_assailant()
	return
/obj/item/grab/proc/point_blank_mult()
	return
/obj/item/grab/proc/force_drop()
	return
/obj/item/grab/proc/resolve_openhand_attack()
	return
/obj/item/grab/proc/resolve_item_attack(mob/living/user, obj/item/I, target_zone)
	return
/obj/item/grab/proc/attacker_reverse_facing()//assailant_reverse_facing
	return
/obj/item/grab/proc/assailant_moved()//assailant_reverse_facing
	return

/client/proc/Process_Grab()
	//if we are being grabbed
	/*if(isliving(mob))
		var/mob/living/L = mob
		if(L.grabbed_by.len)
			return
			L.resist() //shortcut for resisting grabs
	*/
	return 0
/obj/item/grab/proc/attempt_carry()
	if(grab.can_carry)
		to_chat(attacker,"<span class='danger'>[attacker] starts putting [victim] on his back! </span>")
		if(do_mob(attacker, victim, 15))
			var/datum/actual_grab/carry/grabcarry=new/datum/actual_grab/carry(src)
			var/datum/actual_grab/old_grab=grab
			grab=grabcarry
			qdel(old_grab)
			attacker.visible_message("<span class='danger'>[attacker] puts [victim] on his back! </span>")
			return 1
		else//can do damage
			grab.Grab_Drop()
			return 0
	else
		to_chat(attacker,"<span class='notice'>You need a better grip to do that...</span>")
		return 0
/obj/item/grab/proc/draw_affecting_over()
	victim.plane = attacker.plane
	victim.layer = attacker.layer + 0.01

/obj/item/grab/proc/draw_affecting_under()
	victim.plane = attacker.plane
	victim.layer = attacker.layer - 0.01

/obj/item/grab/proc/grab_slowdown()
	var/move_delay=0
	var/datum/realskills/attackerstrength=attacker.Skills.get_skill(/datum/realskills/strength)
	if(attackerstrength&&attackerstrength.points)
		var/pt=grab.grab_slowdown
		pt-=attackerstrength.points/30
		move_delay = max(0,pt)
	else
		move_delay = max(0,grab.grab_slowdown)
	return move_delay

/obj/item/grab/proc/Do_Move(n,direct)
	if(istype(grab,/datum/actual_grab/carry))
		.=Do_Carry(n,direct)
		return .
	var/datum/realskills/attackerstrength=attacker.Skills.get_skill(/datum/realskills/strength)
	if(attackerstrength&&attackerstrength.points)
		var/pt=grab.stamina_take
		pt-=attackerstrength.points/30
		if(pt>0)
			attacker.Do_Stamina(grab.stamina_take-attackerstrength.points/4)
	else
		attacker.Do_Stamina(grab.stamina_take)
	var/turf/oldloc=attacker.loc
	if(victim)
		victim.forceMove(attacker.loc)
		if(victim.lying)
			attacker.visible_message("<span class='danger'>[attacker] drags [victim] across the [attacker.loc.name]!</span>")
	.=attacker.SelfMove(n, direct)
	attacker.set_dir(get_dir(attacker.loc,oldloc))
	grab.Adjust_Po()
	return .

/obj/item/grab/proc/Do_Carry(n,direct)
	var/datum/realskills/attackerstrength=attacker.Skills.get_skill(/datum/realskills/strength)
	if(attackerstrength&&attackerstrength.points)
		var/pt=grab.stamina_take
		pt-=attackerstrength.points/30
		if(pt>0)
			attacker.Do_Stamina(grab.stamina_take-attackerstrength.points/4)
	else
		attacker.Do_Stamina(grab.stamina_take)
	.=attacker.SelfMove(n, direct)
	if(victim)
		victim.forceMove(attacker.loc)
		victim.lying=0
	grab.Adjust_Po()
	return .

