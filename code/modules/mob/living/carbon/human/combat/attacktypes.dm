/mob/living/carbon/human/proc/get_weapon_attack_type(obj/item/weapon/advanced_weapon/I)
	var/datum/advanced_combat_attack/attck
	var/weapon_skill=get_apropriate_weapon_skill(I)
	var/list/possible_attacks=list()
	for(var/datum/advanced_combat_attack/A in typesof(/datum/advanced_combat_attack)-/datum/advanced_combat_attack)
		if(A.stamina_take_attacker>=ap)
			continue
		if(A.weapon_types.Find(I.weapon_type))
			if(weapon_skill>=A.required_weapon_skill)
				possible_attacks+=A
	attck=pick(possible_attacks)
	return attck

/datum/advanced_combat_attack
	var/name
	var/attack_message
	var/damage
	var/stamina_take_victim
	var/stamina_take_attacker
	var/list/weapon_types
	var/required_weapon_skill
	var/damage_flags=list()

/datum/advanced_combat_attack/pommel_strike
	name="Pommel Strikes"
	attack_message="Pommel Strikes"
	damage=15
	stamina_take_victim=2
	stamina_take_attacker=1
	weapon_types=list(SHORT_SWORD,LONG_SWORD,BASTARD_SWORD)
	required_weapon_skill=3
	damage_flags=list()

/datum/advanced_combat_attack/lunge_stab
	name="Pommel Strikes"
	attack_message="Pommel Strikes"
	damage=15
	stamina_take_victim=3
	stamina_take_attacker=0.6
	weapon_types=list(SHORT_SWORD,LONG_SWORD,BASTARD_SWORD)
	required_weapon_skill=4
	damage_flags=list(DAM_SHARP)

