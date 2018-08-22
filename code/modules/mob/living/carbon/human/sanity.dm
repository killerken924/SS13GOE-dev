/mob/living/carbon/human/var
	maxsanity=500
	sanity=0
	InTheDark=0
	turf/Last_dark_tile_in
	lastplayedsound
	lasttimeplayedsound
	sounddelay=500

	see_evil_delay
	last_time_evil_see

	list/scaryshit=list()
	maxscaryshit=15
/mob/living/carbon/human/proc/Handle_Sanity()
	Handle_Darkness()
	if(sanity>=maxsanity)
		sanity=maxsanity
	if(sanity<=0)
		sanity=0
	Handle_Sanity_Effects()
	Handle_Sanity_Effects_Sound()
	SeeEvil()
	//HandleScaryShit()
	return

/mob/living/carbon/human/proc/Handle_Darkness()
	var/turf/T = get_turf(loc)
	if(T&&T.get_lumcount()<0.1)
		InTheDark=1
		sanity-=rand(1,5)
	else
		InTheDark=0
		if(T&&T.get_lumcount()>0.1)
			sanity+=T.get_lumcount()*10
	if(!(T==Last_dark_tile_in)||!Last_dark_tile_in)
		if(T)
			if(T.get_lumcount()<0.1) // Dark
				Last_dark_tile_in=T

/mob/living/carbon/human/proc/Handle_Sanity_Effects()
	set waitfor=0
	var/insanity=Get_Insanity()
	var/client/C = client
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	if(C)
		var/mob/living/carbon/human/oldsrc = src
		src = null
		spawn(0)
		pixel_x_diff=insanity*rand(1,15)
		C.pixel_x=pixel_x_diff
		pixel_y_diff=insanity*rand(1,15)
		C.pixel_y=pixel_y_diff
		sleep(oldsrc.sanity/10)
		pixel_x_diff=insanity*rand(1,5)
		C.pixel_x=pixel_x_diff
		pixel_y_diff=insanity*rand(1,5)
		C.pixel_y=pixel_y_diff
		sleep(oldsrc.sanity/10)
		if(C)
			C.pixel_x -= pixel_x_diff
			C.pixel_y -= pixel_y_diff
		src = oldsrc

/mob/living/carbon/human/proc/Handle_Sanity_Effects_Sound()
	if(lasttimeplayedsound<=world.time)
		var/list/sounds=list()
		var/insanity=Get_Insanity()
		if(insanity>0)
			if(insanity>=2)
				var/list/toadd=list("sound/horror/ManLaughing3DRightFade.ogg","sound/horror/ManGiggilingSemiDeep.ogg","sound/horror/ManLaughingSemiDeep.ogg")
				sounds+=toadd
			if(insanity>=3)
				var/list/toadd=list("sound/horror/ManLaughingReverbEcho.ogg")
				sounds+=toadd
			if(insanity>=4)
				var/list/toadd=list("sound/horror/Distant_Ripping.ogg")
				sounds+=toadd
		if(sounds.len)
			if(lastplayedsound)
				sounds-=lastplayedsound
			var/sound2play=pick(sounds)
			lastplayedsound=sound2play
			playsound_local(src.loc,pick(sounds),100)
			lasttimeplayedsound=sounddelay+world.time

/mob/living/carbon/human/proc/Get_Insanity()
	if(sanity==maxsanity)
		return 0
	if(sanity<maxsanity&&sanity>=maxsanity/5*4)
		return 1
	if(sanity<maxsanity/5*4&&sanity>=maxsanity/5*3)
		return 2
	if(sanity<maxsanity/5*3&&sanity>=maxsanity/5*2)
		return 3
	if(sanity<maxsanity/5*2&&sanity>=maxsanity/5)
		return 4
	if(sanity<maxsanity/5)
		return 5

/mob/living/carbon/human/proc/SeeEvil()
	var/list/possiblelocations=list()
	for(var/turf/T in oview(src,7))
		if(T.get_lumcount()<0.1)
			possiblelocations+=T
	if(possiblelocations.len)
		return
/mob/living/carbon/human/proc/DoScreenJitter(waitperiod=0,amountx,amounty)
	set waitfor=0
	var/client/C = client
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	if(C)
		var/mob/living/carbon/human/oldsrc = src
		src = null
		spawn(0)
		pixel_x_diff=amountx
		C.pixel_x=pixel_x_diff
		pixel_y_diff=amounty
		C.pixel_y=pixel_y_diff
		sleep(waitperiod)
		pixel_x_diff=-amountx
		C.pixel_x=pixel_x_diff
		pixel_y_diff=-amounty
		C.pixel_y=pixel_y_diff
		sleep(waitperiod)
		if(C)
			C.pixel_x -= pixel_x_diff
			C.pixel_y -= pixel_y_diff
		src = oldsrc







