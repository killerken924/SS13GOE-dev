/obj/screen/Combat_Mode
	name = "Combat Mode"
	icon ='icons/mob/combat.dmi'
	icon_state = "Combat_0"
	var/selected=0
	screen_loc = ui_combat

/obj/screen/Combat_Mode/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		H.combat_mode=selected
		usr << 'sound/effects/ui_toggle.ogg'
	update_icon()

/obj/screen/Combat_Mode/update_icon()
	icon_state="Combat_[selected]"

