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

/obj/screen/Defence_Mode_Dodge
	name = "Dodge"
	icon ='icons/mob/combat.dmi'
	icon_state = "dodge_0"
	var/selected=0
	screen_loc = ui_defence

/obj/screen/Defence_Mode_Dodge/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		if(selected)
			H.defense_intent=I_DODGE
			H.defence_mode_parry_icon.selected=0
			H.defence_mode_parry_icon.update_icon()
		else
			H.defense_intent=I_NONE
		usr << 'sound/effects/ding.ogg'
		update_icon()

/obj/screen/Defence_Mode_Dodge/update_icon()
	icon_state="dodge_[selected]"

/obj/screen/Defence_Mode_Parry
	name = "Parry"
	icon ='icons/mob/combat.dmi'
	icon_state = "parry_0"
	var/selected=0
	screen_loc = ui_defence

/obj/screen/Defence_Mode_Parry/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		if(selected)
			H.defense_intent=I_PARRY
			H.defence_mode_dodge_icon.selected=0
			H.defence_mode_dodge_icon.update_icon()
		else
			H.defense_intent=I_NONE
		usr << 'sound/effects/ding.ogg'
		update_icon()



/obj/screen/Defence_Mode_Parry/update_icon()
	icon_state="parry_[selected]"

/obj/screen/Fixed_Eye
	name = "Fix Eye"
	icon ='icons/mob/combat.dmi'
	icon_state = "fixeye_0"
	var/selected=0
	screen_loc = ui_toxin

/obj/screen/Fixed_Eye/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H=usr
		selected=!selected
		if(selected)
			H.set_face_dir(H.dir)
		else
			H.set_face_dir(null)
	update_icon()

/obj/screen/Fixed_Eye/update_icon()
	icon_state="fixeye_[selected]"


