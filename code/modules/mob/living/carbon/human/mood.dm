/mob/living/carbon/human/var/mood=25
/mob/living/carbon/human/proc/handle_mood()
	do_randomness()
/mob/living/carbon/human/proc/do_randomness()
	if(client)
		overlay_fullscreen("features", /obj/screen/fullscreen/randomness)
		var/obj/screen/fullscreen/randomness/scrn=get_fullscreen("features")
		if(scrn)
			scrn.alpha=mood
			//scrn.randomize()

