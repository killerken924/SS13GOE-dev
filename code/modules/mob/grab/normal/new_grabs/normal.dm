
/obj/item/grab/normal

	type_name = GRAB_NORMAL
	start_grab_name = NORM_PASSIVE
	var/obj/item/organ/external/GrabbedOrgan

/obj/item/grab/normal/init()
	..()
	GrabbedOrgan=get_targeted_organ()
	if(affecting.w_uniform)
		affecting.w_uniform.add_fingerprint(assailant)

	assailant.put_in_active_hand(src)
	assailant.do_attack_animation(affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	visible_message("<span class='warning'>[assailant] has grabbed [affecting] by the  [GrabbedOrgan.name]!</span>")
	affecting.grabbed_by += src

	if(!(affecting.a_intent == I_HELP))
		upgrade(TRUE)

/datum/grab/normal
	type_name = GRAB_NORMAL

	var/drop_headbutt = 1
	var/obj/item/organ/external/GrabbedOrgan
	icon = 'icons/mob/screen1.dmi'

	upgrab_name = NORM_WRENCH

	help_action = "inspect"
	disarm_action = "pin"
	grab_action = "jointlock"
	harm_action = "dislocate"

/datum/grab/normal/proc/wrench(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	GrabbedOrgan=G.get_targeted_organ()
	if(prob(50))
		affecting.visible_message("<span class='notice'>[assailant] wrenches [affecting] [GrabbedOrgan.name]</span>")
		GrabbedOrgan.take_damage(50)
		return 1
	else
		affecting.visible_message("<span class='notice'>[assailant] attempts to wrench [affecting] [GrabbedOrgan.name]</span>")
		return 0

/datum/grab/normal/can_upgrade(var/obj/item/grab/G)
	if(istype(upgrab,/datum/grab/normal/wrench))
		to_chat(G.assailant,"derp")
		wrench(G)
		return 1
	..()
/datum/grab/normal/upgrade(var/obj/item/grab/G)
	if(!upgrab)
		return
	if (can_upgrade(G))
		upgrade_effect(G)
		admin_attack_log(G.assailant, G.affecting, "tightens their grip on their victim to [upgrab.state_name]", "was grabbed more tightly to [upgrab.state_name]", "tightens grip to [upgrab.state_name] on")
		return upgrab
	else
		to_chat(G.assailant, "<span class='warning'>[string_process(G, fail_up)]</span>")
		return

/datum/grab/normal/on_hit_help(var/obj/item/grab/normal/G)
	GrabbedOrgan = G.get_targeted_organ()
	if(GrabbedOrgan)
		return GrabbedOrgan.inspect(G.assailant)

/datum/grab/normal/on_hit_disarm(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	affecting.visible_message("<span class='notice'>[assailant]=assailant,[affecting]=affecting</span>")
	return 0

/datum/grab/normal/on_hit_grab(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	affecting.visible_message("<span class='notice'>[assailant]=assailant,[affecting]=affecting</span>")
	return 0

/datum/grab/normal/on_hit_harm(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	affecting.visible_message("<span class='notice'>[assailant]=assailant,[affecting]=affecting</span>")
	return 0