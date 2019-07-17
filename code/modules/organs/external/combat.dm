/obj/item/organ/external/proc/damage_internal(brute, burn, damage_flags, used_weapon = null,blocked)
	var/damage_amt=brute
	var/sharp = (damage_flags & DAM_SHARP)
	var/edge  = (damage_flags & DAM_EDGE)
	var/pointy = brute && sharp &&!edge
	var/laser = (damage_flags & DAM_LASER)
	var/blunt = brute && !sharp && !edge

	var/list/victims = list()
	var/organ_prob_mod=0
	var/passed_pierce_threshold=0//This is required for a pointy weapon to break through a bone.
	if(pointy&&damage_amt>=pierce_threshold)
		passed_pierce_threshold=1
	if(blocked)
		organ_prob_mod=blocked/4//Armor can help stop these things.
	for(var/obj/item/organ/internal/I in internal_organs)
		if(Find_Internal_In_Protected(I) && !src.is_broken() &&!passed_pierce_threshold) //If the organ is protected by the external organ bone, and that bone is not broken. And the damage is less than the pierce threshold It can not be damaged
			continue
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
		//				OLD SURGERY
		//else if(sharp)
		//	spread_germs_to_organ(src,owner)

		if(istype(victim,/obj/item/organ/internal/))
			var/obj/item/organ/internal/I=victim
			if(damage_amt>I.internal_bleed_threshold)// damage_amt
				if(pointy)
					switch(damage_amt)
						if(1 to 15)
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
						if(1 to 15)
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
						if(1 to 15)
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
//			DEBUG REMOVE
/mob/living/carbon/human/verb/check_internal()
	var/list/L=list(" ")
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.bleeding)
			L+="<span class='warning'>[I],Damage:[I.damage], Bleed Amount:[I.bleeding] \icon[icon(I.icon,"[I.icon_state]")]</span>\n"
	to_chat(src,jointext(L,null))


/obj/item/organ/external/proc/Find_Internal_In_Protected(obj/item/organ/internal/I)
	for(var/obj/item/organ/internal/O in internal_organs)
		if(O.organ_tag==I.organ_tag)
			return TRUE
	return FALSE

/obj/item/organ/external
	var/pierce_threshold//Amount of damaged a pointy weapon must do, to break through the protection
	var/list/protected=list()//A list of internal organs that are protected by the bones of this external organ. The bone has to be broken for the protection to seize

/obj/item/organ/external/chest
	pierce_threshold=15

