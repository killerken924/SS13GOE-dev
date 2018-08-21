/obj/machinery/fuckmachineopen
	name = "Pleasure table classic"
	desc = "A fuck table..."
	icon = 'icons/obj/fuckmachines.dmi'
	icon_state = "tablemain"
	density = 1
	anchored = 1
	var/fucking=0
	var/mob/living/carbon/human/patient

	var/fucktimer=100
	var/currentfucktimer
	var/Sex_Delay

	var/obj/item/sexmachinetoy/installedtoy
	var/emergencyshutdown=0

	var/obj/item/weapon/reagent_containers/glass/beaker
/obj/machinery/fuckmachineopen/Initialize(mapload, d=0)
	..(mapload,d)
	var/obj/item/sexmachinetoy/penetrator/S = new(src)
	S.forceMove(src)
	installedtoy=S

/obj/machinery/fuckmachineopen/proc/takeoffclothes(obj/item/I)
	var/newloc=get_step(src,NORTH)
	patient.u_equip(I)
	I.forceMove(newloc)
	playsound(src.loc, 'sound/items/zip.ogg', 50, 0)
	return 1

/obj/machinery/fuckmachineopen/attack_hand(mob/living/carbon/user)
	if(patient&&fucking&&installedtoy&&!emergencyshutdown)
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		emergencyshutdown=1
		return
	if(patient&&!fucking&&installedtoy)
		emergencyshutdown=0
		if(patient.Genitals==installedtoy.genitals_meant_for)
			for(var/obj/item/I in list(patient.wear_suit, patient.w_uniform,patient.wear_underwear))
				if(I)
					if(!(takeoffclothes(I)))
						playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
						return
			patient.dir=SOUTH
			patient.canmove=0
			domachine()
		else
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
			return

/obj/machinery/fuckmachineopen/proc/domachine()
	set waitfor=0
	currentfucktimer=world.time+fucktimer
	playsound(src.loc, 'sound/sex/Fuckmachine.ogg', 50, 0)//fuckmachineoverlay
	var/image/I=image('icons/obj/fuckmachines.dmi',icon_state=installedtoy.overlaystate)
	I.plane = installedtoy.overlaystate_plane
	I.layer = installedtoy.overlaystate_layer
	overlays += I
	icon_state="tablemain"
	while(currentfucktimer>world.time&&!emergencyshutdown)
		if(!src.loc==patient.loc)
			emergencyshutdown=1
		sleep(3)
		fucking=1
		patient.dir=SOUTH
		machinefuck()
		handlelube()
	playsound(src.loc, 'sound/machines/chime.ogg', 50, 0)
	overlays.Cut()
	icon_state = "tablemain"
	patient.canmove=1
	fucking=0
	patient.resting=0
	patient=null
	emergencyshutdown=0

