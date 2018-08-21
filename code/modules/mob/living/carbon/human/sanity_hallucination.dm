/*datum/sanity_hallucination
	var/name
	var/sanity_level
	var/image/I
	var/imagestate
	var/icon
	var/mob/living/carbon/target=null
/datum/sanity_hallucination/New(mob/living/carbon/T)
	if(!T)
		del src
		return 0
	target=T
	I=image(icon,icon_state=imagestate)
/datum/sanity_hallucination/evil_monkey
	name="Evil Monkey"
	sanity_level=1
	icon='icons/mob/human_races/monkeys/r_monkey.dmi'
	imagestate="preview"*/




