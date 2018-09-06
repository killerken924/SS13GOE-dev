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
	if(random_quality_prob&&possible_random_quality&&possible_random_quality.len)
		random_quality=pick(possible_random_quality)
		icon_state="[icon_state]_[random_quality]"
	..(A)

/obj/item/crafting_item/stone
	name="Stone"
	desc="Thats a rock, i think...I hope."
	icon_state="stone"
	randomicon=1
	randomiconamts=3
	possible_random_quality=list("sharp")