/obj/machinery/fuckmachineopen/proc/handlelube()
	if(beaker)
		to_chat(world,"floop")
		if(beaker.reagents.total_volume<=0)
			handlemachineheat()
			return
		to_chat(world,"doop")
		if(beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				to_chat(world,"bloop")
				R.touch_mob(patient,rand(10,100)/10)
				beaker.reagents.remove_any(1)
		else
			handlemachineheat()
		return
	else
		handlemachineheat()
/obj/machinery/fuckmachineopen/Process()
	if(patient)
		if(!patient.loc==src.loc)
			patient=null
/obj/machinery/fuckmachineopen/proc/handlemachineheat()
	var/turf/location = get_turf(src)
	location.hotspot_expose(1000, 500)

/obj/machinery/fuckmachineopen/MouseDrop_T(var/mob/living/carbon/human/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	if(patient)
		to_chat(user, "<span class='warning'>Someone is already on it.</span>")
		if(!patient.loc==src.loc)
			takepatient(target)
		return
	takepatient(target)

/obj/machinery/fuckmachineopen/proc/takepatient(var/mob/living/carbon/human/C)
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.dropInto(loc)
	C.dir=SOUTH
	patient=C

/obj/machinery/fuckmachineopen/proc/machinefuck()//sexverbs
	if(Sex_Delay<world.time)
		playsound(src,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 60, 1)
		src.visible_message("<span class='sex'> [src.name] [pick(installedtoy.sexverbs)] [patient]'s [patient.Genitals]</span>")
		patient.Lust-=rand(1,installedtoy.pleasure*10)/10 //
		Sex_Delay=rand(5,50)/10+world.time-installedtoy.speed/10
		if(patient.gender==FEMALE&&patient.Lust<=rand(3,10)&&prob(30)&&patient.stat == CONSCIOUS)
			var/filename="sound/sex/femalemoan/[rand(1,33)].ogg"
			playsound(patient,file(filename),100,1,skiprandfreq=1)

		if(patient.Lust<=0&&patient.timeuntilcancum<world.time)
			src.visible_message("<span class='sex'>The [src.name] [patient.gender==MALE ? "sucks up [patient]'s cum" : "cleans out [patient]'s vagina"]</span>")
			patient.timeuntilcancum=patient.CumTimer+world.time
			patient.Times_Came+=1
			patient.OnCum(1)
			//if(patient.gender==FEMALE&&patient.stat == CONSCIOUS)
			//	playsound(patient.loc,'sound/sex/F_Orgasm_1.ogg', 50, 1)

/obj/machinery/fuckmachineopen/verb/remove_beaker()
	set src in oview(1)
	set name="Remove Beaker"
	set category ="Object"
	if(beaker)
		to_chat(usr,"<span class='notice'>You remove the beaker</span>")
		beaker.forceMove(usr.loc)
		beaker=null

/obj/machinery/fuckmachineopen/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		add_fingerprint(user)
		if(!beaker)
			beaker = I
			user.drop_item()
			I.forceMove(src)
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has a beaker already.</span>")
		return
	if(istype(I, /obj/item/weapon/screwdriver))
		if(installedtoy)
			to_chat(user,"<span class='notice'>You uninstall the [installedtoy.name]</span>")
			installedtoy.forceMove(user.loc)
			installedtoy=null
			return
	if(istype(I, /obj/item/sexmachinetoy))
		if(!installedtoy)
			installedtoy=I
			user.drop_item()
			I.forceMove(src)
			to_chat(user,"<span class='notice'>You install the [installedtoy.name]</span>")
			return
		else
			to_chat(user,"<span class='warning'>There is already a sextoy in it!</span>")
	..()

/obj/item/sexmachinetoy
	name="Sex Toy"
	desc="This should not be here"
	icon='icons/obj/fuckmachines.dmi'
	var/pleasure=1
	var/overlaystate
	var/overlaystate_layer
	var/overlaystate_plane
	var/genitals_meant_for
	var/list/sexverbs = list()
	var/speed=5

/obj/item/sexmachinetoy/blowerextreme
	name="Blower Extreme"
	desc="Meant for a machine. Used on a penis"
	icon_state="blower_extreme"
	overlaystate="blower_extreme_overlay"
	pleasure=4
	genitals_meant_for="Penis"
	overlaystate_plane = ABOVE_HUMAN_PLANE
	overlaystate_layer = ABOVE_HUMAN_LAYER
	sexverbs = list("Blows","Engulfs","Swallows","Surrounds")

/obj/item/sexmachinetoy/penetrator
	name="Penetrator Extreme"
	desc="A dildo built for a fuck machine"
	icon_state="penetratorextreme"
	overlaystate="penetratorextreme_overlay"
	pleasure=2
	genitals_meant_for="Vagina"
	overlaystate_plane = LYING_MOB_PLANE
	overlaystate_layer =LYING_MOB_LAYER
	sexverbs = list("Fucks","Penetrates","Clogs","Perforates","Destroys")







