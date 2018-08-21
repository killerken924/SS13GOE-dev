/obj/screen/action_points
	name = "Action Points"
	icon ='icons/mob/stamina.dmi'
	icon_state = "ap_0"
	screen_loc = ui_action_points
/obj/screen/energy_points
	name = "Energy"
	icon ='icons/mob/stamina.dmi'
	icon_state = "ep_0"
	screen_loc = ui_energy_points

/obj/screen/Rest
	name = "Rest"
	icon ='icons/mob/stamina.dmi'
	icon_state = "rest_off"
	screen_loc = ui_rest
	var/selected=0

/obj/screen/Rest/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		H.resting=selected
		H.Handle_Real_Vision()
	update_icon()

/obj/screen/Rest/update_icon()
	icon_state="rest_[selected==0 ? "off" : "on"]"

/obj/screen/Sleep
	name = "Sleep"
	icon ='icons/mob/stamina.dmi'
	icon_state = "sleep_off"
	screen_loc = ui_sleep
	var/selected=0

/obj/screen/Sleep/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		H.selectedsleep=selected
		if(selected)
			H.sleeping+=5
		else
			H.sleeping-=5
		H.Handle_Real_Vision()
	update_icon()

/obj/screen/Sleep/update_icon()
	icon_state="sleep_[selected==0 ? "off" : "on"]"


/mob/living/carbon/proc/handle_tired_screen()
	var/screen_alpha=0
	switch(ep)
		if(EP_BAD to EP_OKAY)
			screen_alpha=30
		if(EP_SERIOUS to EP_BAD)
			screen_alpha=60
		if(-(INFINITY) to EP_SERIOUS)
			screen_alpha=120
	if(screen_alpha)
		do_tired_screen("blind",/obj/screen/fullscreen/blind,salpha=screen_alpha)

/mob/living/carbon/proc/do_tired_screen(category, type, severity,salpha=0)
	var/obj/screen/fullscreen/screen = screens[category]

	if(screen)
		if(screen.type != type)
			clear_fullscreen(category, FALSE)
			screen = null
		else if(!severity || severity == screen.severity)
			return null

	if(!screen)
		screen = new type()

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	screens[category] = screen
	if(client && (stat != DEAD || screen.allstate))
		screen.alpha=salpha
		client.screen += screen
	return screen



