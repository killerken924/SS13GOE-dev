/mob/living/carbon/human
	var/list/traits=list()

/datum/newtraits
	var/name
	var/desc
	var/mob/living/carbon/human/owner
	var/gender
	var/namecode//for lobby
	var/pointcost=0
	var/affect_body=0 //for updating the body on the lobby because of the primitive system

/datum/newtraits/New(mob/living/carbon/human/o)
	if(src.gender&&o)
		if(o.gender==src.gender)
			owner=o
			return 1
		else
			return 0

/datum/newtraits/likes_anal
	name="Likes Anal"
	desc="You like anal"
	namecode="Likes_Anal"
	pointcost=1

/datum/newtraits/large_vagina
	name="Large Vagina"
	desc="You have a large vagina, you could put a lot in there."
	gender=FEMALE
	namecode="Large_Vagina"
	pointcost=3

/datum/newtraits/unique_body
	name="Unique Body"
	desc="You have a more unique body."
	gender=FEMALE
	namecode="Unique_Body"
	pointcost=3



/mob/living/carbon/human/proc/find_trait(var/t)
	for(t in traits)
		return 1
	return 0

