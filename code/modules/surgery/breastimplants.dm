/*datum/surgery_step/breastimplant/
	priority = 3 // Must be higher than /datum/surgery_step/internal
	can_infect = 0
	shock_level = 20
	delicate = 1
	allowed_tools = list(
	/obj/item/breast_implant = 95
	)

/datum/surgery_step/breastimplant/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	to_chat(world,"bump")
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	if(affected.robotic >= ORGAN_ROBOT)
		return FALSE
	if(affected.how_open() < (SURGERY_RETRACTED))
		return FALSE
	if(!(target_zone == BP_CHEST))
		return FALSE
	return affected.how_open() >= (SURGERY_RETRACTED)

/datum/surgery_step/breastimplant/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/breast_implant/BI)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] starts to put \the [BI] in [target]'s [affected.name].</span>", \
	"<span class='notice'>You starts to put \the [BI] in [target]'s [affected.name].</span>")
	target.custom_pain("You feel an odd pain in your breasts",50, affecting = affected)
	..()

/datum/surgery_step/breastimplant/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/breast_implant/BI)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has put \the [BI] in [target]'s [affected.name]</span>", \
	"<span class='notice'>You have put \the [BI] in [target]'s [affected.name].</span>",)
	spread_germs_to_organ(affected, user)
	var/oldbreastsize=affected.breast_size
	affected.breast_size=BI.breast_size
	target.update_body()
//	Breast_Fluff_Text(user,target,affected,oldbreastsize)
	del BI
	target.op_stage.in_progress -= affected

/*datum/surgery_step/breastimplant/proc/Breast_Fluff_Text(mob/living/user, mob/living/carbon/human/target,obj/item/organ/external/chest/affected,oldbreastsize)
	switch(affected.breast_size)
		if("A")
			if(oldbreastsize==null)
				to_chat(target,"<span class='sex'>Your breasts feel bigger.</span>")
			if(oldbreastsize=="B"||oldbreastsize=="C"||oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel smaller.</span>")
		if("B")
			if(oldbreastsize=="A")
				to_chat(target,"<span class='sex'>Your breasts feel bigger.</span>")
			if(oldbreastsize=="C"||oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("C")
			if(oldbreastsize=="A"||oldbreastsize=="B")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
			if(oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("D")
			if(oldbreastsize=="A"||oldbreastsize=="B"||oldbreastsize=="C")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
			if(oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("DD")
			if(oldbreastsize=="A"||oldbreastsize=="B"||oldbreastsize=="C"||oldbreastsize=="D")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
	return*/
	*/
/proc/Breast_Fluff_Text(mob/living/carbon/human/target,obj/item/organ/external/chest/affected,oldbreastsize)
	switch(affected.breast_size)
		if("A")
			if(oldbreastsize==null)
				to_chat(target,"<span class='sex'>Your breasts feel bigger.</span>")
			if(oldbreastsize=="B"||oldbreastsize=="C"||oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel smaller.</span>")
		if("B")
			if(oldbreastsize=="A")
				to_chat(target,"<span class='sex'>Your breasts feel bigger.</span>")
			if(oldbreastsize=="C"||oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("C")
			if(oldbreastsize=="A"||oldbreastsize=="B")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
			if(oldbreastsize=="D"||oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("D")
			if(oldbreastsize=="A"||oldbreastsize=="B"||oldbreastsize=="C")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
			if(oldbreastsize=="DD")
				to_chat(target,"<span class='sex'>Your breasts feel much smaller.</span>")
		if("DD")
			if(oldbreastsize=="A"||oldbreastsize=="B"||oldbreastsize=="C"||oldbreastsize=="D")
				to_chat(target,"<span class='sex'>Your breasts feel much bigger.</span>")
/obj/item/breast_implant
	name="Breast Implant"
	desc="Thats a breast implant"
	var/breast_size="C"
	icon='icons/obj/newsurgery.dmi'
	icon_state="breastimplant"

/obj/item/breast_implant/A
	name="Breast Implant A"
	desc="Thats a breast implant,marked A"
	breast_size="A"

/obj/item/breast_implant/B
	name="Breast Implant B"
	desc="Thats a breast implant,marked B"
	breast_size="B"

/obj/item/breast_implant/C
	name="Breast Implant C"
	desc="Thats a breast implant,marked C"
	breast_size="C"

/obj/item/breast_implant/D
	name="Breast Implant D"
	desc="Thats a breast implant,marked D"
	breast_size="D"

/obj/item/breast_implant/D
	name="Breast Implant DD"
	desc="Thats a breast implant,marked DD"
	breast_size="DD"