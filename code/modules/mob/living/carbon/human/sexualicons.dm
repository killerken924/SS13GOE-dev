/mob/living/carbon/human/var/penis_size
/mob/living/carbon/human/var/current_penis_size=0
/mob/living/carbon/human/var/erect=0
/mob/living/carbon/human/var/turnon=0
/mob/living/carbon/human/var/turnonmax=100//normal max is 100
/mob/living/carbon/human/var/turnoncooldown=0
#define PENIS_LAYER				28
/mob/living/carbon/human/proc/update_sexual_icons(var/list/visible_overlays)
	switch(gender)
		if(MALE)
			var/passed=1
			for(var/obj/item/I in list(wear_suit,w_uniform,wear_underwear))
				if(I.body_parts_covered&LOWER_TORSO)//If the clothes cover the groin
					passed=0
			if(passed)
				var/obj/item/organ/external/groin/G=get_organ(BP_GROIN)//get the groin
				if(!G)
					return
				var/icon/penisicon//icon
				var/image/I//image
				var/erectvar= erect==1 ? "Penis_[current_penis_size]_errect" :"Penis_[penis_size]" //used to determine the penis icon state
				if(erect)
					penisicon=icon('icons/mob/human_races/r_human.dmi',icon_state=erectvar)
					if(G.s_tone >= 0)
						penisicon.Blend(rgb(G.s_tone, G.s_tone, G.s_tone), ICON_ADD)
					else
						penisicon.Blend(rgb(-G.s_tone, -G.s_tone, -G.s_tone), ICON_SUBTRACT)
					I=image(penisicon)
				else
					penisicon=icon('icons/mob/human_races/r_human.dmi',icon_state=erectvar)
					if(G.s_tone >= 0)
						penisicon.Blend(rgb(G.s_tone, G.s_tone, G.s_tone), ICON_ADD)
					else
						penisicon.Blend(rgb(-G.s_tone, -G.s_tone, -G.s_tone), ICON_SUBTRACT)
					I=image(penisicon)
				if(pale)
					var/palecolormod=rgb(204,247,243)//var/palecolormod = rgb(96,88,80)
					penisicon.ColorTone(palecolormod)
				visible_overlays[PENIS_LAYER]=I
			else
				visible_overlays[PENIS_LAYER]=null

	return visible_overlays

/mob/living/carbon/human/proc/sexual_act(var/amt)
	if(turnon<turnonmax)//lesser than max turn on
		turnon=max(turnon,turnon+amt-turnoncooldown)//the turnon will be at minimum the same value
	if(turnon>turnonmax)//greater than max turn on, make it the max
		turnon=turnonmax

/mob/living/carbon/human/proc/makepenis()
	if(prob(30))// 30 perecent have small penis
		penis_size=rand(1,2)
	else if(prob(15))// 15 perecent have big penis
		penis_size=rand(5)
	else if(prob(7))// 7 perecent have really big penis
		penis_size=rand(6)
	if(penis_size==null)// Majority have normal
		penis_size=rand(3,4)
/mob/living/carbon/human/var/vagina_type="outie"

/mob/living/carbon/human/proc/makevagina()
	if(prob(90))// 90 perecent have outie
		vagina_type="outie"
	else
		vagina_type="innie"


/mob/living/carbon/human/proc/get_penis_icon()
	var/obj/item/organ/external/groin/G=get_organ(BP_GROIN)//get the groin
	if(!G)
		return null
	var/icon/penisicon//icon
	var/erectvar= erect==1 ? "BigPenis_[current_penis_size]_erect" :"BigPenis_[penis_size]" //used to determine the penis icon state
	if(erect)
		penisicon=icon('icons/mob/human_races/r_human.dmi',icon_state=erectvar)
		if(G.s_tone >= 0)
			penisicon.Blend(rgb(G.s_tone, G.s_tone, G.s_tone), ICON_ADD)
		else
			penisicon.Blend(rgb(-G.s_tone, -G.s_tone, -G.s_tone), ICON_SUBTRACT)
		if(pale)
			var/palecolormod=rgb(204,247,243)
			penisicon.ColorTone(palecolormod)
		return penisicon
	else
		penisicon=icon('icons/mob/human_races/r_human.dmi',icon_state=erectvar)
		if(G.s_tone >= 0)
			penisicon.Blend(rgb(G.s_tone, G.s_tone, G.s_tone), ICON_ADD)
		else
			penisicon.Blend(rgb(-G.s_tone, -G.s_tone, -G.s_tone), ICON_SUBTRACT)
		if(pale)
			var/palecolormod=rgb(204,247,243)
			penisicon.ColorTone(palecolormod)
		return penisicon

/mob/living/carbon/human/proc/get_breast_icon()
	var/obj/item/organ/external/chest/C=get_organ(BP_CHEST)//get the groin
	var/icon/breasticon=icon('icons/mob/human_races/r_human.dmi',"Bigbreast[C.breast_size]")
	if(C.s_tone >= 0)
		breasticon.Blend(rgb(C.s_tone, C.s_tone, C.s_tone), ICON_ADD)
	else
		breasticon.Blend(rgb(-C.s_tone, -C.s_tone, -C.s_tone), ICON_SUBTRACT)
	if(pale)
		var/palecolormod=rgb(204,247,243)//var/palecolormod = rgb(96,88,80)
		breasticon.ColorTone(palecolormod)
	return breasticon

/mob/living/carbon/human/proc/get_vagina_icon()
	var/obj/item/organ/external/groin/G=get_organ(BP_GROIN)//get the groin
	var/icon/vaginaicon=icon('icons/mob/human_races/r_human.dmi',"vagina_[vagina_type]")
	if(G.s_tone >= 0)
		vaginaicon.Blend(rgb(G.s_tone, G.s_tone, G.s_tone), ICON_ADD)
	else
		vaginaicon.Blend(rgb(-G.s_tone, -G.s_tone, -G.s_tone), ICON_SUBTRACT)
	if(pale)
		var/palecolormod=rgb(204,247,243)
		vaginaicon.ColorTone(palecolormod)
	return vaginaicon