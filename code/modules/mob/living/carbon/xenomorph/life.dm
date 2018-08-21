/mob/living/carbon/xenomorph/Life()

	set invisibility = 0
	set background = 1

	if (transforming)	return
	if(!loc)			return

	..()

	//if (stat != DEAD && can_progress())
	//	update_progression()

	blinded = null
	//Handle Vision
	//Handle_Vision()
	//Status updates, death etc.
	update_icons()






