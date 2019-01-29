#define PENIS "Penis"
#define NOGENITAL "Smooth Surface"
#define VAGINIA "Vagina"
/mob/living/carbon/human/var
	Genitals
	Lust=30
	Sex_Delay
	Times_Came=0
	CumTimer=1000
	timeuntilcancum

/mob/living/carbon/human/MouseDrop_T(atom/A)
	if(istype(A,/mob/living/carbon/human))
		var/mob/living/carbon/human/C=A
		src.Sex(C)
		return
	else
		..()
/mob/living/carbon/human/proc/Has_Clothes_That_Prevent_Sex()
	var/list/L=list()
	for(var/obj/item/I in list(wear_suit,w_uniform,wear_underwear))
		if(I.body_parts_covered&LOWER_TORSO)
			L+=I
	if(L.len)
		return 1
	else
		return 0
/mob/living/carbon/human/proc/Can_Sex(type="Sex",mob/living/carbon/human/Taker,mob/living/carbon/human/Giver)
	if(type)
		if(Taker==Giver)
			return 0
		switch(type)
			if("Sex")//Normal sex
				if(!Giver.Has_Clothes_That_Prevent_Sex()&&!Taker.Has_Clothes_That_Prevent_Sex())
					if(!(Taker.Genitals==Giver.Genitals))
						return 1

			if("Anal")//Anal sex
				if(!Giver.Has_Clothes_That_Prevent_Sex()&&!Taker.Has_Clothes_That_Prevent_Sex())
					if(Giver.Genitals=="Penis")
						return 1
			if("Oral")//Anal sex
				if(!(Giver.w_uniform&&Giver.wear_underwear)&&!(Taker.wear_mask))
					return 1
			if("Handjob")//Anal sex
				if(!(Taker.Has_Clothes_That_Prevent_Sex()))
					return 1
		return 0

