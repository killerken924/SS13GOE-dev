/obj/item/sextoy
	name="Sex Toy"
	desc="This should not be here"
	icon='icons/obj/sextoys.dmi'
	var/pleasure
	var/randcolors=0
	var/genitals_for
	var/list/fuck_verbs =list()
	var/fuck_delay
	var/last_time_used
/obj/item/sextoy/New(L)
	..(L)
	if(randcolors)
		random_toy_color()

/obj/item/sextoy/proc/random_toy_color()
	var/icon/I=icon(icon,icon_state)
	I.Blend(rgb(rand(1,255),rand(1,255),rand(1,255)), ICON_ADD)
	icon=I
	return
/obj/item/sextoy/dildo
	name="Dildo"
	desc="Hey, its space. It can get pretty boring."
	icon='icons/obj/sextoys.dmi'
	icon_state="greyscaledildo"
	pleasure=5
	randcolors=1
	genitals_for="Vagina"
	fuck_verbs = list("Fucks","Penetrates","Perforates","Sticks","Probes")
	fuck_delay=5

/obj/item/sextoy/pocketpussy
	name="Pocket Pussy"
	desc="Hey, its space. It can get pretty boring."
	icon_state="pocketpussy"
	fuck_verbs = list("Fucks","Engulfs","Surrounds","Eats","Uses")
	genitals_for="Penis"
	pleasure=7
	fuck_delay=3

/obj/item/sextoy/attack(var/mob/living/M, var/mob/user)
	var/target_zone = user.zone_sel.selecting
	if(target_zone==BP_GROIN)
		if(ishuman(M))
			var/mob/living/carbon/human/H=M
			if(H.Genitals==genitals_for&&!H.Has_Clothes_That_Prevent_Sex())
				if(last_time_used<=world.time)
					if(user.a_intent==I_HELP)
						if(H==user)
							visible_message("<span class='sex'>[H] [pick(fuck_verbs)] [H.gender==FEMALE ? "herself" : "himself"] with the [src]</span>")
							last_time_used=fuck_delay*2+world.time
						else
							visible_message("<span class='sex'>[user] [pick(fuck_verbs)] [H]'s [H.Genitals] with the [src]</span>")
							last_time_used=fuck_delay+world.time
						H.PleaseSex(rand(1,pleasure*3)/10)
						playsound(src,pick('sound/sex/splat.ogg','sound/sex/squish.ogg'), 30, 1)
	return ..()

