//check if mob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M, mob/living/carbon/user)
	var/turf/T = get_turf(M)
	/*
	if(locate(/obj/machinery/optable, T))
		. = TRUE
	if(locate(/obj/structure/bed, T))
		. = TRUE
	if(locate(/obj/structure/table, T))
		. = TRUE
	if(locate(/obj/effect/rune/, T))
		. = TRUE
	*/
	if(T.density)
		return FALSE
	if(M == user)
		var/hitzone = check_zone(user.zone_sel.selecting)
		var/list/badzones = list(BP_HEAD)
		if(user.hand)
			badzones += BP_L_ARM
			badzones += BP_L_HAND
		else
			badzones += BP_R_ARM
			badzones += BP_R_HAND
		if(hitzone in badzones)
			return FALSE

/obj/item/proc/can_do_surgery(mob/living/carbon/human/M, mob/living/carbon/human/user,obj/item/I)
	if(!istype(M))//has to be a thing
		return 0
	if (user.a_intent == I_HURT)	//check for Hippocratic Oath <-----lol
		return 0
	if(!M.lying)//has to be laying down
		return 0
	if(!user.ap>0)//have to have stamina to stuff
		return 0
	var/zone = user.zone_sel.selecting

	if(M.Has_Clothes_That_Cover_Area(zone))//Clothes can't cover area
		return 0

	return 1

/*obj/item/proc/can_do_surgical_cut(mob/living/carbon/M, mob/living/user,obj/item/I)
	if(I.sharp&&I.edge)
		return 1
	return 0*/

/mob/living/carbon/human/proc/do_surgery(mob/living/carbon/human/victim, obj/item/I)
	var/zone = zone_sel.selecting
	var/obj/item/organ/external/target_organ=victim.get_organ(zone)
	if(!target_organ)
		return	0
	if(!I||!victim)
		return 0
	if(victim.has_wound_there(null,target_organ))//continuing old surgery
		return internal_surgery(victim,I,target_organ)
	if(I.sharp&&I.edge)//If its sharp and has an edge, we cut
		return surgery_cut(victim,I,target_organ)

/mob/living/carbon/human/proc/surgery_cut(mob/living/carbon/victim, obj/item/I, obj/item/organ/external/target_organ)
	var/surgery_skill=Get_Adv_Skill(/datum/advance_skills/surgery_skill).points

	var/cut_delay=SURGERY_CUT_DELAY-surgery_skill/2// If you had 10 skill(max), it would take 5 seconds instead of 15

	//		DEBUG REMOVED
	world.log<<"cut_delay=[cut_delay]"
	if(do_after(src, cut_delay, victim, progress = 1))
		var/fuck_up_prob=15
		if(ep<=EP_BAD)//If you are tired, it can fuck up more
			fuck_up_prob+=10
		var/turf/T = get_turf(victim)
		if(locate(/obj/machinery/optable, T))//operating table lowers chances of fuck ups
			fuck_up_prob-=3
		else if(locate(/obj/structure/bed, T))//bed adds 2% more of a chance
			fuck_up_prob+=2
		else if(locate(/obj/structure/table, T))//bed adds 5% more of a chance
			fuck_up_prob+=5
		else//anything else has 10%
			fuck_up_prob+=10
		fuck_up_prob-=surgery_skill*1.5
		//			DEBUG REMOVE
		world.log<<"fuck_up_prob=[fuck_up_prob]"

		if(prob(fuck_up_prob)&&fuck_up_prob>0)//If you fuck up
			//		DEBUG REMOVED
			to_chat(world,"You Fucked Up Surgery")
			return 0

		new/datum/surgical_wound/cut(target_organ,victim)
		//		DEBUG REMOVED
		to_chat(world,"successful surgery ")

		return 1

	else //Got moved
		//		DEBUG REMOVED
		to_chat(world,"You Fucked Up Surgery--moved")
		return 0

