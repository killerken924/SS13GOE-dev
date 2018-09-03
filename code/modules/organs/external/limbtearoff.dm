/obj/item/organ/external/proc/tearoff_chnc(var/brute,damageflags)
	var/sharp = (damageflags & DAM_SHARP)
	var/edge  = (damageflags & DAM_EDGE)
	var/pointy = brute && sharp &&!edge

	var/can_tear_off=0
	var/tearprob=brute/3
	for(var/datum/wound/W in wounds)//cut wounds, will make it more likely to fall off...
		if(W.damage_type==CUT)
			switch(W.type)
				if(/datum/wound/cut/flesh)
					can_tear_off+=1
					tearprob+=brute/6
				if(/datum/wound/cut/gaping)
					can_tear_off+=1
					tearprob+=brute/5
				if(/datum/wound/cut/gaping_big)
					can_tear_off+=1
					tearprob+=brute/4
				if(/datum/wound/cut/massive)
					can_tear_off+=1
					tearprob+=brute/3
	if(pointy)//hard to cut limbs off with a pointy thing, like a spear for example.
		tearprob-=brute/4
	if(can_tear_off&&prob(tearprob))
		return 1
	return 0

/obj/item/organ/external/proc/edge_tearoff_chnc(var/brute)
	var/tearprob=brute
	for(var/datum/wound/W in wounds)//cut wounds, will make it more likely to fall off...
		if(W.damage_type==CUT)
			switch(W.type)
				if(/datum/wound/cut/flesh)
					tearprob+=brute/5//20% more chance
				if(/datum/wound/cut/gaping)
					tearprob+=brute/4//25% more chance
				if(/datum/wound/cut/gaping_big)
					tearprob+=brute/3//33% more chance
				if(/datum/wound/cut/massive)
					tearprob+=brute/2//50% more chance
	if(prob(tearprob))
		return 1
	return 0