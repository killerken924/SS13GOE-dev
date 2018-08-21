/mob/living/carbon/human/proc/weapon_parry_chance()
	return
/mob/living/carbon/human/proc/parry_chance()
	var/melee_skill=Get_Adv_Skill(/datum/advance_skills/melee_fighting).points
	var/agility=Skills.get_skill(/datum/realskills/agility).points
	var/chnc=0
	switch(melee_skill)
		if(-(INFINITY) to 0)
			return 0

		if(0 to 3)
			chnc+= 1.5
		if(3 to 6)
			chnc+= 2.5
		if(6 to 9)
			chnc+= 3
		if(9 to 15)
			chnc+= 5
		if(15 to INFINITY)
			chnc+= 10
	switch(ap)
		if(-(INFINITY) to 0)
			return 0
		if(0 to 3)
			chnc -= 2
	switch(agility)
		if(-(INFINITY) to 0)
			chnc -=2
		if(0 to 3)
			chnc +=0.3
		if(3 to 6)
			chnc +=1.5
		if(6 to 9)
			chnc +=2
		if(9 to 15)
			chnc +=5
		if(15 to INFINITY)
			chnc +=10
	return chnc
/mob/living/carbon/human/proc/dodge_chance()
	var/melee_skill=Get_Adv_Skill(/datum/advance_skills/melee_fighting).points
	var/agility=Skills.get_skill(/datum/realskills/agility).points
	var/chnc=0
	switch(melee_skill)
		if(-(INFINITY) to 0)
			chnc +=1
		if(0 to 3)
			chnc +=2.5
		if(3 to 6)
			chnc +=3.5
		if(6 to 9)
			chnc +=5
		if(9 to 15)
			chnc +=10
		if(15 to INFINITY)
			chnc +=20
	switch(ap)
		if(-(INFINITY) to 0)
			chnc -= 20
		if(0 to 3)
			chnc -= 6
		if(3 to 6)
			chnc -= 1.5
	switch(agility)
		if(-(INFINITY) to 0)
			chnc -=2
		if(0 to 3)
			chnc +=0.3
		if(3 to 6)
			chnc +=1.5
		if(6 to 9)
			chnc +=2
		if(9 to 15)
			chnc +=5
		if(15 to INFINITY)
			chnc +=10
	return chnc

