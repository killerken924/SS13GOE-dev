/obj/
	var/list/swing_sounds=list()
	var/swing_stamina=0.1

	var/swing_timer
/obj/item/proc/Swing(mob/living/carbon/human/swinger)
	var/swingfluff=get_swinging_fluff(swinger)
	if(swingfluff)
		visible_message("<span class='danger'>[swinger] starts to swing the [src] [swingfluff]</span>")
	else
		visible_message("<span class='danger'>[swinger] starts to swing the [src]</span>")

	if(get_swinging_sound()&&get_swinging_sound().len)
		var/list/soundsofswing=get_swinging_sound()
		if(soundsofswing&&soundsofswing.len)
			playsound(src.loc,pick(soundsofswing), 50, 1)

	var/req_skill=swinger.get_apropriate_weapon_skill(src)
	if(swing_stamina>swinger.ap)//Fail because of no stamina
		return 0
	if(prob(30-req_skill*3))//Failure caused by failurechance and low skill
		var/fail_chances=rand(1,3)
		switch(fail_chances)
			if(1)//This results in injuring the swinger
				visible_message("<span class='danger'>[swinger] catastrophically fails the swing!</span>")
				if(prob(60))//Dislocate
					var/obj/item/organ/external/B
					if(swinger.hand)//left hand
						if(prob(50))// 50/50 chance of dislocating arm or hand
							B=swinger.organs_by_name[BP_L_HAND]
						else
							B=swinger.organs_by_name[BP_L_ARM]
					else
						if(prob(50))// 50/50 chance of dislocating arm or hand
							B=swinger.organs_by_name[BP_R_HAND]
						else
							B=swinger.organs_by_name[BP_R_ARM]
					if(B)
						B.dislocate()
						visible_message("<span class='danger'>[swinger] dislocates his [B.name]!</span>")
				else//We accidently hit ourselfs..
					apply_hit_effect(swinger, swinger, ran_zone(),rand(0.5,3))
			if(2 to 3)//This results in us throwing the weapon
				visible_message("<span class='danger'>[swinger] looses grip of the [src] mid swing!</span>")
				var/list/randomturfs=list()
				for(var/turf/T in oview(10,swinger))
					randomturfs+=T
				if(randomturfs&&randomturfs.len)
					swinger.throw_item(pick(randomturfs),0)
		return 0
	//start swinging
	return 1

/obj/item/proc/get_swinging_fluff(mob/living/carbon/human/swinger)
	var/req_skill=swinger.get_apropriate_weapon_skill(src)
	switch(req_skill)
		if(-(INFINITY) to 2)
			return "Terribly"
		if(2 to 4)
			return "Poorly"
	return 0
/obj/item/proc/get_swinging_sound()
	var/list/swsounds=list()
	if(edge&&sharp)
		swsounds=list('sound/weapons/swing_01.ogg','sound/weapons/swing_02.ogg','sound/weapons/swing_03.ogg')
	else
		swsounds=list('sound/weapons/blunt_swing1.ogg','sound/weapons/blunt_swing2.ogg','sound/weapons/blunt_swing3.ogg')
	if(swsounds&&swsounds.len)
		return swsounds
	return 0





