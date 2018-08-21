/obj/screen/zone_sel
	name = "damage zone"
	icon ='icons/mob/zonesel.dmi'
	icon_state = "zone_sel"
	screen_loc = big_ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 8) //Feet
			switch(icon_x)
				if(10 to 15)
					selecting = BP_R_FOOT
				if(17 to 22)
					selecting = BP_L_FOOT
				else
					return 1
		if(9 to 24) //Legs
			switch(icon_x)
				if(11 to 15)
					selecting = BP_R_LEG
				if(17 to 21)
					selecting = BP_L_LEG
				else
					return 1
		if(25 to 32) //Hands and groin
			switch(icon_x)
				if(5 to 8)
					selecting = BP_R_HAND
				if(11 to 21)
					selecting = BP_GROIN
				if(24 to 27)
					selecting = BP_L_HAND
				else
					return 1
		if(33 to 43) //Chest and arms to shoulders
			switch(icon_x)
				if(5 to 10)
					selecting = BP_R_ARM
				if(11 to 21)
					selecting = BP_CHEST
				if(22 to 27)
					selecting = BP_L_ARM
				else
					return 1
		if(44 to 47)//Neck
			switch(icon_x)
				if(12 to 20)
					selecting = BP_NECK
		if(48 to 55) //Head,Eyes,Mouth
			if(icon_x in 11 to 21)
				selecting = BP_HEAD
				switch(icon_y)
					if(48 to 50)
						if(icon_x in 15 to 17)
							selecting = BP_MOUTH
					if(52) //Eyeline, eyes are on 15 and 17
						if(icon_x in 13 to 15)
							selecting = BP_EYES
					if(52)
						if(icon_x in 17 to 19)
							selecting = BP_EYES


	if(old_selecting != selecting)
		update_icon()
	return 1

/obj/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selecting = selecting
	selecting = bodypart
	if(old_selecting != selecting)
		update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	//overlays += image('icons/mob/zone_sel.dmi', "[selecting]")
	overlays += image('icons/mob/zonesel.dmi', "[selecting]")