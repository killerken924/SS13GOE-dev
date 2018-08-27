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

/mob/living/carbon/human/proc/armed_parry_chance(mob/living/carbon/human/attacker)

	to_chat(world,"Armed_parry_chance, src=[src]")

	var/agility=0
	if(Skills.get_skill(/datum/realskills/agility))
		agility=Skills.get_skill(/datum/realskills/agility).points

	var/attacker_agility=0
	if(attacker.Skills.get_skill(/datum/realskills/agility))
		attacker_agility=attacker.Skills.get_skill(/datum/realskills/agility).points

	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=get_active_hand()

	var/attacker_weapon_skill=attacker.get_apropriate_weapon_skill(Attacker_Weapon)
	var/defender_weapon_skill=get_apropriate_weapon_skill(Defender_Weapon)

	var/chnc=10

	//weapon skills
	var/weapon_skill_delta=defender_weapon_skill-attacker_weapon_skill
	chnc += 10*(weapon_skill_delta)/2
	to_chat(world,"weapon skill delta = [weapon_skill_delta]")

	//agility comes into play
	var/agility_skill_delta=agility-attacker_agility//being fast(or rather, fast than your attacker) matters a lot for countering a incoming attack.
	chnc += 5*(agility_skill_delta)/2

	//Weapon stuff
	if(!Attacker_Weapon&&Defender_Weapon)// if the attacker doesn't have a weapon, welp.... hes gonna have it hard
		chnc+=30
	else if(Attacker_Weapon&&!Defender_Weapon)// if the defender doesn't have a weapon, welp.... hes gonna have it hard
		chnc-=50

	//Weapon quality can come into play here.
	else if(Attacker_Weapon&&Defender_Weapon)
		if(isadvancedweapon(Attacker_Weapon)&&isadvancedweapon(Defender_Weapon))
			var/obj/item/weapon/advanced_weapon/advanced_attacker_weapon=Attacker_Weapon
			var/obj/item/weapon/advanced_weapon/advanced_defender_weapon=Defender_Weapon
			var/weapon_quality_delta=advanced_defender_weapon-advanced_attacker_weapon
			chnc+=3*(weapon_quality_delta)/2

	//directional stuff
	if(is_A_behind_B(attacker,src))//if the attacker is behind us, we can't really do much
		chnc-=80
		to_chat(world,"BEHIND ATTACK")

	else if(is_A_perpendicular_to_B(attacker,src))//if the attacker is us and we are not looking directly at him(perpendicular), he has a better chance
		chnc-=20
		to_chat(world,"PERPENDICULAR ATTACK")

	if(chnc<=0)
		return 0
	return chnc


