/mob/living/carbon/human
	var/tint_enabled=0
/mob/living/carbon/human/verb/ApplyTint()
	if(client)
		if(!tint_enabled)
			overlay_fullscreen("features", /obj/screen/fullscreen/randomness)	///obj/screen/fullscreen/bluespace_overlay
			tint_enabled=1
		else
			clear_fullscreen("features")
			tint_enabled=0

//adds more darkness/contrast to the game. quite nice.
/obj/screen/fullscreen/randomness
	icon = 'icons/effects/screens.dmi'
	icon_state = "mfoam_changing"//"mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#FFFFFF"
	alpha = 25
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER
	var/trueicon='icons/effects/screens.dmi'
	var/trueicon_state="mfoam"


/obj/screen/fullscreen/randomness/proc/randomize()
	var/icon/newicon=icon(trueicon,trueicon_state)
	var/randvariation=rand(1,3)
	var/icon/variationicon=icon('icons/effects/screens.dmi',"dirt_rand[randvariation]")
	newicon.Blend(variationicon,ICON_ADD)
	icon=newicon



