#define WARDROBE_BLIND_MESSAGE(fool) "\The [src] flashes a light at \the [fool] as it states a message."

/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

	var/static/list/amount_of_underwear_by_id_card

/obj/structure/undies_wardrobe/attackby(var/obj/item/underwear/underwear, var/mob/user)
	..()

/obj/structure/undies_wardrobe/proc/remove_id_card(var/id_card)
	LAZYREMOVE(amount_of_underwear_by_id_card, id_card)
	GLOB.destroyed_event.unregister(id_card, src, /obj/structure/undies_wardrobe/proc/remove_id_card)

/obj/structure/undies_wardrobe/attack_hand(var/mob/user)
	if(!human_who_can_use_underwear(user))
		to_chat(user, "<span class='warning'>Sadly there's nothing in here for you to wear.</span>")
		return
	interact(user)

/obj/structure/undies_wardrobe/interact(var/mob/living/carbon/human/H)
	return

/obj/structure/undies_wardrobe/proc/human_who_can_use_underwear(var/mob/living/carbon/human/H)
	if(!istype(H) || !H.species || !(H.species.appearance_flags & HAS_UNDERWEAR))
		return FALSE
	return TRUE

/obj/structure/undies_wardrobe/CanUseTopic(var/user)
	if(!human_who_can_use_underwear(user))
		return STATUS_CLOSE

	return ..()

/obj/structure/undies_wardrobe/Topic(href, href_list, state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/H = usr
	if(.)
		interact(H)

/obj/structure/undies_wardrobe/proc/exlude_none(var/list/L)
	. = L.Copy()

#undef WARDROBE_BLIND_MESSAGE
