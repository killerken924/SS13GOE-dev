
/obj/item/organ/internal/var/internal_bleed_threshold=5
/obj/item/organ/internal/heart/proc/handle_internal_bleeding()
	var/bleed_amount=0
	if(!owner)
		return
	for(var/obj/item/organ/internal/temp in owner.internal_organs)
		if(temp.bleeding)
			switch(temp.bleeding)
				if(INTERNAL_BLEEDING_SEVERITY_MINIMAL)
					if(prob(10))
						temp.bleeding=0
				if(INTERNAL_BLEEDING_SEVERITY_LIGHT)
					if(prob(1))
						temp.bleeding=INTERNAL_BLEEDING_SEVERITY_LIGHT
			bleed_amount=temp.bleeding
			bleed_amount=max(0,bleed_amount)
			if(bleed_amount)
				owner.vessel.remove_reagent(/datum/reagent/blood, bleed_amount)
			temp.on_internal_bleed(bleed_amount)
			var/obj/item/organ/external/parent=owner.organs_by_name[parent_organ]
			if(parent)
				var/open_wound=FALSE
				for(var/datum/wound/W in parent.wounds)
					if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
						open_wound = TRUE
				if(parent.encased&&!(parent.status & ORGAN_BROKEN))//If it is encased in bones and not broken, you will not see blood coming out of wounds due to internal bleeding.
					open_wound=FALSE
				if(open_wound)
					owner.drip(bleed_amount, get_turf(owner))
/obj/item/organ/internal/proc/on_internal_bleed(var/bleed_amount)
	return
/obj/item/organ/internal/brain/on_internal_bleed(var/bleed_amount)
	damage=max(max_damage,damage+=bleeding/3)
	return
/obj/item/organ/internal/proc/internal_bleeding_check()
	var/dmg_amt=max_damage/5
	if(!bleeding&&can_internal_bleed)
		switch(damage)
			if(dmg_amt*2 to dmg_amt*3)
				if(prob(1))
					bleeding=INTERNAL_BLEEDING_SEVERITY_MINIMAL
					return
			if(dmg_amt*4 to dmg_amt*5)
				if(prob(5))
					bleeding=INTERNAL_BLEEDING_SEVERITY_LIGHT
					return
			if(dmg_amt*5 to INFINITY)
				if(prob(20))
					bleeding=INTERNAL_BLEEDING_SEVERITY_MED
					return

/obj/item/organ/internal
	var/can_internal_bleed=1
/obj/item/organ/internal/proc/make_internal_bleed(amount)
	if(!can_internal_bleed)
		return 0
	if(amount&&amount>0)
		bleeding+=amount
		bleeding=max(INTERNAL_BLEEDING_SEVERITY_SEVERE,bleeding)
/obj/item/organ/internal/proc/clamp_internal_bleed()
	bleeding=0
	return










