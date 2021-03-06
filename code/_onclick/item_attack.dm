/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_params)
	if(!(item_flags & ITEM_FLAG_NO_PRINT))
		add_fingerprint(user)
	return A.attackby(src, user, click_params)

// No comment
/atom/proc/attackby(obj/item/W, mob/user, var/click_params)
	return

/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.item_flags & ITEM_FLAG_NO_BLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(!ismob(user))
		return 0
	/*		OLD SURGERY
	if(can_operate(src,user) && I.do_surgery(src,user)) //Surgery
		return 1*/
	if(ishuman(src)&&ishuman(user))
		var/mob/living/carbon/human/H=src
		var/mob/living/carbon/human/Huser=user
		if(I.can_do_surgery(H,Huser,I))
			if(Huser.do_surgery(H,I))
				return 1
			return 0
	//		DEBUG REMOVE

	to_chat(world,"attack")
	return I.attack(src, user, user.zone_sel.selecting)

/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(user == src && src.a_intent == I_DISARM && src.zone_sel.selecting == "mouth")
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return 1
		else if(devour(I))
			return 1
	if(attempt_defence(user)&&!sleeping&&!stat==UNCONSCIOUS&&(user!=src))
		return 0
	return ..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/obj/item/proc/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!force || (item_flags & ITEM_FLAG_NO_BLUDGEON))
		return 0
	if(M == user && user.a_intent != I_HURT)
		return 0

	/////////////////////////

	if(!no_attack_log)
		admin_attack_log(user, M, "Attacked using \a [src] (DAMTYE: [uppertext(damtype)])", "Was attacked with \a [src] (DAMTYE: [uppertext(damtype)])", "used \a [src] (DAMTYE: [uppertext(damtype)]) to attack")
	/////////////////////////

	//user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		var/mob/living/carbon/human/H=user
		var/datum/realskills/strength_skill=H.Skills.get_skill(/datum/realskills/strength)
		var/wep_skll=H.get_apropriate_weapon_skill(src)
		if(!handle_swinging(H))
			return 0

		var/clickcooldown
		var/is_stabby
		if( (damage_flags() & DAM_SHARP)&&!(damage_flags() & DAM_EDGE) )
			is_stabby=1
		if(attack_delay)
			clickcooldown=attack_delay//+swing_stamina
		else
			var/stab_mod=0
			if(is_stabby)//You can attack faster if you are stabbing
				stab_mod=rand(0.25,0.75)
			clickcooldown=src.w_class*3+swing_stamina-stab_mod
		clickcooldown-=H.ap/5// so if you have full stamina you would be 2 faster, if you had 1 stamina it would be .2 faster

		user.setClickCooldown(clickcooldown)
		//Taking stamina
		var/stamina_take=src.w_class+swing_stamina//if the item size was LARGE, it would take 2 stamina, if it was normal, 1.5
		if(is_stabby)//takes less stamina if you stab
			stamina_take-=0.3
		if(strength_skill&&strength_skill.points)
			stamina_take-=strength_skill.points/10//if you had max strength it would take 1.5 less, so if it was an large item, it would take 0.5 stamina, if it was normal
		if(wep_skll)
			stamina_take-=wep_skll/5
		stamina_take=max(src.w_class/10,stamina_take)//so it will always take a tenth the w_class or more.
		H.Do_Stamina(stamina_take)
		//if(H.ap<1
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)
	if(!user.aura_check(AURA_TYPE_WEAPON, src, user))
		return 0

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

	return 1

//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone,var/powermod)
	handle_hit_sounds(target,user,hit_zone,powermod)

	var/power = force
	if(powermod)
		power*=powermod

	if(HULK in user.mutations)
		power *= 2
	return target.hit_with_weapon(src, user, power, hit_zone)

/obj/item/proc/handle_hit_sounds(mob/living/target, mob/living/user, var/hit_zone,var/powermod)
	if(hitsound||hitsounds&&hitsounds.len)
		if(hitsounds&&hitsounds.len)
			playsound(loc, pick(hitsounds), 50, 1, -1)
		else if(hitsound)
			playsound(loc,hitsound, 50, 1, -1)
