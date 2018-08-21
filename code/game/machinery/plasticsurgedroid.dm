/obj/machinery/plastic_surgedroid
	name = "Cosmetic Surgery Machine"
	desc = "A stand up plastic surgery machine, neat."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "surgdroid_open"
	density = 0
	anchored = 1
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	var/closed=0
	var/mob/living/carbon/activator
	var/mob/living/carbon/human/patient=null
	var/insurgery=0

/obj/machinery/plastic_surgedroid/proc/go_in(var/mob/living/carbon/human/M, var/mob/user)
	M.stop_pulling()
	M.forceMove(src)
	patient = M
	add_fingerprint(user)
	update_icon()
	return 1

/obj/machinery/plastic_surgedroid/proc/go_out()
	patient.forceMove(get_step(loc, SOUTH))
	patient=null
	update_icon()
	closed=0
	return

/obj/machinery/plastic_surgedroid/Process()
	return

/obj/machinery/plastic_surgedroid/update_icon()
	if(patient&&closed)
		icon_state="surgdroid_closed"
		density=1
	else
		icon_state="surgdroid_open"
		density=0
	return

/obj/machinery/plastic_surgedroid/attack_hand(mob/living/carbon/user)
	if(closed==0)
		if(!insurgery)
			for(var/mob/living/carbon/human/H in loc)
				if(H.stat==DEAD)
					continue
				else
					patient=H
			if(patient)
				user.visible_message("<span class='warning'>[user] closes the [src.name].</span>", \
				"<span class='notice'>You close the [src.name].</span>")
				closed=1
				activator=user
				src.speak("Please select surgery")
				go_in(patient,user)
				src.speak("Please Select Surgery")
				var/surgerymode=user.surgery_ask()
				DoSurgery(surgerymode,user)
				return
/mob/living/carbon/proc/surgery_ask(mob/living/carbon/human/target)
	canmove = 0
	.=input("Select Surgery","Surgery") in list("Breast Implant A","Breast Implant B","Breast Implant C","Breast Implant D","Breast Implant DD")
	canmove = 1
	return .
/obj/machinery/plastic_surgedroid/proc/DoSurgery(type,user)
	insurgery=1
	to_chat(patient,"<span class='danger'>you feel something lift up your shirt!</span>")
	switch(type)
		if("Breast Implant A")
			var/obj/item/organ/external/chest/affected
			for(var/obj/item/organ/external/E in patient.organs)
				if(istype(E,/obj/item/organ/external/chest))
					affected=E
			var/oldbreast_size=affected.breast_size

			affected.breast_size="A"

			src.speak("Starting surgery")

			dosound()

			src.speak("All done!")

			Breast_Fluff_Text(patient,affected,oldbreast_size)
		if("Breast Implant B")
			var/obj/item/organ/external/chest/affected
			for(var/obj/item/organ/external/E in patient.organs)
				if(istype(E,/obj/item/organ/external/chest))
					affected=E
			var/oldbreast_size=affected.breast_size

			affected.breast_size="B"

			src.speak("Starting surgery")

			dosound()

			src.speak("All done!")

			Breast_Fluff_Text(patient,affected,oldbreast_size)
		if("Breast Implant C")
			var/obj/item/organ/external/chest/affected
			for(var/obj/item/organ/external/E in patient.organs)
				if(istype(E,/obj/item/organ/external/chest))
					affected=E
			var/oldbreast_size=affected.breast_size

			affected.breast_size="C"

			src.speak("Starting surgery")

			dosound()

			src.speak("All done!")

			Breast_Fluff_Text(patient,affected,oldbreast_size)
		if("Breast Implant D")
			var/obj/item/organ/external/chest/affected
			for(var/obj/item/organ/external/E in patient.organs)
				if(istype(E,/obj/item/organ/external/chest))
					affected=E
			var/oldbreast_size=affected.breast_size

			affected.breast_size="D"

			src.speak("Starting surgery")

			dosound()

			src.speak("All done!")

			Breast_Fluff_Text(patient,affected,oldbreast_size)
		if("Breast Implant DD")
			var/obj/item/organ/external/chest/affected
			for(var/obj/item/organ/external/E in patient.organs)
				if(istype(E,/obj/item/organ/external/chest))
					affected=E
			var/oldbreast_size=affected.breast_size

			affected.breast_size="DD"

			src.speak("Starting surgery")

			dosound()

			src.speak("All done!")

			Breast_Fluff_Text(patient,affected,oldbreast_size)
	patient.update_body()
	insurgery=0
	go_out()
/obj/machinery/plastic_surgedroid/proc/dosound()
	playsound(src.loc, 'sound/weapons/saberon.ogg', 50, 0)
	sleep(rand(20,50))
	playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 0)
	sleep(rand(10,30))
	playsound(src.loc, 'sound/items/trayhit2.ogg', 50, 0)
	sleep(rand(10,30))
	playsound(src.loc, 'sound/items/oneding.ogg', 50, 0)

/obj/machinery/plastic_surgedroid/proc/speak(var/message)
	if (!message)
		return
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return




