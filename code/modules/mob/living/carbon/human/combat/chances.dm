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
	var/agility=Skills.get_skill(/datum/realskills/agility).points
	var/attacker_agility=attacker.Skills.get_skill(/datum/realskills/agility).points

	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=get_active_hand()

	var/attacker_weapon_skill=attacker.get_apropriate_weapon_skill(Attacker_Weapon)
	var/defender_weapon_skill=get_apropriate_weapon_skill(Defender_Weapon)
	var/chnc=10
	//WEAPONS
	if(!Attacker_Weapon&&Defender_Weapon)//Attacker has no weapon, defender has one
		chnc += 20*defender_weapon_skill/4
		to_chat(world,"Defenderweapon and no attacker weapon mod =[20*defender_weapon_skill/4]")
	if(Attacker_Weapon&&!Defender_Weapon)//Defender has no weapon, attacker has one
		chnc -= 20*attacker_weapon_skill/4
		to_chat(world,"Attackerweapon and no defender weapon mod =[-20*attacker_weapon_skill/4]")
	//SKILLS
	if(attacker_weapon_skill>defender_weapon_skill)
		var/weaponskill_delta=attacker_weapon_skill-defender_weapon_skill
		chnc -= 10 * weaponskill_delta/2
		to_chat(world,"weaponskill mod =[-10 * weaponskill_delta/2]")
	if(defender_weapon_skill>attacker_weapon_skill)
		var/weaponskill_delta=defender_weapon_skill-attacker_weapon_skill
		chnc += 10 * weaponskill_delta/2
		to_chat(world,"weaponskill mod =[10 * weaponskill_delta/2]")
	//agility
	if(attacker_agility>agility)
		var/agilitydelta=attacker_agility-agility
		chnc -= 5 * agilitydelta/2
		to_chat(world,"agility mod =[-5 * agilitydelta/2]")
	if(agility>attacker_agility)
		var/agilitydelta=agility-attacker_agility
		chnc += 5 * agilitydelta/2
		to_chat(world,"agility mod =[5 * agilitydelta/2]")
	to_chat(world,"chnc=[chnc]")
	if(chnc<=0)
		return 0
	return chnc


