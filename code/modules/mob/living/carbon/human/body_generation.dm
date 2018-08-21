#define SKIN_LAYER				2
/mob/living/carbon/human/proc/generate_unique_body(var/update_icons=1)
	to_chat(src,"berlp")
	var/image/standing_image=image(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',icon_state="blank")
	stand_icon=null
	for(var/obj/item/organ/external/part in organs)
		var/icon/temp = part.get_icon()
		if(part.organ_tag == BP_CHEST&&gender==FEMALE)
			var/obj/item/organ/external/chest/C=organs_by_name[BP_CHEST]
			var/icon/boob
			boob = icon('icons/mob/female.dmi',"breast[C.breast_size]")
			if(C.s_tone >= 0)
				boob.Blend(rgb(C.s_tone, C.s_tone, C.s_tone), ICON_ADD)
			else
				boob.Blend(rgb(-C.s_tone, -C.s_tone, -C.s_tone), ICON_SUBTRACT)
			temp.Blend(boob, ICON_OVERLAY)
		standing_image.overlays+=temp
	overlays_standing[SKIN_LAYER]=standing_image
	if(update_icons)
		update_icons()
/mob/living/carbon/human/var/Applied_Pale_Mod=0


/mob/living/carbon/human/proc/Generate_Body_Icon()
	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")
	var/obj/item/organ/external/chest/C=get_organ(BP_CHEST)
	var/icon/iconbase=icon('icons/mob/human.dmi',"blank")
	if(C)
		iconbase=C.get_icon()//The base is the chest icon
	var/list/ontoplist=list()
	for(var/obj/item/organ/external/part in (organs-C))
		if(part.ontop)
			ontoplist+=part
			continue
		if(part==C)
			continue
		var/icon/particon=part.get_icon()
		iconbase.Blend(particon,ICON_OVERLAY)
	for(var/obj/item/organ/external/part in ontoplist)
		var/icon/particon=part.get_icon()
		iconbase.Blend(particon,ICON_OVERLAY)
	if(gender == FEMALE)//do boobs
		var/icon/breasticon=icon('icons/mob/human_races/r_human.dmi',"breast[C.breast_size]")
		if(C.s_tone >= 0)
			breasticon.Blend(rgb(C.s_tone, C.s_tone, C.s_tone), ICON_ADD)
		else
			breasticon.Blend(rgb(-C.s_tone, -C.s_tone, -C.s_tone), ICON_SUBTRACT)
		iconbase.Blend(breasticon, ICON_OVERLAY)
	if(pale)
		var/palecolormod=rgb(204,247,243)//var/palecolormod = rgb(96,88,80)
		iconbase.ColorTone(palecolormod)
		Applied_Pale_Mod=1
	else
		Applied_Pale_Mod=0
	stand_icon.Blend(iconbase,ICON_OVERLAY)
	heat_icon=stand_icon
	return


