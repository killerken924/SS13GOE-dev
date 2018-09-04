/mob/living/carbon
	var/max_ap=10
	var/ap=10//action_points, this is the short term energy, meant for actions. Like hitting,carrying,grabbing,etc... this regens fromn energy points and nourishment, when energy points are low the max action points will be lowered. The more tired you get, the less actions you can do.
	var/ep=10//energy_points, this is the long term energy that the player has(it affects the regen and sanity of the ap), only ways to gain it back is through sleep and being well nourished
	var/max_ep=10
	var/ep_notification_timer=0
/mob/living/carbon/proc/handle_stamina()
	if(ap<0)
		ap=0
	if(ep<0)
		ep=0
	if(ap>max_ap)
		ap=max_ap
	if(ep>max_ep)
		ep=max_ep
	Regen_Ap()
	Regen_Ep()
	Handle_Stamina_Icons()
	Handle_Tired_Notifications()
	return
/mob/living/carbon/proc/Regen_Ap()
	var/nutrition_hydation_avg=((nutrition_stamina_mod+hydration_stamina_mod)/2)// 0.1*7/5
	if(sleeping||stat==UNCONSCIOUS)
		ap+=(nutrition_hydation_avg*ep)*3
	else if(resting)
		ap+=(nutrition_hydation_avg*ep)*2
		if(ap<=1)
			ep-=0.1
		else
			ep-=0.005
	else
		ap+=nutrition_stamina_mod*ep
		if(ap<=1)
			ep-=0.1
		else
			ep-=0.01
	if(ap<=1)
		if(prob(30))
			Weaken(5)
	return
/mob/living/carbon/human/Regen_Ap()//var/datum/realskills/strength_skill=H.Skills.get_skill(/datum/realskills/strength)
	var/datum/realskills/endurance_skill=Skills.get_skill(/datum/realskills/endurance)
	var/nutrition_hydation_avg=((nutrition_stamina_mod+hydration_stamina_mod)/2)// 0.1*7/5
	//handle this
	if(ap<max_ap)
		switch(ap)
			if(5 to 7)
				nutrition=max(0,nutrition-0.1)
				hydration=max(0,hydration-0.2)
			if(2 to 5)
				nutrition=max(0,nutrition-0.5)
				hydration=max(0,hydration-0.7)
			if(-(INFINITY) to 2)
				nutrition=max(0,nutrition-1)
				hydration=max(0,hydration-1.5)
	if(sleeping||stat==UNCONSCIOUS)
		ap+=(nutrition_hydation_avg*ep)*2
		if(buckled)
			if(istype(buckled,/obj/structure/bed/))

				if(Get_Hunger_Stamina_Mod())
					var/f=Get_Hunger_Stamina_Mod()//best is 5, worst is .25
					ap+=((nutrition_hydation_avg*f)*ep/4)*3

			else if(Get_Hunger_Stamina_Mod())
				var/f=Get_Hunger_Stamina_Mod()//best is 5, worst is .25
				ap+=((nutrition_hydation_avg*f)*ep/4)*2

		else if(Get_Hunger_Stamina_Mod())

			var/f=Get_Hunger_Stamina_Mod()//best is 5, worst is .25
			ap+=((nutrition_hydation_avg*f)*ep/4)*1.5

	else if(resting)
		if(Get_Hunger_Stamina_Mod())
			var/f=Get_Hunger_Stamina_Mod()//best is 5, worst is .25
			ap+=((nutrition_hydation_avg*f)*ep/4)*1.5
		if(ap<=1)
			ep-=0.1
		else
			ep-=0.01
	else
		if(Get_Hunger_Stamina_Mod())
			var/f=Get_Hunger_Stamina_Mod()//best is 5, worst is .25
		//	ap+=(nutrition_hydation_avg*ep)
			ap+=(nutrition_hydation_avg*f)*ep/4
		if(ap<=1)
			ep-=0.05
		else
			ep-=0.01
	if(ap<=1)
		if(prob(15))
			Weaken(5)
	if(endurance_skill&&endurance_skill.points)
		ap+=endurance_skill.points/20
	return

/mob/living/carbon/proc/Regen_Ep()
	//var/nutrition_hydation_avg=((nutrition_stamina_mod+hydration_stamina_mod)/2)*10
	if(sleeping||stat==UNCONSCIOUS)//have to be unconcisous
		if(buckled)//you sleep better in somethings instead of the floor.
			if(istype(buckled,/obj/structure/bed/))
				ep+=0.1+Get_Hunger_Stamina_Mod()/1.5
			else
				ep+=0.1+Get_Hunger_Stamina_Mod()/10
		else
			ep+=0.1+Get_Hunger_Stamina_Mod()/10
	if(ep<=EP_SERIOUS&&prob(10)) //sleeping
		sleeping+=rand(1,20)
	return

/mob/living/carbon/proc/Handle_Tired_Notifications()
	if(ep_notification_timer<=world.time)
		switch(ep)
			if(EP_OKAY to EP_SAFE)
				return
			if(EP_BAD to EP_OKAY)
				var/tiredtext=pick("Some sleep wouldn't hurt","Wouldn't mind some sleep","I could always do with some sleep")
				to_chat(src,"<span class='notice'>[tiredtext]</span>")
				ep_notification_timer=world.time+3000
			if(EP_SERIOUS to EP_BAD)
				var/tiredtext=pick("I need some sleep","I should get some sleep","I really need some sleep")
				to_chat(src,"<span class='warning'>[tiredtext]</span>")
				ep_notification_timer=world.time+750
			if(0 to EP_SERIOUS)
				var/tiredtext=pick("I'm going to pass out at this rate","I'm really tired","I need to go to sleep")
				to_chat(src,"<span class='warning'>[tiredtext]</span>")
				ep_notification_timer=world.time+500

/mob/living/carbon/proc/Handle_Stamina_Icons()
	//var/aprounded=min(max_ap,round(ap,1))
	var/aprounded=min(round(ap,1),max_ap)
	var/eprounded=min(round(ep,1),max_ep)
	if(action_points_icon&&energy_points_icon)
		action_points_icon.icon_state="ap_[aprounded]"
		energy_points_icon.icon_state="ep_[eprounded]"
	handle_tired_screen()

/mob/living/carbon/proc/Handle_Stamina_ScreenEffects()
	return

/mob/living/carbon/proc/Do_Stamina(amount)
	if(ap-amount<=0)//if you did to much, you fall
		Weaken(5)
		ep-=0.5
		if(!stat)
			var/g=(gender==MALE ? "M" : "F")
			var/list/tiredsounds=list()
			if(g=="F")
				tiredsounds=list('sound/vocaleffects/F_fatigue1.ogg')
			else if(g =="M")
				tiredsounds=list('sound/vocaleffects/M_fatigue1.ogg','sound/vocaleffects/M_fatigue2.ogg','sound/vocaleffects/M_fatigue3.ogg')
			if(tiredsounds&&tiredsounds.len&&prob(25))
				playsound(src.loc,pick(tiredsounds), 50, 1)
	ap=max(0,ap-amount)
	ep=max(0,ep-amount/25)
	return

/mob/living/carbon/var/runstamina =0.1//0.2
/mob/living/carbon/var/walkstamina =0.05
/mob/living/carbon/human/var/selectedsleep=0



