/datum/actual_grab
	var/name
	var/mob/living/carbon/human/victim = null
	var/mob/living/carbon/human/attacker = null
	var/target_zone
	var/obj/item/organ/external/GrabbedOrgan

	var/can_throw=0
	var/body_shield=0

	var/grab_slowdown=5
	var/stop_move =0
	var/can_carry=0
	var/datum/actual_grab/upgrade=null
	var/datum/actual_grab/downgrade=null

	var/obj/item/grab/grab_item

	var/same_tile=1
	var/shift = 0
	var/stamina_take=0.1

/datum/actual_grab/New(obj/item/grab/G)
	victim=G.victim
	attacker=G.attacker
	target_zone=G.target_zone
	GrabbedOrgan=G.GrabbedOrgan
	grab_item=G
/datum/actual_grab/Del()
	reset_position()
	..()
/datum/actual_grab/proc/Upgrade()
	if(upgrade)
		grab_item.grab=new upgrade(grab_item)
		attacker.visible_message("<span class='danger'>[attacker] has upgraded their grab on [victim]'s [GrabbedOrgan.name]!</span>")
		qdel(src)
		return 1
	return 0
/datum/actual_grab/proc/Downgrade()
	if(downgrade)
		grab_item.grab=downgrade
		attacker.visible_message("<span class='danger'>[attacker] has weakened their grab on [victim]'s [GrabbedOrgan.name]!</span>")
		qdel(src)
		return 1
	return 0


/datum/actual_grab/proc/Grab_Process()
	if(!istype(victim))
		del grab_item

	if(attacker.anchored || victim.anchored)
		del grab_item

	if(!attacker.Adjacent(victim))
		del grab_item
	return

/datum/actual_grab/weak
	name="weak"
	upgrade=/datum/actual_grab/strong

/datum/actual_grab/strong
	name="strong"
	downgrade=/datum/actual_grab/weak
	body_shield=1
	stamina_take=0.4
	grab_slowdown=5
	can_carry=1

	can_throw=1

/datum/actual_grab/carry
	name="carry"
	downgrade=/datum/actual_grab/strong
	body_shield=0
	stamina_take=0.8
	grab_slowdown=4
	can_throw=1
/datum/actual_grab/carry/New(obj/item/grab/G)
	..(G)
	victim.lying=0
	Adjust_Po()
	victim.forceMove(attacker.loc)

/datum/actual_grab/carry/Grab_Process()//Carrying takes stamina
	if(victim.lying)
		victim.lying=0
	if(attacker.lying)
		Grab_Drop()
	var/stam=stamina_take
	var/datum/realskills/attackerstrength=attacker.Skills.get_skill(/datum/realskills/strength)
	if(attackerstrength&&attackerstrength.points)
		stam-=attackerstrength.points/20
	attacker.Do_Stamina(stamina_take)
	..()


/datum/actual_grab/proc/Grab_Drop()
	to_chat(attacker,"<span class='danger'>Fails</span>")
	victim.forceMove(attacker.loc)
	var/dmg=rand(1,15)
	if(prob(33))//bad
		dmg+=rand(5,20)
		victim.apply_damage(dmg, BRUTE, ran_zone())//, blocked, damage_flags, used_weapon=I)
	attacker.apply_damage(dmg, BRUTE, ran_zone())//, blocked, damage_flags, used_weapon=I)
	attacker.Weaken(5)
	if(victim)
		victim.Weaken(5)
		victim.forceMove(attacker.loc)
	playsound(attacker.loc,pick('sound/weapons/punch1.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'),25, 1, -1)
	reset_position()
	del grab_item
/datum/actual_grab/proc/Adjust_Po()
	return

/datum/actual_grab/carry/Adjust_Po()
	animate(victim, pixel_x = 0, pixel_y = 15, 5, 1, LINEAR_EASING)
	grab_item.draw_affecting_over()
	victim.set_dir(attacker.dir)
	return

/datum/actual_grab/proc/reset_position()
	if(!victim.buckled)
		animate(victim, pixel_x = 0, pixel_y = 0, 4, 1, LINEAR_EASING)
	victim.reset_plane_and_layer()

/datum/actual_grab/proc/throw_held()
	var/obj/item/grab/G=grab_item
	if(can_throw)
		. = victim
		var/mob/thrower = attacker

		animate(victim, pixel_x = 0, pixel_y = 0, 4, 1)

		G = thrower.get_inactive_hand()
		if(!istype(G))	return .
		return .
	return null




