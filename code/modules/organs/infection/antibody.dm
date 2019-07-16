/datum/reagent
	var/infection_resistance=0
/datum/reagent/spaceacillin
	infection_resistance=5
//		DEBUG REMOVE
/mob/living/carbon/human/verb/get_reg()
	var/list/L=list()
	for(var/T in chem_doses)
		var/datum/reagent/R=T
		if(initial(R.infection_resistance)>0)
			L+=R
			L[R]=chem_doses[T]
	world.log<<"[L.len]"
	for(var/T1 in L)
		var/datum/reagent/R=T1
		to_chat(world,"[initial(R.name)]:[L[T1]]")