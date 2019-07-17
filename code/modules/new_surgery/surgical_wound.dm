
/datum/surgical_wound
	var/name="surgical_wound"
	var/desc
	var/bleed_amount
	var/pain
	var/obj/item/organ/external/location
	var/mob/living/carbon/human/victim
	var/bleed_stopped
	var/_icon='icons/mob/human_races/masks/surgery.dmi'
	var/_iconstate
/datum/surgical_wound/Del()
	victim.surgical_wounds-=src
	victim.update_icon=1
	..()


/datum/surgical_wound/New(var/obj/item/organ/external/O,var/mob/living/carbon/human/host)
	if(!O||!O.owner)
		return
	if(!host)
		victim=location.owner
	else
		victim=host
	victim.surgical_wounds+=src
	location=O

/datum/surgical_wound/cut
	name="Surgical Cut"
	desc="A cut to access the internals of a body part"
	bleed_amount=3
	pain=15
/datum/surgical_wound/cut/New(var/obj/item/organ/O,var/mob/living/carbon/human/host)
	..(O,host)
	_iconstate="[location.organ_tag]"
	host.update_icon=1

/mob/living/carbon/human
	var/list/surgical_wounds=list()

/mob/living/carbon/human/proc/apply_surgical_effect(var/datum/surgical_wound/W)
	if(!W)
		return 0

/mob/living/carbon/human/proc/has_wound_there(var/datum/surgical_wound/W,obj/item/organ/external/target_organ)
	if(!target_organ)
		return 0
	for(var/datum/surgical_wound/S in surgical_wounds)
		if(S.location==target_organ)
			return 1








