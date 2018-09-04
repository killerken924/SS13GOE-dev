/obj/item/clothing/suit/real_armor
	icon='icons/mob/armor.dmi'
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

	var/armor_quality=5
	var/armor_protection
	var/armor_health

	var/list/move_sounds=list()
	var/armor_weight=2

/obj/item/clothing/suit/real_armor/chain_mail
	icon_state="chainmaile"
	name"Chain Mail"
	armor_protection=SLASH_PROTECTION


