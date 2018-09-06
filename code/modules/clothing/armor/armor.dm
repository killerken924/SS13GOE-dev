/obj/item/clothing
//	icon='icons/mob/armor.dmi'

	var/armor_quality=5
	var/armor_protection=0
	var/armor_health=100

	var/list/move_sounds=list()
	var/list/hit_sounds=list()
	var/armor_weight=2

	var/list/protection_types

/obj/item/clothing/proc/get_armor_protection(protection,type,armor_type)
	var/returned_protection=0
	var/protec_type=protection_types[type]
	if(!protec_type)
		return 0
	if(!(armor_protection&armor_type))
		if(prob(95))
			return returned_protection
	returned_protection=(protec_type)*armor_quality/3
	var/armor_healthmod=0
	switch(armor_health)
		if(-(INFINITY) to 0)
			armor_healthmod= 100
		if(0 to 25)
			armor_healthmod=75
		if(25 to 50)
			armor_healthmod=50
		if(50 to 75)
			armor_healthmod=25
		if(75 to 100)
			armor_healthmod=0
	returned_protection-=armor_healthmod

	returned_protection=round(returned_protection+protection,1)
	to_chat(world,"returned_protection=[returned_protection]")
	return returned_protection

/obj/item/clothing/proc/Hitby(var/obj/item/W,var/damage_flags,var/attackforce=0)
	var/sharp=(damage_flags&DAM_SHARP)
	var/edge=(damage_flags&DAM_EDGE)
	//var/blunt=!sharp
	var/pointy=sharp&&!edge
	var/armor_type
	var/W_armour_pen=attackforce/10
	if(sharp)
		if(pointy)
			armor_type=STAB_PROTECTION
			W_armour_pen*=10
			if(isadvancedweapon(W))
				var/obj/item/weapon/advanced_weapon/AW=W
				W_armour_pen*=AW.weapon_quality/3
		else if(edge)
			armor_type=SLASH_PROTECTION
	else
		armor_type=BLUNT_PROTECTION

	if(armor_protection&armor_type)
		var/randchnc=rand(1,4)
		switch(randchnc)
			if(1 to 3)
				armor_health-=W_armour_pen/5
			if(4 to INFINITY)
				armor_health-=W_armour_pen*3
	else
		W_armour_pen*=5
		var/randchnc=rand(1,4)
		switch(randchnc)
			if(1 to 2)
				armor_health-=W_armour_pen
			if(2 to 4)
				armor_health-=W_armour_pen*2
			if(4 to INFINITY)
				armor_health-=W_armour_pen*4
	if(hit_sounds&&hit_sounds.len)
		playsound(src.loc,pick(hit_sounds),50,1)

/obj/item/clothing/suit/armors/chain_mail
	icon_state="chainmailevest"
	name="Chain Mail"
	armor_protection=SLASH_PROTECTION|BLUNT_PROTECTION
	body_parts_covered = UPPER_TORSO|ARMS
	protection_types=list("melee"=50)
	hit_sounds=list('sound/effects/armor/armorblock1.ogg','sound/effects/armor/armorblock2.ogg','sound/effects/armor/armorblock3.ogg','sound/effects/armor/armorblock4.ogg')
	move_sounds=list('sound/effects/armor/gear1.ogg','sound/effects/armor/gear2.ogg','sound/effects/armor/gear3.ogg','sound/effects/armor/gear4.ogg')



