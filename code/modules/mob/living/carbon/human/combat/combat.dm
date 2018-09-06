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
				if(Attacker_Weapon||Defender_Weapon)//A weapon is in play
					var/armedparrychance=armed_parry_chance(attacker)
					if(!armedparrychance)
						return 0
					if(prob(armedparrychance))
						do_weapon_parry(attacker)
						return 1
				else if(prob(10*parry_chance()))
					do_parry()
					return 1
		if(Find_In_Hands(/obj/item/weapon/advanced_weapon/shield,src))
			var/hnd=Find_In_Hands(/obj/item/weapon/advanced_weapon/shield,src)
			var/obj/item/weapon/advanced_weapon/shield/S
			switch(hnd)
				if(2)//ACTIVEHAND
					S=get_active_hand()
				if(1)//INACTIVEHAND
					S=get_inactive_hand()
			if(S)
				var/shieldblockchance=shield_block_chance(S,attacker)
				if(prob(shieldblockchance))
					do_shield_block(attacker,S)
					return 1

	return 0
/mob/living/carbon/human/proc/do_dodge(var/mob/living/carbon/human/attacker)
	var/dodge_loc=pick(GLOB.cardinal-get_dir(src,attacker))
	Do_Stamina(3)
	playsound(src.loc, 'sound/weapons/punchmiss.ogg', 80, 1)//play a sound
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



/mob/living/carbon/human/proc/do_shield_block(var/mob/living/carbon/human/attacker,var/obj/item/weapon/advanced_weapon/shield/S)
	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	visible_message("<span class='danger'>[src] blocks [attacker]'s [Attacker_Weapon ? Attacker_Weapon.name : "Fist"] with the [S]</span>")
	if(S.counter_sounds&&S.counter_sounds.len)
		playsound(src,pick(S.counter_sounds), 50, 1)
	else
		playsound(src,'sound/weapons/thudswoosh.ogg', 50, 1)
	S.On_Weapon_Block(src,attacker)
	var/attacker_effective_pwr=0
	if(Attacker_Weapon)
		var/attacker_strength
		if(attacker.Skills.get_skill(/datum/realskills/strength))
			attacker_strength=attacker.Skills.get_skill(/datum/realskills/strength).points
		attacker_effective_pwr=	Attacker_Weapon.force
		if(attacker_strength)
			attacker_effective_pwr*=attacker_strength/5

	var/staminadmg=attacker_effective_pwr/15
	var/strength_skill=0
	if(Skills.get_skill(/datum/realskills/strength))
		strength_skill=Skills.get_skill(/datum/realskills/strength).points
	if(strength_skill)
		staminadmg=max(attacker_effective_pwr/10,(attacker_effective_pwr/3)-(strength_skill/10))//stronger you are, the less stamina it takes
	Do_Stamina(staminadmg)

	return 1

/mob/living/carbon/human/proc/do_weapon_parry(var/mob/living/carbon/human/attacker)
	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=get_active_hand()

	//var/Attacker_Skill=attacker.get_apropriate_weapon_skill(Attacker_Weapon)
	var/Defender_Skill=get_apropriate_weapon_skill(Defender_Weapon)
	if(prob(10)*Defender_Skill/4)// the higher the skill, the more devistating the out come will be
		visible_message("<span class='danger'>[src] critically counters [attacker] attack!!</span>")
		var/hit_zone=ran_zone(BP_HEAD,50)
		var/pwrmod=(Defender_Skill/5)*3
		if(Defender_Weapon.counter_sounds&&Defender_Weapon.counter_sounds.len)
			playsound(src,pick(Defender_Weapon.counter_sounds), 50, 1)
		else
			playsound(src,'sound/weapons/thudswoosh.ogg', 50, 1)
		Defender_Weapon.apply_hit_effect(attacker,src,hit_zone,pwrmod)
		Defender_Weapon.On_Weapon_Parry(src,attacker)
		return 1
	else if(prob(25)*Defender_Skill/4)
		visible_message("<span class='danger'>[src] counters [attacker] attack!</span>")
		var/hit_zone=ran_zone(BP_CHEST,70)
		var/pwrmod=(Defender_Skill/5)
		if(Defender_Weapon.counter_sounds&&Defender_Weapon.counter_sounds.len)
			playsound(src,pick(Defender_Weapon.counter_sounds), 50, 1)
		else
			playsound(src,'sound/weapons/thudswoosh.ogg', 50, 1)
		Defender_Weapon.apply_hit_effect(attacker,src,hit_zone,pwrmod)
		Defender_Weapon.On_Weapon_Parry(src,attacker)
		return 1
	else
		visible_message("<span class='danger'>[src] blocks [attacker]'s [Attacker_Weapon ? Attacker_Weapon.name : "Fist"]</span>")
		if(Defender_Weapon.counter_sounds&&Defender_Weapon.counter_sounds.len)
			playsound(src,pick(Defender_Weapon.counter_sounds), 50, 1)
		else
			playsound(src,'sound/weapons/thudswoosh.ogg', 50, 1)
		Defender_Weapon.On_Weapon_Block(src,attacker)
		return 1

/mob/living/carbon/human/proc/get_apropriate_weapon_skill(obj/O)
	if(isitem(O))
		if(isweapon(O))
			if(isadvancedweapon(O))
				var/obj/item/weapon/advanced_weapon/W=O
				if(Get_Adv_Skill(W.weapon_skill))
					to_chat(world,"cunt")
					return Get_Adv_Skill(W.weapon_skill).points
				else
					return 0
	if(Get_Adv_Skill(/datum/advance_skills/melee_fighting))
		return Get_Adv_Skill(/datum/advance_skills/melee_fighting).points








