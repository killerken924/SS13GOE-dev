/datum/advancedinfection
	var/name="Germ"
	var/infection_type  		//BACTERIA, VIRUS
	var/effects
	var/amount
	var/antibody_resistance//Only for bacteria, 0-11, 0 being no resistance, 11 being infinite resitance
	var/mob/living/carbon/Host//Who the infection is on

	var/obj/item/organ/Host_Organ//Where the infection is located organ wise

/datum/advancedinfection/New(var/mob/living/carbon/Victim,var/obj/item/organ/Victim_Organ,var/amt=1)
	if(!Victim_Organ)//Needs a organ
		qdel(src)
	if(Victim)
		Victim=Victim_Organ.owner

/datum/advancedinfection/virus
	name="Virus"
	infection_type=VIRUS
	antibody_resistance=11//110% resistance, its a virus, it cannot be fought with antibiotics




