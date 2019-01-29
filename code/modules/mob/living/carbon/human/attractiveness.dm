/datum/possible_mate
	var/attractiveness//how attractive this mate is
	var/gender="female"
	var/name
	var/mob/living/carbon/human/H
	var/Sexuality=1 //1 normale, 2 homo
	var/last_update//last time this was updated
	var/update_timer=30//freq. between updates
	var/last_stat

/datum/possible_mate/New(var/A,var/mob/living/carbon/human/Human)
	H=Human
	gender=H.gender
	attractiveness=A
	if(H.traits.Find(/datum/newtraits/homosexual))
		Sexuality=2
	else
		Sexuality=1
	last_stat=H.stat

	last_update=world.time+update_timer

/mob/living/carbon/human/var/last_lewd_look=0

/mob/living/carbon/human/var/list/possible_mates=list()

/mob/living/carbon/human/proc/find_in_possible_mates(var/mob/living/carbon/human/H)
	for(var/datum/possible_mate/PM in possible_mates)
		if(PM.H==H)
			return PM
	return null

/mob/living/carbon/human/proc/check_nearby_possible_mates()
	if(client && client.eye == src)
		var/mob/living/carbon/human/PH
		var/list/nearby_mates=list()
		for(var/datum/possible_mate/PM in possible_mates)
			if(InActualView(PM.H))//If you can see them
				nearby_mates+=PM
		if(nearby_mates&&nearby_mates.len)
			var/datum/possible_mate/BestMate

			for(var/datum/possible_mate/PM in nearby_mates)
				if(!BestMate||PM.attractiveness>BestMate.attractiveness)//if there is no BestMate or this mate is more attractive
					BestMate=PM//Make the best mate this
			if(BestMate)
				PH=BestMate.H
				var/lookmod=0
				lookmod+=BestMate.attractiveness*2//base attraction
				lookmod+=PH.in_underwear()*10//Underwear
				if(PH.gender==FEMALE&&PH.organ_not_covered(UPPER_TORSO))//Boobs
					lookmod+=20
				else if(PH.gender==FEMALE&&PH.in_bra())//bra
					lookmod+=10
				if(PH.organ_not_covered(LOWER_TORSO))//Genitals
					lookmod+=20
				if(prob(10)+lookmod)
					to_chat(src,"<span class='sex'>You can't help but look at [PH]</span>")
					last_lewd_look=world.time+300
					PH.examinate(src)

/mob/living/carbon/human/proc/update_possible_mates()
	var/mob/living/carbon/human/H
	var/Gay=traits.Find(/datum/newtraits/homosexual)
	for(H in view(10, src))
		if(!Gay)
			if(H.gender!=gender)
				if(find_in_possible_mates(H))
					if((find_in_possible_mates(H)&&find_in_possible_mates(H).last_update<world.time)||(find_in_possible_mates(H).last_stat!=DEAD&&H.stat==DEAD))//If this person was already in this list, and if this person can be updated in the list, and if they are dead, update
						var/datum/possible_mate/PM=find_in_possible_mates(H)
						PM.attractiveness=H.get_sexualized_aspects(src)//update attractive
						PM.name=H.name//update name
				else
					var/datum/possible_mate/PM=new/datum/possible_mate(H.get_sexualized_aspects(src),H)//make the mate
					possible_mates+=PM//add the mate
		else
			if(H.gender==gender)
				if((find_in_possible_mates(H)&&find_in_possible_mates(H).last_update<world.time)||(find_in_possible_mates(H).last_stat!=DEAD&&H.stat==DEAD))//If this person was already in this list, and if this person can be updated in the list, and if they are dead, update
					var/datum/possible_mate/PM=find_in_possible_mates(H)
					PM.attractiveness=H.get_sexualized_aspects(src)//update attractive
					PM.name=H.name//update name
				else if(!find_in_possible_mates(H))
					var/datum/possible_mate/PM=new/datum/possible_mate(H.get_sexualized_aspects(src),H)//make the mate
					possible_mates+=PM//add the mate