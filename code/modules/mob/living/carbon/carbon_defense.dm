
/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	if(prob(blocked)) //armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		damage_flags &= ~(DAM_SHARP|DAM_EDGE)
	if(ishuman(user))
		var/mob/living/carbon/human/H=user
		var/datum/realskills/strength_skill=H.Skills.get_skill(/datum/realskills/strength)
		if(strength_skill.points>=5)
			effective_force*=strength_skill.points/5
	var/datum/wound/created_wound = apply_damage(effective_force, I.damtype, hit_zone, blocked, damage_flags, used_weapon=I)

	//Melee weapon embedded object code.
	if(istype(created_wound) && I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/weapon_sharp = (damage_flags & DAM_SHARP)
		var/weapon_edge = (damage_flags & DAM_EDGE)
		//var/weapon_point = weapon_sharp &&!weapon_edge

		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		if (blocked)
			damage *= blocked_mult(blocked)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class
		var/datum/realskills/attacker_strength_skill=0
		if(weapon_edge)//if your slashing, low chance of getting it stuck, but if you are stabbing, higher chance.
			embed_chance = embed_chance/4
		if(ishuman(user))
			var/mob/living/carbon/human/H=user
			attacker_strength_skill=H.Skills.get_skill(/datum/realskills/strength).points
			embed_chance-=attacker_strength_skill*5
		if(embed_chance>0)
			if(damage > embed_threshold && prob(embed_chance))//(weapon_sharp && damage > (10*I.w_class))
				src.embed(I, hit_zone, supplied_wound = created_wound)
	if(!ishuman(src))
		Do_Stamina(effective_force/10)
	to_chat(world,"effective force =[effective_force]")
	return 1
