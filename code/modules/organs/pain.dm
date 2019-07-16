mob/proc/flash_pain(var/target)
	if(pain)
		animate(pain, alpha = target, time = 15, easing = ELASTIC_EASING)
		animate(pain, alpha = 0, time = 20)

mob/var/last_pain_message
mob/var/next_pain_time = 0

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
mob/living/carbon/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	if(!message || stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power)
		return 0

	power -= chem_effects[CE_PAINKILLER]/2	//Take the edge off.

	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && power)
		if(affecting)
			affecting.add_pain(ceil(power/2))
		else
			adjustHalLoss(ceil(power/2))

	flash_pain(min(round(2*power)+55, 255))

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		if(power >= 70)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 40)
			to_chat(src, "<span class='danger'><font size=2>[message]</font></span>")
		else if(power >= 10)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")
	next_pain_time = world.time + (100-power)

/mob/living/carbon/human/proc/do_pain_sounds(dam,damage_type)
	var/list/sounds2play=list()
	if(stat)
		return 0
	if(!dam||!damage_type)
		return 0
	var/msg
	switch(damage_type)
		if("burn")
			switch(dam)
				if(11 to 30)
					sounds2play=list('sound/vocaleffects/pain/man_pain1.ogg','sound/vocaleffects/pain/man_pain2.ogg','sound/vocaleffects/pain/man_pain3.ogg',
									 'sound/vocaleffects/pain/woman_pain1.ogg','sound/vocaleffects/pain/woman_pain2.ogg','sound/vocaleffects/pain/woman_pain3.ogg','sound/vocaleffects/pain/woman_pain4.ogg')
					msg="<span class ='warning'>[src] screams in [pick("pain","discomfort")]</span>"
				if(30 to INFINITY)
					sounds2play=list('sound/vocaleffects/pain/man_agony1.ogg','sound/vocaleffects/pain/man_agony2.ogg','sound/vocaleffects/pain/man_agony3.ogg',
									 'sound/vocaleffects/pain/woman_agony1.ogg','sound/vocaleffects/pain/woman_agony2.ogg','sound/vocaleffects/pain/woman_agony3.ogg')
					msg="<span class ='danger'>[src] screams in [pick("agony","extreme pain")]</span>"
		if("brute")
			switch(dam)
				if(11 to 50)
					sounds2play=list('sound/vocaleffects/pain/man_pain1.ogg','sound/vocaleffects/pain/man_pain2.ogg','sound/vocaleffects/pain/man_pain3.ogg',
									 'sound/vocaleffects/pain/woman_pain1.ogg','sound/vocaleffects/pain/woman_pain2.ogg','sound/vocaleffects/pain/woman_pain3.ogg','sound/vocaleffects/pain/woman_pain4.ogg')
					msg="<span class ='danger'>[src] screams in [pick("pain","discomfort")]</span>"
				if(50 to INFINITY)
					sounds2play=list('sound/vocaleffects/pain/man_agony1.ogg','sound/vocaleffects/pain/man_agony2.ogg','sound/vocaleffects/pain/man_agony3.ogg',
									 'sound/vocaleffects/pain/woman_agony1.ogg','sound/vocaleffects/pain/woman_agony2.ogg','sound/vocaleffects/pain/woman_agony3.ogg')
					msg="<span class ='warning'>[src] screams in [pick("agony","extreme pain")]</span>"
	if(sounds2play&&sounds2play.len)
		for(var/A in sounds2play)
			switch(gender)
				if(MALE)
					var/B="[A]"
					if(findtext(B,"woman"))
						sounds2play-=A
				if(FEMALE)
					var/B="[A]"
					if(!(findtext(B,"woman")))
						sounds2play-=A
		playsound(src.loc,pick(sounds2play),50,0)
		src.visible_message("[msg]")


/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/organ_max_damage = 0
	var/obj/item/organ/external/damaged_organ = null
	var/has_collapsed=0
	for(var/obj/item/organ/external/E in organs)
		if(!E.can_feel_pain()) continue
		var/dam = E.get_damage()

		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
			organ_max_damage=E.max_damage

	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			paralysis = max(0, paralysis - round(maxdam/10))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		//switch(maxdam)
		var/damage_2_max_damage_ratio=round((maxdam/organ_max_damage)*100)// Say the organ has 15 damage, and the max damage is 100, you have 0.15. You then multiply it by 100 and round it
		switch(damage_2_max_damage_ratio)
			//if(1 to 10)
			if(10 to 33)
				msg =  "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."
				DoScreenJitter(rand(1,5),rand(1,7),rand(1,7))
			//if(11 to 90)
			if(34 to 66)
				msg = "Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!"
				DoScreenJitter(rand(1,5),rand(1,40),rand(1,40))
			//if(91 to 10000)
			if(67 to INFINITY)
				msg = "OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!"
				DoScreenJitter(rand(1,5),rand(1,50),rand(1,50))
		if(prob(maxdam/5)&&damage_2_max_damage_ratio>=33&&!has_collapsed)
			do_pain_sounds(maxdam,"[burning ? "burn" : "brute"]")
			if(!lying)
				custom_emote(VISIBLE_MESSAGE, "collapses!")
			Weaken(5)
			has_collapsed=1
		custom_pain(msg, maxdam, prob(10), damaged_organ, TRUE)
	// Damage to internal organs hurts a lot


	//var/pain = 10
	for(var/obj/item/organ/internal/I in internal_organs)
		if(prob(1) && !((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) && I.damage > 5)
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			var/message
			var/internal_organ_damage=I.damage
			var/internal_organ_max_damage=I.max_damage
			var/damage_2_max_damage_ratio=round((internal_organ_damage/internal_organ_max_damage)*100)// Say the organ has 15 damage, and the max damage is 100, you have 0.15. You then multiply it by 100 and round it
			switch(damage_2_max_damage_ratio)
				if(1 to 9)
					message="You feel dull pain in your [parent.name]"
				if(10 to 33)
					//pain=33
					message="You feel pain in your [parent.name]"
				if(34 to 66)
					//pain=66
					message="You feel [prob(50) ? uppertext(pick("terrible","serious","acute")) : pick("terrible","serious","acute") ]  pain in your [parent.name]"
				if(67 to INFINITY)
					//pain=90
					message="You feel [uppertext(pick("horrendous","horrifying","extreme","unsurpassable"))] pain in your [parent.name]"

			if(prob(internal_organ_damage/5)&&damage_2_max_damage_ratio>=33&&!has_collapsed)
				do_pain_sounds(maxdam,"brute")
				if(!lying)
					custom_emote(VISIBLE_MESSAGE, "collapses!")
				Weaken(5)
				has_collapsed=1
			custom_pain(message, maxdam, prob(10), damaged_organ, TRUE)

	if(prob(1))
		switch(getToxLoss())
			if(5 to 17)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(17 to 35)
				custom_pain("Your body stings.", getToxLoss())
			if(35 to 60)
				custom_pain("Your body stings strongly.", getToxLoss())
			if(60 to 100)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(100 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())
	//do_hunger_pain()