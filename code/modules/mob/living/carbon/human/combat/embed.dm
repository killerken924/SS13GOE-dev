/mob/living/carbon/proc/embed_chance(obj/item/I, mob/living/user, var/effective_force, var/damage_flags,datum/wound/created_wound,var/blocked,var/hit_zone)
	var/weapon_sharp = (damage_flags & DAM_SHARP)
	var/weapon_edge = (damage_flags & DAM_EDGE)
	var/weapon_pointy=	weapon_sharp && !weapon_edge
	var/damage=effective_force
	var/embed_prob=0
	var/embed_threshold=10

	if(blocked)
		damage*= blocked_mult(blocked)
	if(weapon_edge)//edged
		if(I.w_class>3)//If its a large weapon, and edged. it can get embeded easier
			embed_prob+=I.w_class*5// Huge weapons would add 25%, and tiny would add 5%
	if(weapon_pointy)//pointy
		if(I.w_class<3)//If its a samll weapon, and pointy. it can get embeded easier
			embed_prob+=I.w_class*5// Small weapons would add 10%, and tiny would add 5%

	if(ishuman(user))
		var/datum/realskills/attacker_strength_skill=0
		var/mob/living/carbon/human/H=user
		attacker_strength_skill=H.Skills.get_skill(/datum/realskills/strength).points
		embed_prob-=attacker_strength_skill*3//If you had 5 skill, you would remove 10%

	if( (damage>embed_threshold)&&embed_prob>0)
		if(prob(embed_prob))
			src.embed(I, hit_zone, supplied_wound = created_wound)