/mob/living/carbon/human
	var/combat_mode=0
	var/defense_intent=I_DODGE
	var/attack_intent=0
	var/list/advance_skills=list()

/mob/living/carbon/human/proc/attempt_defence(var/mob/living/carbon/human/attacker)
	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=get_active_hand()
	if(combat_mode)
		switch(defense_intent)
			if(I_DODGE)
				if(prob(10*dodge_chance()))
					do_dodge()
					return 1
			if(I_PARRY)
				if(Attacker_Weapon&&!Defender_Weapon)//If you trying to parry a weapon, without a weapon. It will really fucking hard
					if(prob(10*parry_chance()/5))
						do_parry()
						return 1
				else if(!Attacker_Weapon&&Defender_Weapon)//If you trying to parry a unarmed attack, with a weapon. It will really fucking easy
					if(prob(10*parry_chance()*3))
						do_parry()
						return 1

				else if(Attacker_Weapon&&Defender_Weapon)//Weapon parry
					if(prob(10*weapon_parry_chance()))
						do_weapon_parry()
						return 1

				else if(prob(10*parry_chance()))
					do_parry()
					return 1
		return 0
/mob/living/carbon/human/proc/do_dodge(var/mob/living/carbon/human/attacker)
	var/dodge_loc=pick(GLOB.cardinal-get_dir(src,attacker))
	Do_Stamina(3)
	playsound(loc, 'sound/weapons/punchmiss.ogg', 80, 1)//play a sound
	visible_message("<b>[src.name] dodges out of the way!!</b>")//send a message
	step(src,dodge_loc)

/mob/living/carbon/human/proc/do_parry(var/mob/living/carbon/human/attacker)
	var/datum/unarmed_attack/attack = get_unarmed_attack(attacker,ran_zone())
	if(prob(parry_chance()/2))//CRITICAL
		var/hit_zone=ran_zone(BP_HEAD,75)
		attack=get_unarmed_attack(attacker,hit_zone)
		var/real_damage = rand(1,5)

		real_damage += attack.get_unarmed_damage(attacker)*3
		real_damage *= damage_multiplier

		if(HULK in attacker.mutations)
			real_damage *= 3 // Hulks do twice the damage

		var/datum/realskills/strength_skill=Skills.get_skill(/datum/realskills/strength)
		if(strength_skill&&strength_skill.points)
			real_damage*=strength_skill.points/5

		Do_Stamina(attack.stamina_drain/2)//When you counter, you only takes a half the stamina
		var/armour = run_armor_check(hit_zone, "melee")

		visible_message("<span class='danger'>[src] critically counters [attacker] attack!!</span>")

		attack.show_attack(src, attacker, hit_zone, rand(real_damage/3,real_damage))

		attack.apply_effects(attacker, src, armour, rand(real_damage/3,real_damage), hit_zone)
		attacker.apply_damage(real_damage, (attack.deal_halloss ? PAIN : BRUTE), hit_zone, armour, damage_flags=attack.damage_flags())
	else
		var/hit_zone=ran_zone()
		attack=get_unarmed_attack(attacker,hit_zone)
		var/real_damage = rand(1,5)

		real_damage += attack.get_unarmed_damage(attacker)
		real_damage *= damage_multiplier

		if(HULK in attacker.mutations)
			real_damage *= 3 // Hulks do twice the damage

		var/datum/realskills/strength_skill=Skills.get_skill(/datum/realskills/strength)
		if(strength_skill&&strength_skill.points)
			real_damage*=strength_skill.points/5

		Do_Stamina(attack.stamina_drain/2)//When you counter, you only takes a half the stamina
		var/armour = run_armor_check(hit_zone, "melee")

		visible_message("<span class='danger'>[src] critically counters [attacker] attack!!</span>")

		attack.show_attack(src, attacker, hit_zone, rand(real_damage/3,real_damage))

		attack.apply_effects(attacker, src, armour, rand(real_damage/3,real_damage), hit_zone)
		attacker.apply_damage(real_damage, (attack.deal_halloss ? PAIN : BRUTE), hit_zone, armour, damage_flags=attack.damage_flags())




/mob/living/carbon/human/proc/do_weapon_parry(var/mob/living/carbon/human/attacker)
	return



