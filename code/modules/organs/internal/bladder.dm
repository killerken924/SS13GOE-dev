/obj/item/organ/internal/bladder
	name = "bladder"
	icon_state = "bladder"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_BLADDER
	parent_organ = BP_GROIN
	min_bruised_damage = 15
	min_broken_damage = 30
	max_damage = 50
	relative_size = 20
	var/release_damage=5

	var/datum/reagents/metabolism/Bladder_Contents = null
	var/max_units=40

/obj/item/organ/internal/bladder/New()
	..()
	Bladder_Contents= new/datum/reagents/metabolism(max_units, owner, CHEM_INGEST)

/obj/item/organ/internal/bladder/robotize()
	. = ..()
	icon_state = "bladder-prosthetic"

/obj/item/organ/internal/bladder/die()
	..()
	//owner.piss()

/obj/item/organ/internal/bladder/take_damage(amount, var/silent=0)
	..(amount,silent)
	if(amount>=release_damage)
		owner.DoPee()

/obj/item/organ/internal/bladder/Process()
	..()
	if(owner)
		do_bladder()
		if(is_bruised())
			max_units=max(1,max_units-=10)
			if(prob(5))
				owner.DoPee()

/obj/item/organ/internal/bladder/proc/do_bladder()
	if(!owner.get_organ(parent_organ).has_control&&Bladder_Contents.total_volume)
		owner.DoPee()
		return
	if(Bladder_Contents.total_volume>max_units)
		if(owner.peemessagecooldown<=world.time)
			to_chat(owner,"<span class='notice'>You really need to [pick("pee","piss","urinate")]</span>")
			owner.peemessagecooldown=world.time+500

/mob/living/carbon
	var/peemessagecooldown

/mob/living/carbon/human/verb/Pee()
	set category ="IC"
	set name="Pee"
	if(CanPee())
		DoPee()
	else
		to_chat(src,"<span class='warning'>You don't need too</span>")
		return

/mob/living/carbon/human/proc/DoPee()
	var/obj/item/organ/internal/bladder/B=internal_organs_by_name[BP_BLADDER]
	if(B.Bladder_Contents.total_volume)
		var/peeamount=max(1,B.Bladder_Contents.total_volume)
		var/turf/Peelocation=get_step(src,dir)
		if(Genitals=="Vagina")
			Peelocation=src.loc	//peeamount
		var/datum/reagents/tempcont=new(B.Bladder_Contents.total_volume,src)
		B.Bladder_Contents.trans_to_holder(tempcont,peeamount)
		tempcont.Destroy()
		switch(PeeLocation())
			if(0)//Pees into toliet
				return
			if(1)//Pees infront of you
				new/obj/effect/actual_water/urine(Peelocation,peeamount/10)
				return
			if(2)//Pees on you
				new/obj/effect/actual_water/urine(src.loc,peeamount/10)
				return


/mob/living/carbon/human/proc/PeeLocation()
	var/turf/Peelocation=get_step(src,dir)
	for(var/obj/structure/toilet/T in src.loc)
		if(T.open)
			visible_message("<span class='warning'>[src.name] [pick("pisses","pees","urinates")] into the [T]</span>")
			return 0
		else
			visible_message("<span class='warning'>[src.name] [pick("pisses","pees","urinates")] on top of the [T]</span>")
			return 2
	if(Peelocation.density==1)
		if(Genitals=="Penis")
			return 1
		for(var/obj/structure/urinal/U in src.loc)
			visible_message("<span class='warning'>[src.name] [pick("pisses","pees","urinates")] into the [U]</span>")
			return 0
		return 2
	return 1

/mob/living/carbon/human/proc/CanPee()
	if(src.Has_Clothes_That_Prevent_Sex())
		return
	var/obj/item/organ/internal/bladder/B=internal_organs_by_name[BP_BLADDER]
	if(B.Bladder_Contents.total_volume>=B.max_units)
		return 1
	return 0


