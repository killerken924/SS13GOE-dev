/obj/item/organ/external/proc/damage_internal(brute, burn, damage_flags, used_weapon = null,blocked)
	var/damage_amt=brute
	var/sharp = (damage_flags & DAM_SHARP)
	var/edge  = (damage_flags & DAM_EDGE)
	var/pointy = brute && sharp &&!edge
	var/laser = (damage_flags & DAM_LASER)
	var/blunt = brute && !sharp && !edge

	var/list/victims = list()
	var/organ_prob_mod=0
	if(blocked)
		organ_prob_mod=blocked/4//Armor can help stop these things.
	for(var/obj/item/organ/internal/I in internal_organs)

		if(I.damage < I.max_damage && prob(I.relative_size-organ_prob_mod))
			victims += I
			if(pointy)//pointy is direct, so only one organ
				break
	if(!victims.len)
		victims += pick(internal_organs)
	for(var/obj/item/organ/victim in victims)
		victim.take_damage(damage_amt)
		if(laser)
			burn /= 2

		else if(sharp)
			spread_germs_to_organ(src,owner)
		if(istype(victim,/obj/item/organ/internal/))
			var/obj/item/organ/internal/I=victim
			if(damage_amt>I.internal_bleed_threshold)
				if(pointy)
					switch(damage_amt)
						if(I.internal_bleed_threshold to 15)
							if(prob(15))
								I.make_internal_bleed(1)
						if(15 to 30)
							if(prob(33))
								I.make_internal_bleed(2)
						if(30 to 50)
							if(prob(55))
								I.make_internal_bleed(3)
						if(50 to INFINITY)
							if(prob(75))
								I.make_internal_bleed(6)

				else if (edge)
					switch(damage_amt)
						if(I.internal_bleed_threshold to 15)
							if(prob(5))
								I.make_internal_bleed(1)
						if(15 to 30)
							if(prob(15))
								I.make_internal_bleed(2)
						if(30 to 50)
							if(prob(33))
								I.make_internal_bleed(3)
						if(50 to INFINITY)
							if(prob(55))
								I.make_internal_bleed(6)

				else if(blunt)
					switch(damage_amt)
						if(I.internal_bleed_threshold to 15)
							if(prob(5))
								I.make_internal_bleed(1)
						if(15 to 30)
							if(prob(15))
								I.make_internal_bleed(2)
						if(30 to 50)
							if(prob(50))
								I.make_internal_bleed(3)
						if(50 to INFINITY)
							if(prob(80))
								I.make_internal_bleed(6)

		brute /= 2
		damage_amt /= 2
		to_chat(world,"organ victim=[victim],damage_amt=[damage_amt]")
