/mob/living/carbon
	var/nutrition_stamina_mod=0.1
	var/hydration_stamina_mod=0.1
/mob/living/carbon/human
	var/Hunger_Notification_Timer
	var/Thirst_Notification_Timer
	var/real_maxHealth

/mob/living/carbon/human/proc/handle_thirst_and_hunger()
	handle_thirst_icon()
	handle_hunger_icon()
	do_hunger_health()
	//
/mob/living/carbon/human/proc/handle_hunger_icon()
	if(hunger_icon)
		switch(nutrition)
			if(450 to INFINITY) //max health level >450
				nutrition_stamina_mod=0.2
				hunger_icon.icon_state="hunger"
			if(250 to 350)
				nutrition_stamina_mod=0.1
				hunger_icon.icon_state="hunger0"
			if(150 to 250)
				nutrition_stamina_mod=0.05
				hunger_icon.icon_state="hunger1"
			if(0 to 150)
				nutrition_stamina_mod=0.025
				hunger_icon.icon_state="hunger2"
	if(Hunger_Notification_Timer<world.time&&stat==CONSCIOUS)
		switch(nutrition)
			if(250 to 350)
				to_chat(src, "<span class='notice'>You are hungry.</span>") //hungry
				Hunger_Notification_Timer=world.time+1000
				DoScreenJitter(rand(1,5),rand(1,7),rand(1,7))
				if(prob(25))
					if(prob(5))
						playsound(src.loc,'sound/misc/stomachgrowl1.ogg', 25, 1)
					else
						src.playsound_local(src.loc,'sound/misc/stomachgrowl1.ogg',50)
					to_chat(src, "<span class='warning'>Your stomach growls.</span>")
			if(150 to 250)
				to_chat(src, "<span class='notice'>You are really hungry.</span>")//really hungry
				Hunger_Notification_Timer=world.time+500
				DoScreenJitter(rand(1,5),rand(2,12),rand(1,12))
				if(prob(33))
					if(prob(10))
						playsound(src.loc,'sound/misc/stomachgrowl1.ogg', 25, 1)
					else
						src.playsound_local(src.loc,'sound/misc/stomachgrowl1.ogg',50)
					to_chat(src, "<span class='warning'>Your stomach growls.</span>")
			if(50 to 150)
				to_chat(src, "<span class='warning'>You need to eat.</span>") //Eat, NOW
				Hunger_Notification_Timer=world.time+250
				DoScreenJitter(rand(1,7),rand(2,35),rand(2,35))
				if(prob(40))
					if(prob(15))
						playsound(src.loc,'sound/misc/stomachgrowl1.ogg', 25, 1)
					else
						src.playsound_local(src.loc,'sound/misc/stomachgrowl1.ogg',50)
					to_chat(src, "<span class='warning'>Your stomach growls.</span>")
			if(0 to 50)
				to_chat(src, "<span class='danger'>You feel like your dying of hunger.</span>")//You are dying
				Hunger_Notification_Timer=world.time+50
				DoScreenJitter(rand(1,10),rand(5,50),rand(5,50))
				if(prob(50))
					if(prob(20))
						playsound(src.loc,'sound/misc/stomachgrowl1.ogg', 25, 1)
					else
						src.playsound_local(src.loc,'sound/misc/stomachgrowl1.ogg',50)
					to_chat(src, "<span class='warning'>Your stomach growls.</span>")

/mob/living/carbon/human/proc/handle_thirst_icon()
	if(thirst_icon)
		switch(hydration)
			if(350 to INFINITY) //max health level >450
				thirst_icon.icon_state="thirst"
				hydration_stamina_mod=0.2
			if(250 to 350)
				thirst_icon.icon_state="thirst0"
				hydration_stamina_mod=0.1
			if(150 to 250)
				thirst_icon.icon_state="thirst1"
				hydration_stamina_mod=0.05
			if(0 to 150)
				thirst_icon.icon_state="thirst2"
				hydration_stamina_mod=0.025
	if(Thirst_Notification_Timer<world.time&&stat==CONSCIOUS)
		switch(hydration)
			if(250 to 350)
				to_chat(src, "<span class='notice'>You are thirsty.</span>")
				Thirst_Notification_Timer=world.time+1000
			if(150 to 250)
				to_chat(src, "<span class='notice'>You are really thirsty.</span>")
				Thirst_Notification_Timer=world.time+500
			if(50 to 150)
				to_chat(src, "<span class='warning'>You need to drink.</span>")
				Thirst_Notification_Timer=world.time+250
			if(0 to 50)
				to_chat(src, "<span class='danger'>You feel like your dying of thirst.</span>")
				Thirst_Notification_Timer=world.time+50
				DoScreenJitter(rand(1,10),rand(5,50),rand(5,50))

/mob/living/carbon/human/proc/do_hunger_health()
	switch(nutrition)
		if(250 to 350)
			maxHealth=max(1,real_maxHealth-10)
		if(150 to 250)
			maxHealth=max(1,real_maxHealth-20)
		if(50 to 150)
			maxHealth=max(1,real_maxHealth-25)
		if(0 to 50)
			maxHealth=max(1,real_maxHealth-35)
	switch(hydration)
		if(250 to 350)
			maxHealth=max(1,real_maxHealth-10)
		if(150 to 250)
			maxHealth=max(1,real_maxHealth-20)
		if(50 to 150)
			maxHealth=max(1,real_maxHealth-25)
		if(0 to 50)
			maxHealth=max(1,real_maxHealth-35)
/mob/living/carbon/proc/Get_Hunger_Stamina_Mod()
	var/F
	switch(nutrition)
		if(450 to INFINITY)
			F=5
		if(250 to 350)
			F=2.5
		if(150 to 250)
			F=1
		if(50 to 150)
			F=0.5
		if(0 to 50)
			F=0.25
		if((-INFINITY) to 0)
			F=0
	return F