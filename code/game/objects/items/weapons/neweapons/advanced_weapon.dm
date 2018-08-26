#define SHORT_SWORD 1
#define LONG_SWORD 2
#define BASTARD_SWORD 3
/obj/item
	var/list/counter_sounds
/obj/item/weapon/advanced_weapon
	name="Weapon"
	icon='icons/obj/actual_weapons.dmi'
	var/datum/advance_skills/weapon_skill=null
	var/weapon_quality=5
	var/weapon_type

/obj/item/weapon/advanced_weapon/sword
	name="Weapon"
	weapon_type =SHORT_SWORD
	weapon_skill=/datum/advance_skills/sword_fighting
	counter_sounds=list('sound/weapons/counters/blade_parry1.ogg','sound/weapons/counters/blade_parry2.ogg','sound/weapons/counters/blade_parry3.ogg')
	sharp = 1

/obj/item/weapon/advanced_weapon/sword/short
	name="Short Sword"
	weapon_type =SHORT_SWORD
	icon_state="sword"
	force=25