/mob/living/carbon/human/proc/Sex(mob/living/carbon/human/C)
	C.set_machine(src)
	var/dat ={"<HR>
	<B><FONT size=3>[src.name]</FONT></B>
	<HR>"}
	var/obj/item/organ/external/groin/G=organs_by_name[BP_GROIN]
	if(get_dist(src,C)<1&&!Has_Clothes_That_Prevent_Sex())//wear_suit
		dat+={"
			<A href='?src=\ref[src];Sex=1'>[src.Genitals]</a>[G.genitalcavity.len ? "<A href='?src=\ref[src];RemoveFromGenitals=1'> Remove</a>" : ""]<HR>"}
		dat+={"
			<A href='?src=\ref[src];Anal_Sex=1'>Anus</a><HR>"}
		if(!wear_mask)
			dat+={"
			<span class ='sex'><A href='?src=\ref[src];Oral_Sex=1'>Mouth</a></span><HR>"}
	else
		if(!Has_Clothes_That_Prevent_Sex())
			dat+={"<I>[src.Genitals]</I><HR>"}
		else
			dat+={"<I>Genitals</I><HR>"}
		dat+={"<I>Anus</I><HR>"}
		dat+={"<I>Mouth</I><HR>"}
	if(get_dist(src,C)==1&&!Has_Clothes_That_Prevent_Sex())
		dat+={"
		<A href='?src=\ref[src];Handjob=1'>Handjob</a><HR>"}
	C << browse(dat, "window=op")
	onclose(C, "op")

/mob/living/carbon/human/Topic(href, href_list)//OnTopic(mob/living/carbon/C, href_list)
	var/mob/living/carbon/human/C=usr
	var/obj/item/held = C.get_active_hand()
	if(href_list["Sex"])
		if(get_dist(src,C)<1)
			if(Can_Sex("Sex",src,C)&&!held)
				var/mob/living/carbon/human/Female=src.Genitals==VAGINIA ? src : C
				var/mob/living/carbon/human/Male=src.Genitals==PENIS ? src : C
				Vaginal_Sex(Female,Male,C)
			else if(held)
				if(!(src.w_uniform&&src.wear_underwear))
					var/obj/item/organ/external/groin/G=organs_by_name[BP_GROIN]
					if(G)
						if(G.CanPutInGenitals(held))
							if(do_after(C, HUMAN_STRIP_DELAY, src, progress = 1))
								src.Put_In_Genitals(held,C)
							else
								src.Sex(C)
						else
							visible_message("<span class='warning'>[C] tried putting the [held] in [src]'s [Genitals], but it was too big</span>")
							if(prob(20))
								src.apply_damage(rand(1,5), BRUTE, BP_GROIN)
								playsound(src.loc,'sound/sex/F_Orgasm_1.ogg', 50, 1,skiprandfreq=1)
								visible_message("<span class='danger'>[src] Screams!</span>")
								if(prob(30))
									src.PleaseSex(rand(1,60)/10)
		src.Sex(C)
	if(href_list["RemoveFromGenitals"])
		if(!held)
			if(!(src.w_uniform&&src.wear_underwear))
				var/obj/item/organ/external/groin/G=organs_by_name[BP_GROIN]
				if(G.genitalcavity.len)
					var/itemsgot=0
					for(var/obj/item/I in G.genitalcavity)
						if(I&&!itemsgot)
							if(do_after(C, HUMAN_STRIP_DELAY, src, progress = 1))
								C.put_in_active_hand(I)
								G.genitalcavity-=I
								visible_message("<span class='notice'>[C] takes the [I] out of [src]'s [src.Genitals]</span>")
								playsound(src,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 10, 1)
								src.PleaseSex(rand(1,20)/10)
							itemsgot++
		src.Sex(C)
	if(href_list["Anal_Sex"])
		if(get_dist(src,C)<1)
			if(!held)
				if(Can_Sex("Anal",src,C))
					Anal_Sex(src,C,C)
		src.Sex(C)
	else
		var/craftingitem=0
		for(var/datum/craftable_item/I in craftable_items)
			if(href_list["[I.name]"])
				Attempt_Craft(I)
				//Crafting_Menu()
				craftingitem=1
		if(!craftingitem)
			..()


/mob/living/carbon/human/proc/Put_In_Genitals(obj/item/I,mob/living/carbon/human/user)
	var/obj/item/organ/external/groin/G=organs_by_name[BP_GROIN]
	if(G)
		visible_message("<span class='warning'>[user] puts the [I] in [src]'s [Genitals]</span>")
		user.drop_item()
		I.forceMove(G)
		G.genitalcavity+=I
		playsound(src,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 10, 1)
		src.PleaseSex(rand(1,20)/10)
		if(is_sharp(I))
			if(gender==FEMALE)
				var/obj/item/organ/internal/O = internal_organs_by_name[pick(BP_STOMACH,BP_LIVER,BP_KIDNEYS,BP_APPENDIX)]
				if(O)
					O.take_damage(rand(1,30))
			else
				src.apply_damage(rand(1,10), BRUTE, BP_GROIN,damage_flags=DAM_SHARP|DAM_EDGE)
		else if(prob(10))
			if(gender==FEMALE)
				var/obj/item/organ/internal/O = internal_organs_by_name[pick(BP_STOMACH,BP_LIVER,BP_KIDNEYS,BP_APPENDIX)]
				if(O)
					O.take_damage(rand(1,15))

/mob/living/carbon/human/proc/Vaginal_Sex(mob/living/carbon/human/Female,mob/living/carbon/human/Male,mob/living/carbon/human/Aggresor)
	if(Aggresor.Lust<=0)
		to_chat(Aggresor,"<span class='warning'>I don't feel like it </span>")
		return

	if(Female.Genitals==Male.Genitals)
		return

	if(Sex_Delay>world.time)
		return//visible_message
	//PENIS STUFF
	var/PenisSizeMod=Male.current_penis_size/3
	var/PenisSizeFluff
	if(Male.erect&&Male.current_penis_size!=Male.penis_size)//If he is erect but not fully
		PenisSizeFluff="semi-erect"
	else if(Male.erect&&Male.current_penis_size==Male.penis_size)
		PenisSizeFluff="erect"
	else if(!Male.erect)
		PenisSizeFluff=pick("flaccid","limp","unerect")
	//END OF PENIS STUFF
	if(Male==Aggresor)
		playsound(Female,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 100, 1)
		Female.visible_message("<span class='sex'>[Male] [pick("Fucks","Penetrates","Perforates","Sticks","Probes","Enjoys")] [Female]'s [Female.Genitals] with his [PenisSizeFluff] [Male.Genitals]</span>")
		Male.Lust-=rand(0.8,2)

		Male.sexual_act(4,10)

		Female.Lust-=rand(0.2,1.5)+PenisSizeMod
		Sex_Delay=rand(0.1,2)+world.time

		sex_move(Female,Male,"Male_Female")

		if(Female.Lust<=rand(3,10)&&Female.stat == CONSCIOUS)
			var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
			playsound(Female,file(filename),100,1)

	if(Female==Aggresor)
		playsound(Female,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 60, 1)
		Female.visible_message("<span class='sex'>[Female] [pick("Fucks","Enjoys","Rides","Sits on","Engulfs","Uses")] [Male]'s [PenisSizeFluff] [Male.Genitals]</span>")

		Male.Lust-=rand(0.5,1.7)
		Male.sexual_act(3,9)

		Female.Lust-=rand(0.4,1.9)+PenisSizeMod
		Sex_Delay=rand(0.1,2)+world.time

		sex_move(Female,Male,"Female_Male")

		if(Female.Lust<=rand(3,10)&&Female.stat == CONSCIOUS)
			var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
			playsound(Female,file(filename),100,1)

	if(Male.Lust<=0&&Male.timeuntilcancum<world.time)//Male Cum
		Female.visible_message("<span class='sex'>[Male] [pick("Cums in","Fills Up")] [Female]'s [Female.Genitals]</span>")
		playsound(Female,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 100, 1)
		Male.timeuntilcancum=CumTimer+world.time
		Male.Times_Came+=1
	if(Female.Lust<=0&&Female.timeuntilcancum<world.time)//Female Cum
		if(Female.stat == CONSCIOUS)
			Female.visible_message("<span class='sex'>[Female] has came</span>")
			playsound(Female.loc,'sound/sex/F_Orgasm_1.ogg', 50, 1)
		Female.timeuntilcancum=CumTimer+world.time
		Female.Times_Came+=1
	return

/mob/living/carbon/human/proc/Anal_Sex(mob/living/carbon/human/Taker,mob/living/carbon/human/Male,mob/living/carbon/human/Aggresor)
	if(Male.Lust<=0)
		to_chat(Aggresor,"<span class='warning'>I don't feel like it </span>")
		return

	if(!Male.Genitals=="Penis")
		return

	if(Sex_Delay>world.time)
		return
	//PENIS STUFF
	var/PenisSizeFluff
	if(Male.erect&&Male.current_penis_size!=Male.penis_size)//If he is erect but not fully
		PenisSizeFluff="semi-erect"
	else if(Male.erect&&Male.current_penis_size==Male.penis_size)
		PenisSizeFluff="erect"
	else if(!Male.erect)
		PenisSizeFluff=pick("flaccid","limp","unerect")
	//END OF PENIS STUFF

	var/taker_likes_anal=Taker.traits.Find(/datum/newtraits/likes_anal)
	if(Male)
		playsound(Taker,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 100, 1)
		Taker.visible_message("<span class='sex'>[Male] [pick("Fucks","Penetrates","Perforates","Sticks","Probes","Enjoys","Clogs")] [Taker]'s [pick("Anus","Ass","Asshole")] with his [PenisSizeFluff] [Male.Genitals]</span>")
		Male.Lust-=rand(8,15)/10
		Male.sexual_act(1,5)
		Sex_Delay=rand(0.1,2)+world.time
		if(Taker.traits.len)
			if(taker_likes_anal)
				Taker.Lust-=rand(8,30)/10
				if(Taker.gender==FEMALE&&Taker.Lust<=rand(3,10)&&Taker.stat == CONSCIOUS)
					var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
					playsound(Taker,file(filename),100,1)
	if(Male.Lust<=0&&Male.timeuntilcancum<world.time)//Male Cum
		Taker.visible_message("<span class='sex'><font size=2>[Male] [pick("Cums in","Fills Up")] [Taker]'s [pick("Anus","Ass","Asshole")] with his [PenisSizeFluff] [Male.Genitals]</font></span>")
		Male.OnCum(0)
	if(Taker.Lust<=0&&Taker.timeuntilcancum<world.time&&taker_likes_anal)//Female Cum
		Taker.OnCum(1)
	sex_move(Taker,Aggresor,"Male_Female")

/mob/living/carbon/human/proc/Handle_Sex()
	check_nearby_possible_mates()
	Update_Genitals()
	if(!Lust&&timeuntilcancum<world.time)
		Lust=rand(10,30)+Times_Came*2
		turnoncooldown=0
	turnon-=0.5
	if(turnon<0)
		turnon=0
	else if(turnon>turnonmax)
		turnon=turnonmax
	switch(gender)
		if(MALE)
			Handle_Penis()
		if(FEMALE)
			return
	return

/mob/living/carbon/human/proc/Handle_Penis()
	var/oldpenissize=current_penis_size
	var/obj/item/organ/internal/heart/H = internal_organs_by_name[BP_HEART]
	if(H.pulse==PULSE_NONE)//No pulse, no boner
		current_penis_size=penis_size
		erect=0
	else
		var/newpenis=0
		//var/penisdelta=6-penis_size
		switch(turnon)
			if(0 to 20)
				newpenis=penis_size
				erect=0
			if(20 to 60)
				newpenis=round(2*penis_size/3)// 2/3 errect
				erect=1
			if(60 to 100) // fully errect
				newpenis=penis_size
				erect=1
		current_penis_size=newpenis
	if(oldpenissize!=current_penis_size)//No need to update icons unless the penis changes
		update_icons()
		if(oldpenissize<current_penis_size&&erect)
			Handle_Erection_Fluff_Text()

/mob/living/carbon/human/var/Lasterectionnotification=0

/mob/living/carbon/human/proc/Handle_Erection_Fluff_Text()
	if(Lasterectionnotification<world.time)
		if(prob(50))
			var/fluffword=pick("erection","hard on")
			to_chat(src,"<span class='sex'>I appear to have an [fluffword]</span>")
		else
			var/fluffword=pick("fuck","bust a nut","cum","pop a load","ejaculate","relieve this erection","relieve this hard on" )
			to_chat(src,"<span class='sex'>I need to [fluffword] </span>")
		Lasterectionnotification=world.time+30
		DoScreenJitter(1,5,5)

/mob/living/carbon/human/proc/OnCum(audible=1)
	apply_effect(rand(5,50),WEAKEN)
	if(gender==FEMALE&&stat == CONSCIOUS)
		playsound(src.loc,'sound/sex/F_Orgasm_1.ogg', 50, 1,skiprandfreq=1)
		src.make_jittery(rand(50,200))
		if(audible)
			visible_message("<span class='sex'><b>[src] has came!!</b></span>")
		else
			to_chat(src,"<span class='sex'>You have came!!</span>")
	to_chat(src, "<span class='sex'><b><font size=3>[pick("Oh Yes!!","Its Feels So Good!!","I Love It!")].</font></b></span>")
	DoScreenJitter(1,10,15)
	timeuntilcancum=CumTimer+world.time
	Times_Came+=1
	turnoncooldown=30

/mob/living/carbon/human/proc/PleaseSex(amount)
	if(amount)
		Lust-=amount
		if(gender==FEMALE)
			if(Lust<=0&&timeuntilcancum<world.time)//Female Cum
				OnCum(1)
				timeuntilcancum=CumTimer+world.time
				Times_Came+=1
				return
			if(Lust<=rand(3,10)&&stat == CONSCIOUS)
				var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
				playsound(src,file(filename),100,1)
			return
		else
			if(Lust<=0&&timeuntilcancum<world.time&&gender==MALE)//Male Cum
				visible_message("<span class='sex'>[src] [pick("cums","ejaculates")]</span>")
				playsound(src,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 100, 1)
				timeuntilcancum=CumTimer+world.time
				Times_Came+=1
			return

/mob/living/carbon/human/proc/Update_Genitals()
	for(var/obj/item/organ/external/E in organs)
		if(istype(E,/obj/item/organ/external/groin))
			var/obj/item/organ/external/groin/G=E
			G.MakeGenitals()
			Genitals=G.genital
	//if(gender==MALE)
	//	makepenis()

/mob/living/carbon/human/proc/sex_move(mob/living/carbon/human/Female,mob/living/carbon/human/Male,type)
	set waitfor=0
	var/pixel_y_dif=3
	var/pixel_x_dif=3
	switch(type)
		if("Female_Male")
			Female.pixel_y+=pixel_y_dif
			sleep(rand(3))
			Female.pixel_y-=pixel_y_dif
		if("Male_Female")
			Male.pixel_x=pixel_x_dif
			sleep(rand(3))
			Male.pixel_x-=pixel_x_dif
		if("Male_Male")
			Male.pixel_x+=pixel_x_dif
			sleep(rand(3))
			Male.pixel_x-=pixel_x_dif
	return

/mob/living/carbon/human/proc/handle_lewd_sight()
	update_possible_mates()

/*mob/living/carbon/human/proc/update_possible_mates()
	var/mob/living/carbon/human/H
	var/Gay=traits.Find(/datum/newtraits/homosexual)
	for(H in view(10, src))
		if(H==src)
			continue
		if(!InActualView(H))
			return
		if(!Gay)
			if(H.gender!=gender)
				if((find_in_possible_mates(H)&&find_in_possible_mates(H).last_update<world.time)||(find_in_possible_mates(H).last_stat!=DEAD&&H.stat==DEAD))//If this person was already in this list, and if this person can be updated in the list, and if they are dead, update
					var/datum/possible_mate/PM=find_in_possible_mates(H)
					PM.attractiveness=H.get_sexualized_aspects(src)//update attractive
					PM.name=H.name//update name
					PM.last_stat=H.stat
				else if(!find_in_possible_mates(H))
					var/datum/possible_mate/PM=new/datum/possible_mate(H.get_sexualized_aspects(src),H)//make the mate
					possible_mates+=PM//add the mate
		else
			if(H.gender==gender)
				if((find_in_possible_mates(H)&&find_in_possible_mates(H).last_update<world.time)||(find_in_possible_mates(H).last_stat!=DEAD&&H.stat==DEAD))//If this person was already in this list, and if this person can be updated in the list, and if they are dead, update
					var/datum/possible_mate/PM=find_in_possible_mates(H)
					PM.attractiveness=H.get_sexualized_aspects(src)//update attractive
					PM.name=H.name//update name
					PM.last_stat=H.stat
				else if(!find_in_possible_mates(H))
					var/datum/possible_mate/PM=new/datum/possible_mate(H.get_sexualized_aspects(src),H)//make the mate
					possible_mates+=PM//add the mate
					*/

/mob/living/carbon/human/proc/get_sexualized_aspects(var/mob/living/carbon/human/Viewer)
	var/attractive_level=0
	switch(gender)
		if(MALE)
			//POSITIVES
			if(organ_not_covered(LOWER_TORSO))//Can see genitals
				attractive_level++
			if(organ_not_covered(UPPER_TORSO))//Can see pecks				attractive_level++
				attractive_level+=0.5
			if(in_underwear())//if wearing underwear, and you can see it
				attractive_level++
			if(traits.Find(/datum/newtraits/attractive))//if he has the trait attractive
				attractive_level++
			//NEGATIVES
			if(has_bloody_body())// if his body is bloody
				attractive_level--
			if(bloody_hands)// if his hands are bloody
				attractive_level--
			if(stat==DEAD)// if he is dead
				attractive_level-=2

			if(pale)//If he is abnormaly pale
				attractive_level--
			//JOB STUFF
			if(job)
				//POSITIVE
				if(get_job_by_title(job).economic_modifier>get_job_by_title(Viewer.job).economic_modifier)//If he has a higher chance of having more money
					attractive_level+=0.5
				if(get_job_by_title(job).head_position)//If he is in a head position				attractive_level++
					attractive_level++
				if(get_job_by_title(job)==get_job_by_title(Viewer.job))//If he has the same job
					attractive_level+=0.5
				//NEGATIVE
				if(get_job_by_title(Viewer.job).economic_modifier>get_job_by_title(job).economic_modifier)//If you have a higher chance of having more money
					attractive_level-=0.5
				if(get_job_by_title(Viewer.job).head_position&&!get_job_by_title(job).head_position)//If you're a head but he isn't
					attractive_level--
			else
				attractive_level--// No job

		if(FEMALE)
			//POSITIVES
			if(organ_not_covered(LOWER_TORSO))//Can see genitals
				attractive_level++
			if(organ_not_covered(UPPER_TORSO))//Can see boobs
				attractive_level+=2
			if(in_underwear())//if wearing underwear, and you can see it
				attractive_level++
			if(traits.Find(/datum/newtraits/attractive))//if she has the trait attractive
				attractive_level++
			//NEGATIVES
			if(has_bloody_body())// if her body is bloody
				attractive_level--
			if(bloody_hands)// if her hands are bloody
				attractive_level--
			if(stat==DEAD)// if she is dead
				attractive_level-=2
			if(pale)//If she is abnormaly pale
				attractive_level--
			//job stuff
			if(job)
				//POSITIVE
				if(get_job_by_title(job).economic_modifier>get_job_by_title(Viewer.job).economic_modifier)//If he has a higher chance of having more money
					attractive_level+=0.5
				if(get_job_by_title(job).head_position)//If he is in a head position				attractive_level++
					attractive_level++
				if(get_job_by_title(job)==get_job_by_title(Viewer.job))//If he has the same job
					attractive_level+=0.5
				//NEGATIVE
				if(get_job_by_title(Viewer.job).economic_modifier>get_job_by_title(job).economic_modifier)//If you have a higher chance of having more money
					attractive_level-=0.5
				if(get_job_by_title(Viewer.job).head_position&&!get_job_by_title(job).head_position)//If you're a head but he isn't
					attractive_level--
			else
				attractive_level--// No job
	if(attractive_level<0)
		attractive_level=0
	return attractive_level

/mob/living/carbon/human/proc/organ_not_covered(var/O)
	if(O)
		var/passed=1
		for(var/obj/item/I in list(wear_suit,w_uniform,shoes,belt,gloves,glasses,head,l_ear,r_ear,wear_id,r_store,l_store,s_store,wear_underwear,wear_bra))
			if(I.body_parts_covered&O)//If the objects cover O
				passed=0
		if(passed)
			return 1
		else
			return 0
	return 0

/mob/living/carbon/human/proc/in_underwear()
	if(wear_underwear&&!(w_uniform&&wear_suit))//if wearing underwear, and you can see it
		return 1
	return 0

/mob/living/carbon/human/proc/in_bra()
	if(wear_bra&&!(w_uniform&&wear_suit))//if wearing underwear, and you can see it
		return 1
	return 0

/mob/living/carbon/human/proc/has_bloody_body()
	for(var/obj/item/I in list(wear_suit,w_uniform,shoes,belt,gloves,glasses,head,l_ear,r_ear,wear_id,r_store,l_store,s_store,wear_underwear,wear_bra))
		if(I.was_bloodied)
			return TRUE
	return FALSE


