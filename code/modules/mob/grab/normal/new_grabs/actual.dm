//datum/grab
/obj/item/grab/basic

	type_name = GRAB_NORMAL
	start_grab_name = GRAB_BASIC
	//var/obj/item/organ/external/GrabbedOrgan
	icon='icons/mob/screen1.dmi'
	var/wrenchcooldown=15
	var/wrenchcooldowntime

/obj/item/grab/basic/init()
	..()
	GrabbedOrgan=get_targeted_organ()
	if(affecting.w_uniform)
		affecting.w_uniform.add_fingerprint(assailant)

	assailant.put_in_active_hand(src)
	assailant.do_attack_animation(affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(assailant==affecting)
		visible_message("<span class='warning'>[assailant] has grabbed [assailant.gender==FEMALE ? "herself"  : "himself"] by the [GrabbedOrgan.name]!</span>")
	else
		visible_message("<span class='warning'>[assailant] has grabbed [affecting] by the [GrabbedOrgan.name]!</span>")
	affecting.grabbed_by += src

	//if(!(affecting.a_intent == I_HELP))
	//	upgrade(TRUE)

/datum/grab/basic
	state_name=GRAB_BASIC
	//start_grab_name = GRAB_BASIC
	upgrab_name=GRAB_STRONG

	icon_state = "basic"

/datum/grab/strong
	state_name=GRAB_STRONG

	upgrab_name=GRAB_WRENCH

	downgrab_name =GRAB_BASIC

	stop_move = 1
	reverse_facing = 0
	can_absorb = 0
	shield_assailant = 0
	point_blank_mult = 1
	same_tile = 0
	can_throw = 1
	force_danger = 1
	breakability = 3

	icon_state = "strong"

	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/strong/upgrade(obj/item/grab/G)
	if(upgrab&&istype(upgrab,/datum/grab/wrench))
		Attempt_Wrench(G)
		return 0
	..()
/datum/grab/strong/process_effect(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	if(G.assailant==G.affecting)//same person, can't strangle.
		if(affecting.lying)
			affecting.Weaken(4)
		if(G.target_zone==BP_NECK)
			affecting.adjustOxyLoss(5)

/datum/grab/strong/proc/Attempt_Wrench(obj/item/grab/basic/G)
	if(G.wrenchcooldowntime<world.time&&G.GrabbedOrgan)
		var/mob/living/carbon/human/assailant=G.assailant
		var/mob/living/carbon/human/affecting=G.affecting
		if(G.assailant==G.affecting)
			assailant.visible_message("<span class='danger'>[assailant] wrenches [assailant.gender==FEMALE ? "her"  : "his"] [G.GrabbedOrgan.name]</span>")
		else
			assailant.visible_message("<span class='danger'>[assailant] wrenches [affecting]'s [G.GrabbedOrgan.name]</span>")
		playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		Wrench(G)

/datum/grab/strong/proc/Wrench(obj/item/grab/basic/G)
	var/mob/living/carbon/human/assailant=G.assailant
	var/mob/living/carbon/human/affecting=G.affecting

	var/datum/realskills/assailant_strength_skill=assailant.Skills.get_skill(/datum/realskills/strength)
	var/staminadmg=0.1
	assailant.Do_Stamina(staminadmg)
	var/assailant_strength_mod=0
	if(assailant_strength_skill&&assailant_strength_skill.points)
		assailant_strength_mod=max(0,assailant_strength_skill.points*2)


	if(prob(75))
		G.GrabbedOrgan.jostle_bone()
	var/probvar=50
	if(assailant==affecting)
		probvar=75
	G.wrenchcooldowntime=world.time+G.wrenchcooldown

	switch(max(rand(1,100)+assailant_strength_mod,100))
		if(0 to 25)//dislocate
			affecting.DoScreenJitter(rand(1,5),rand(1,30),rand(1,30))
			if(G.GrabbedOrgan.dislocated)
				if(prob(probvar))
					G.GrabbedOrgan.undislocate()
					if(assailant==affecting)
						assailant.visible_message("<span class='danger'>[assailant] undislocated [assailant.gender==FEMALE ? "her"  : "his"] [G.GrabbedOrgan.name]!</span>")
					else
						assailant.visible_message("<span class='danger'>[assailant] undislocated [affecting]'s [G.GrabbedOrgan.name]</span>")
			else
				G.GrabbedOrgan.dislocate()
				if(assailant==affecting)
					assailant.visible_message("<span class='danger'>[assailant] dislocated [assailant.gender==FEMALE ? "her"  : "his"] [G.GrabbedOrgan.name]!</span>")
				else
					assailant.visible_message("<span class='danger'>[assailant] dislocated [affecting]'s [G.GrabbedOrgan.name]</span>")
		if(25 to 50)
			affecting.DoScreenJitter(rand(1,5),rand(1,55),rand(1,55))
			if(!(assailant==affecting))
				if(prob(40*assailant_strength_mod))
					G.GrabbedOrgan.fracture()
					affecting.DoScreenJitter(rand(1,10),rand(20,75),rand(20,55))
			else
				if(prob(15*assailant_strength_mod))
					G.GrabbedOrgan.fracture()
					affecting.DoScreenJitter(rand(1,10),rand(20,75),rand(20,55))

		//if(75 to 100)

/datum/grab/wrench
	upgrab=null
	state_name=GRAB_WRENCH
	upgrab_name=null
	icon_state = "grabbedwrench"