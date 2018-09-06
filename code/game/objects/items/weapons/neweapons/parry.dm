/obj/item/proc/On_Weapon_Parry()
	return

/obj/item/proc/On_Weapon_Block()
	return

/obj/item/weapon/advanced_weapon/On_Weapon_Parry(var/mob/living/carbon/human/defender,var/mob/living/carbon/human/attacker)
	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=defender.get_active_hand()
	var/Defender_Skill=defender.get_apropriate_weapon_skill(Defender_Weapon)

	var/datum/realskills/attacker_strength_skill=attacker.Skills.get_skill(/datum/realskills/strength)

	var/effective_force=Attacker_Weapon.force
	if(attacker_strength_skill&&attacker_strength_skill.points)
		effective_force*=attacker_strength_skill.points/5

	var/dmgforce=effective_force/10
	if(Defender_Skill)
		dmgforce-=Defender_Skill/5

	if(weapon_quality)
		dmgforce-=weapon_quality/3

	if(effective_force>=blocking_power*force)
		dmgforce+=effective_force/7

	dmgforce=min(0,dmgforce)

	if(weapon_health)
		weapon_health-=dmgforce
		if(weapon_health<=0)
			Break_Weapon()
			return 0
	else
		Break_Weapon()
		return 0
	//SKILL LEVEL POSSIBLE HERE
	return 1

/obj/item/weapon/advanced_weapon/On_Weapon_Block(var/mob/living/carbon/human/defender,var/mob/living/carbon/human/attacker)
	var/obj/item/Attacker_Weapon=attacker.get_active_hand()
	var/obj/item/Defender_Weapon=defender.get_active_hand()
	var/Defender_Skill=defender.get_apropriate_weapon_skill(Defender_Weapon)

	var/datum/realskills/attacker_strength_skill=attacker.Skills.get_skill(/datum/realskills/strength)

	var/effective_force=Attacker_Weapon.force
	if(attacker_strength_skill&&attacker_strength_skill.points)
		effective_force*=attacker_strength_skill.points/5

	var/dmgforce=effective_force/5
	if(Defender_Skill)
		dmgforce-=Defender_Skill/5

	if(weapon_quality)
		dmgforce-=weapon_quality/3

	dmgforce=min(0,dmgforce)
	to_chat(world,"dmgforce=[dmgforce]")
	if(weapon_health)
		weapon_health-=dmgforce
		if(weapon_health<=0)
			Break_Weapon()
			return 0
	else
		Break_Weapon()
		return 0
	//SKILL LEVEL POSSIBLE HERE
	return 1
