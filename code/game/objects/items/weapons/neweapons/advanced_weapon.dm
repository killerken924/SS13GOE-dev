#define SHORT_SWORD 1
#define LONG_SWORD 2
#define BASTARD_SWORD 3
/obj/item
	var/list/counter_sounds
	var/list/hitsounds=list()
	var/can_chng_attack_type=0
	var/attack_delay

/obj/item/attack_self(mob/living/carbon/human/user as mob)
	if(can_chng_attack_type)
		if(change_attack_type(user))
			return
	..()

/obj/item/proc/change_attack_type(mob/living/carbon/human/user as mob)
	user<<'sound/effects/ui_toggle.ogg'
	if(edge&&sharp)
		edge=0
		to_chat(user,"<span class='notice'>You will now stab with the [src]</span>")
		return 1
	else if (initial(edge)&&sharp)
		edge=1
		to_chat(user,"<span class='notice'>You will now slash with the [src]</span>")
		return 1
	return 0

/obj/item/weapon/advanced_weapon
	name="Weapon"
	icon='icons/obj/actual_weapons.dmi'
	var/datum/advance_skills/weapon_skill=null
	var/weapon_quality=5
	var/weapon_type

	var/list/slashsounds=list('sound/weapons/swords/slash.ogg','sound/weapons/swords/slash1.ogg','sound/weapons/swords/slash2.ogg','sound/weapons/swords/slash3.ogg')
	var/list/stabsounds=list('sound/weapons/swords/stab.ogg','sound/weapons/swords/stab1.ogg','sound/weapons/swords/stab2.ogg')


/obj/item/weapon/advanced_weapon/attack_self(mob/living/carbon/human/user as mob)//attack_hand
	change_attack_type(user)
	//..()
/obj/item/weapon/advanced_weapon/change_attack_type(mob/living/carbon/human/user as mob)
	..()
/obj/item/weapon/advanced_weapon/sword
	name="Weapon"
	weapon_type =SHORT_SWORD
	weapon_skill=/datum/advance_skills/sword_fighting
	counter_sounds=list('sound/weapons/counters/blade_parry1.ogg','sound/weapons/counters/blade_parry2.ogg','sound/weapons/counters/blade_parry3.ogg')
	sharp = 1
	edge  = 1

/obj/item/weapon/advanced_weapon/sword/change_attack_type(mob/living/carbon/human/user as mob)
	user<<'sound/effects/ui_toggle.ogg'
	if(edge&&sharp)
		edge=0
		to_chat(user,"<span class='notice'>You will now stab with the [src]</span>")
		handle_advanced_sounds()
		return 1
	else if (initial(edge))
		edge=1
		to_chat(user,"<span class='notice'>You will now slash with the [src]</span>")
		handle_advanced_sounds()
		return 1

/obj/item/weapon/advanced_weapon/proc/handle_advanced_sounds()
	if(sharp)
		if(edge)
			hitsounds=slashsounds
		else
			hitsounds=stabsounds

/obj/item/weapon/advanced_weapon/sword/attack_hand(mob/living/carbon/human/user as mob)
	var/selected_zone=user.zone_sel.selecting
	if(selected_zone==BP_MOUTH&&was_bloodied)//Lick blood off of sword, cool right?
		visible_message("<span class='warning'>[user] licks the blood off of the [src]</span>")//Still have to make it so the person licking it gets blood inside of them now.
		was_bloodied=0
		update_icon()
	..()
/obj/item/weapon/advanced_weapon/sword/short
	name="Short Sword"
	weapon_type =SHORT_SWORD
	icon_state="sword"
	force=20
	attack_delay=9
