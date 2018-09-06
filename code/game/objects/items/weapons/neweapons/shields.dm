/obj/item/weapon/advanced_weapon/shield
	counter_sounds=list('sound/weapons/counters/blunt_parry1.ogg','sound/weapons/counters/blunt_parry2.ogg','sound/weapons/counters/blunt_parry3.ogg')
	weapon_skill=/datum/advance_skills/shields
	icon_state="Shield2"
	blocking_power=3

/obj/item/weapon/advanced_weapon/shield/wood
	name="Wooden Shield"
	icon_state="Shield2"
	weapon_quality=1
	blocking_power=4
	force=15

/proc/Find_In_Hands(var/obj/item/I,var/mob/living/carbon/human/H)
	if(I&&H)
		if(H.get_active_hand()&&istype(H.get_active_hand(),I))
			return 2

		if(H.get_inactive_hand()&&istype(H.get_active_hand(),I))
			return 1
	return 0
