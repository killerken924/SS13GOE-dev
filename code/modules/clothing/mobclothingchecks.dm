/mob/living/carbon/human/proc/Clothing_Check(obj/item/clothing/I,slot)
	if(!I)
		return 0
	if(istype(I,/obj/item/clothing/underwear))
		var/obj/item/clothing/underwear/U = I
		if(!U.multigender)
			if(U.FemaleUndie&&!src.gender==FEMALE)
				to_chat(src,"<span class='notice'> These won't fit </span>")
				return 0
			if(!U.FemaleUndie&&!src.gender==MALE)
				to_chat(src,"<span class='notice'> These won't fit </span>")
				return 0
	if(istype(I,/obj/item/clothing/bra))
	//	var/obj/item/clothing/bra/B = I
		if(!src.gender==FEMALE)
			to_chat(src,"<span class='notice'> I don't need a bra...</span>")
			return 0
	return 1