
//this proc returns the armour value for a particular external organ.
/mob/living/proc/run_real_armor_check(var/def_zone,var/type,var/damage_flags,var/obj/item/W,var/attackforce)
	return
/mob/living/carbon/human/run_real_armor_check(var/obj/item/organ/external/def_zone,var/type,var/damage_flags,var/obj/item/W,var/attackforce)
	if(!type||!def_zone)
		return 0
	if(!istype(def_zone))
		def_zone = get_organ(check_zone(def_zone))
	if(!def_zone)
		return 0

	var/protection = def_zone.species.natural_armour_values ? def_zone.species.natural_armour_values[type] : 0
	var/sharp = (damage_flags & DAM_SHARP)
	var/edge  = (damage_flags & DAM_EDGE)
	var/pointy = sharp&&!edge
	var/armor_type
	if(sharp)
		if(pointy)
			armor_type=STAB_PROTECTION
		else if(edge)
			armor_type=SLASH_PROTECTION
	else
		armor_type=BLUNT_PROTECTION
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(gear.body_parts_covered & def_zone.body_part)
			if(gear.armor_protection & armor_type)
				protection=gear.get_armor_protection(protection,"melee",armor_type)

	return protection




/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type,var/damage_flags)
	if(!type || !def_zone) return 0
	if(!istype(def_zone))
		def_zone = get_organ(check_zone(def_zone))
	if(!def_zone)
		return 0
	var/sharp = (damage_flags & DAM_SHARP)
	var/edge  = (damage_flags & DAM_EDGE)
	var/pointy = sharp&&!edge
	if(!damage_flags)
		to_chat(world,"FAILURE")
		sharp=0
		edge=0
		pointy=0
	var/armor_type
	if(sharp)
		if(pointy)
			armor_type=STAB_PROTECTION
		else if(edge)
			armor_type=SLASH_PROTECTION
	else
		armor_type=BLUNT_PROTECTION
	to_chat(world,"armor type=[armor_type]")
	var/protection = def_zone.species.natural_armour_values ? def_zone.species.natural_armour_values[type] : 0
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(gear.body_parts_covered & def_zone.body_part)
			if(gear.armor_protection & armor_type)
				protection=gear.get_armor_protection(protection,type,armor_type)

			//else
			//	protection = add_armor(protection, gear.armor[type])


	return Clamp(protection,0,100)

/mob/living/carbon/human/getarmor(var/def_zone, var/type,var/damage_flags)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type,damage_flags)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getarmor_organ(affecting, type,damage_flags)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				armorval += (getarmor_organ(organ, type) * weight) //use plain addition here because we are calculating an average
				total += weight
	return (armorval/max(total, 1))