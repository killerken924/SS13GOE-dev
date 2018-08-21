/obj/item/clothing/bra
	icon = 'icons/mob/human.dmi'
	name="Bra"
	desc="Thats a bra!"
	icon_state="bra"
	body_parts_covered = UPPER_TORSO
	slot_flags = SLOT_BRA
	var/hasalt=0
	var/usingalt=0
	var/org_icon_state

/obj/item/clothing/bra/update_clothing_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_wear_bra(1)

/obj/item/clothing/bra/New()
	..()
	if(hasalt)
		org_icon_state=icon_state
	return

/obj/item/clothing/bra/verb/changealt()
	set name = "Change Bra Style"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living/carbon/human)) return
	if(usr.stat) return
	var/mob/living/carbon/human/H=usr
	if(hasalt)
		pchangealt(H)
	else
		to_chat(H,"<span class='notice'>There is no other style</span>")

/obj/item/clothing/bra/proc/pchangealt(mob/living/carbon/human/H)
	if(hasalt)
		usingalt=!usingalt
		to_chat(H,"<span class='notice'>You change the style")
		icon_state="[org_icon_state][usingalt==1 ? "_alt" : ""]"
		update_clothing_icon()
	return

/obj/item/clothing/bra/lacy_bra
	icon = 'icons/mob/human.dmi'
	name="Lacy bra"
	desc="Kinky..."
	icon_state="lacy_bra"
	hasalt=1


/obj/item/clothing/bra/sports_bra
	icon = 'icons/mob/human.dmi'
	name="Sports Bra"
	desc="Its a sports bra, it make things not jiggle."
	icon_state="sports_bra"
	hasalt=1

/obj/item/clothing/bra/halterneck_bra
	icon = 'icons/mob/human.dmi'
	name="Halterneck Bra"
	desc="A halterneck bra"
	icon_state="halterneck_bra"
