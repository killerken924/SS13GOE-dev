/obj/machinery/fuckmachineopen/box
	name = "Fuck Box 3000"
	desc = "A fuck box..."
	icon = 'icons/obj/fuckmachines.dmi'
	icon_state = "fuckbox_open"
	density=0

	var/datum/sound_token/sound_token
	var/ssound_id
/obj/machinery/fuckmachineopen/box/New()
	..()
	ssound_id = "[/obj/machinery/fuckmachineopen/box]_[sequential_id(/obj/machinery/fuckmachineopen/box)]"
	set_light(0.5, 0.1, 5, 2,"#ae00ff")

/obj/machinery/fuckmachineopen/box/attack_hand(mob/living/carbon/user)
	if(!patient)
		for(var/mob/living/carbon/human/H in src.loc)
			if(H.Genitals==installedtoy.genitals_meant_for)
				takepatient(H)
				domachine()
				break
			else
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)


/obj/machinery/fuckmachineopen/box/takeoffclothes(obj/item/I)
	..(I)
	to_chat(patient,"<span class='danger'>You feel something take off your [I.name]</span>")

/obj/machinery/fuckmachineopen/box/takepatient(var/mob/living/carbon/human/C)
	if(C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.forceMove(src)
	C.stop_pulling()
	C.canmove=0
	C.dir=SOUTH
	patient=C
	for(var/obj/item/I in list(patient.wear_suit, patient.w_uniform,patient.wear_underwear))
		takeoffclothes(I)

/obj/machinery/fuckmachineopen/box/domachine()
	currentfucktimer=world.time+fucktimer
//	playsound(src.loc, 'sound/sex/Fuckmachine.ogg', 50, 0)//fuckmachineoverlay
	icon_state="fuckbox_closed"
	density=1
	fucking=1
	handlesound()
	while(currentfucktimer>world.time)//&&!emergencyshutdown)
		if(!src.loc==patient.loc)
			break
		sleep(3)
		patient.dir=SOUTH
		movearound()
		machinefuck()
	fucking=0
	handlesound()
	density=0
	playsound(src.loc, 'sound/machines/chime.ogg', 50, 0)
	icon_state = "fuckbox_open"
	patient.forceMove(src.loc)
	patient.canmove=1
	patient=null


/obj/machinery/fuckmachineopen/box/proc/movearound(xamount=1,yamount=1)
	set waitfor=0
	for(var/obj/O in src.loc)
		if(O==src)
			continue
		O.throw_at(get_step_rand(src), O.throw_range, O.throw_speed)// user)
		src.visible_message("<span class='danger'>The [src] hits [O]</span>")
	var/pixel_x_diff = xamount
	var/pixel_y_diff = yamount
	src.pixel_x=pixel_x_diff
	src.pixel_y=pixel_y_diff
	sleep(1)
	pixel_x_diff = -xamount
	pixel_y_diff = -yamount
	src.pixel_x=pixel_x_diff
	src.pixel_y=pixel_y_diff
	sleep(1)
	src.pixel_x -= pixel_x_diff
	src.pixel_y -= pixel_y_diff
	return

/obj/machinery/fuckmachineopen/box/proc/handlesound()
	if(fucking)
		sound_token = GLOB.sound_player.PlayLoopingSound(src,ssound_id,'sound/sex/dryermachine.ogg',volume=100, range = 7, prefer_mute = TRUE)
	else
		QDEL_NULL(sound_token)

/obj/machinery/fuckmachineopen/box/machinefuck()
	if(Sex_Delay<world.time)
		patient.playsound_local(src.loc,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'),35,1)
		to_chat(patient,"<span class='sex'>Something [pick(installedtoy.sexverbs)] your [patient.Genitals]")
		patient.Lust-=rand(1,installedtoy.pleasure*10)/10 //
		Sex_Delay=rand(5,50)/10+world.time-installedtoy.speed/10
		if(patient.gender==FEMALE&&patient.Lust<=rand(3,10)&&prob(30)&&patient.stat == CONSCIOUS)
			var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
			playsound(patient,file(filename),100,1,skiprandfreq=1)
		if(patient.Lust<=0&&patient.timeuntilcancum<world.time)
			to_chat(patient,"<span class='sex'>Something [patient.gender==MALE ? "sucks up your cum" : "cleans out your vagina"]</span>")
			patient.timeuntilcancum=patient.CumTimer+world.time
			patient.Times_Came+=1
			patient.OnCum(0)
