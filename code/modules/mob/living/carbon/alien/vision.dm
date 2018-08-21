/mob/proc/On_Move()

	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H=src
		H.Handle_Real_Vision()
	for(var/mob/living/carbon/human/H in oview(src))
		H.Handle_Real_Vision()

	if(istype(src,/mob/living/carbon/alien))
		var/mob/living/carbon/alien/A=src
		A.Handle_Vision()
	for(var/mob/living/carbon/alien/A in oview(src))
		A.Handle_Vision()
	return
/mob/var/icon/heat_icon=null//this is used for xenos, they see in the infared wavelengths of light.
/mob/living/carbon/alien/var/list/Hidden_Turf=list()
/mob/living/carbon/alien/Clear_Vision()
	if(src.client)
		for(var/image/I in Hidden_Images)
			I.override=0
			src.client.images-=I
			Hidden_Images-=I
		for(var/turf/T in Hidden_Turf)
			Hidden_Turf-=T
		for(var/mob/M in Hidden_Mobs)
			Hidden_Mobs-=M
/mob/living/carbon/alien/proc/Handle_Vision()
	if(src.client)
		Clear_Vision()
		var/list/_oview=list()
		_oview=oview(src)
		for(var/turf/T in _oview)
			var/image/I= image("split", T)
			Hidden_Images+=I
			Hidden_Turf+=T
			I.override=1
			src.client.images+=I
			var/icon/thrml_icon=icon(T.icon,T.icon_state)
			var/tempcolor
			var/datum/gas_mixture/env = T.return_air()
			if(env)
				tempcolor = env.temperature
			else
				tempcolor=0
			if(!tempcolor)
				thrml_icon.Blend(rgb(-255, -255, -255), ICON_ADD)
			else
				thrml_icon.Blend(rgb(tempcolor,0,0), ICON_ADD)
			var/image/img=image(thrml_icon,T)
			src.client.images+=img
			Hidden_Images+=img
		for(var/mob/M in _oview)
			var/image/I= image("split", M)
			Hidden_Images+=I
			Hidden_Mobs+=M
			I.override=1
			src.client.images+=I
			var/tempcolor=max(0,M.bodytemperature)
			var/icon/mobicon=M.heat_icon
			mobicon.Blend(rgb(tempcolor*100, 0, 0), ICON_ADD)
			var/image/img=image(mobicon,M)
			src.client.images+=img
			Hidden_Images+=img