//						HREF
/mob/living/carbon/human/proc/internal_surgery(mob/living/carbon/victim, obj/item/I, obj/item/organ/external/target_organ)
	src.set_machine(victim)
	var/dat ={"<HR>
	<B><FONT size=3>[victim.name]</FONT></B>
	<HR>"}
	if(target_organ.protected.len&&!target_organ.is_broken())//External organ bone is protecting internal organs, and its not broken.
		dat+={"
		<A href='?src=\ref[src];BoneBreak=1'>[target_organ.bone_name]</a><HR>"}
	else if(target_organ.protected.len&&target_organ.is_broken())//External organ bone is protecting internal organs, and its broken.
		dat+={"
		<A href='?src=\ref[src];BoneFix=1'>Broken [target_organ.bone_name]</a><HR>"}
	var/indexvalue=0
	for(var/obj/item/organ/internal/O in target_organ.internal_organs)
		if(!target_organ.Find_Internal_In_Protected(O)||target_organ.is_broken())//If this organ is not protected by a bone	or the bone is broken
			//var/icon/organicon=O.Get_Text_Icon()
			indexvalue++
			dat+={"
			<A href='?src=\ref[src];Organ[indexvalue]=1'>[O.name]</a><HR>"}//\icon[organicon]

	src<< browse(dat, "window=op;size=300x600;can_resize=0")
	onclose(src, "op")


/mob/living/carbon/human/Topic(href, href_list)
	var/mob/living/carbon/human/C=usr
	var/obj/item/held = C.get_active_hand()
	var/obj/item/organ/external/affected = src.get_organ(C.zone_sel.selecting)//Get organ
	if(get_dist(src,C)<2)
		if(href_list["BoneBreak"])
			world.log<<"BoneBreak"
			if(held)//If item exists
				if(held.damtype==BRUTE&&!held.sharp) //if its a blunt weapon
					if(do_after(C, BONE_BREAK_DELAY, src, progress = 1))
						switch(C.Attempt_Break_Bone_Surgery(held,src))//Find result
							if(1)//Success
								visible_message("<span class='danger'>[C] breaks [src]'s [affected.bone_name] with the [held] successfully</span>")
								C.ap-=rand(1,4)//Take stamina
								affected.fracture()	//fracture bone

							if(2)//Fail Prob
								C.ap-=rand(1,4)//Take stamina
								if(prob(33))
									affected.fracture(1)//fracture bone, but fuck it up
									visible_message("<span class='danger'>[C] breaks [src]'s [affected.bone_name] with the [held]</span>")
								else
									visible_message("<span class='danger'>[C] fails to breaks [src]'s [affected.bone_name] with the [held]</span>")
									affected.take_damage(rand(1,15))
									src.do_pain_sounds(15,"brute")//This should hurt
				else
					to_chat(C,"<span class='warning'>[pick(GLOB.failure_words)]</span>")
			C.internal_surgery(src,held,affected)




/mob/living/carbon/human/proc/Has_Clothes_That_Cover_Area(var/zone)
	if(!zone)
		return TRUE
	var/list/Clothes= list(wear_suit,w_uniform,shoes,belt,gloves,
		glasses,head,l_ear,r_ear,wear_underwear,wear_bra)

	for(var/obj/item/I in Clothes)
		if(I.body_parts_covered&zone)
			return TRUE

	return FALSE

/obj/item/organ/internal/proc/Get_Text_Icon()
	var/icon/organicon
	organicon=icon(icon,icon_state)
	return organicon

/mob/living/carbon/human/proc/Attempt_Break_Bone_Surgery(obj/item/I,mob/living/carbon/human/Victim)
	if(!I||!Victim)
		return 0
	if(ap<=0)//No stamina
		return 0
	var/break_fail_prob=25

	var/strength=Skills.get_skill(/datum/realskills/strength).points
	var/intelligence=Skills.get_skill(/datum/realskills/intelligence).points
	var/surgery_skill=Get_Adv_Skill(/datum/advance_skills/surgery_skill).points
	switch(strength)
		if(1 to 3)//Low
			break_fail_prob+=20
		if(8 to 10)//High
			break_fail_prob-=20
	switch(intelligence)
		if(1 to 3)//low
			break_fail_prob+=20
		if(8 to 10)//High
			break_fail_prob-=15
	break_fail_prob-=3*surgery_skill
	///			DEBUG REMOVE
	world.log<<"break_fail_prob=[break_fail_prob]"
	if(break_fail_prob>0)
		if(prob(break_fail_prob))
			return 2//Fail return
	return 1
