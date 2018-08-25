/obj/item/clothing/underwear
	icon = 'icons/mob/human.dmi'
	name="Underwear"
	desc="Huh.....,yeah..... thats underwear!"
	icon_state="briefs"
	var/FemaleUndie=0
	body_parts_covered = LOWER_TORSO
	slot_flags = slot_underwear
	var/hasalt=0
	var/usingalt=0
	var/org_icon_state
	var/multigender=1

/obj/item/clothing/underwear/New()
	..()
	if(hasalt)
		org_icon_state=icon_state
	return

/obj/item/clothing/underwear/verb/changealt()
	set name = "Change Underwear Style"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living/carbon/human)) return
	if(usr.stat) return
	var/mob/living/carbon/human/H=usr
	if(hasalt)
		pchangealt(H)
	else
		to_chat(H,"<span class='notice'>There is no other style</span>")

/obj/item/clothing/underwear/proc/pchangealt(mob/living/carbon/human/H)
	if(hasalt)
		usingalt=!usingalt
		to_chat(H,"<span class='notice'>You change the style")
		icon_state="[org_icon_state][usingalt==1 ? "_alt" : ""]"
		update_clothing_icon()
	return

/obj/item/clothing/underwear/update_clothing_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_wear_underwear(1)

/obj/item/clothing/underwear/panties
	name="Panties"
	desc="Female underwear"
	icon_state="panties"
	FemaleUndie=1
	hasalt=1
	usingalt=0
	multigender=0

/obj/item/clothing/underwear/lacy_thong
	name="Lacy Thong"
	desc="A lacy thong, for a female"
	icon_state="lacy_thong"
	FemaleUndie=1
	hasalt=1
	usingalt=0
	multigender=0

/obj/item/clothing/underwear/panties_noback
	name="Panties"
	desc="Panties, without a back...Kinky."
	icon_state="panties_noback"
	FemaleUndie=1
	multigender=0

/obj/item/clothing/underwear/thong
	name="Thong"
	desc="A thong"
	icon_state="thong"
	multigender=1

/obj/item/clothing/underwear/boxers
	name="Boxers"
	desc="Boxers, they don't show much."
	icon_state="boxers"
	multigender=1

/obj/item/clothing/underwear/boxers/boxersgreen
	icon_state="boxers_green_and_blue"

/obj/item/clothing/underwear/boxers/boxers_loveheart
	icon_state="boxers_loveheart"