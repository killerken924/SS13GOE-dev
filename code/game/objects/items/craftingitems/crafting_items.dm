/obj/item/crafting_item
	name="what?"
	icon='icons/obj/crafting_item.dmi'
	var/randomicon=0
	var/randomiconamts=0
	var/random_quality
	var/list/possible_random_quality=list()
	var/random_quality_prob=30

/obj/item/crafting_item/New(A)
	if(randomicon&&randomiconamts)
		icon_state="[icon_state]_[rand(1,randomiconamts)]"
	/*if(random_quality_prob&&possible_random_quality&&possible_random_quality.len)
		random_quality=pick(possible_random_quality)
		icon_state="[icon_state]_[random_quality]"*/
	..(A)

/obj/item/crafting_item/stone
	name="Stone"
	desc="Thats a rock, i think...I hope."
	icon_state="stone"
	randomicon=1
	randomiconamts=3

/obj/item/crafting_item/stone/attackby(var/obj/item/I, var/mob/user)
	playsound(user.loc,'sound/items/zippo_close.ogg',50,1)
	if(prob(5))
		var/turf/T=get_step(user,user.dir)
		if(!T.density)
			new/obj/effect/sparks(T)
	..()

/obj/item/crafting_item/wooden_stick
	name="Stick"
	desc="Thats a stick, i think...I hope."
	icon_state="wooden_stick"
	randomicon=1
	randomiconamts=2

/obj/item/crafting_item/lashings
	name="Lashings"
	desc="Looks like some rope.."
	icon_state="lashings"
	randomicon=1
	randomiconamts=2

/obj/item/wooden_staff
	name="Wooden Staff"
	desc="Thats a staff"
	icon='icons/obj/crafting_item.dmi'
	icon_state="wooden_staff"
	force=12
	var/sharpened=0

/obj/item/wooden_staff/stone_spear
	name="Wooden Staff"
	desc="Thats a staff"
	icon='icons/obj/crafting_item.dmi'
	icon_state="wooden_staff_stone_spear"
	force=15
	sharp=1

/obj/item/stone_knife
	name="Wooden Staff"
	desc="Thats a staff"
	icon='icons/obj/crafting_item.dmi'
	icon_state="stone_knife"
	sharp=1
	force=5
