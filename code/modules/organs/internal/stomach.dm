/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60
	var/vomit_damage=1

	var/datum/reagents/metabolism/Digested_Contents = null
	var/max_units=50



/obj/item/organ/internal/stomach/New()
	..()
	Digested_Contents= new/datum/reagents/metabolism(max_units, owner, CHEM_INGEST)

/obj/item/organ/internal/stomach/robotize()
	. = ..()
	icon_state = "stomach-prosthetic"

/obj/item/organ/internal/stomach/die()
	..()
	owner.vomit()

/obj/item/organ/internal/stomach/take_damage(amount, var/silent=0)
	..(amount,silent)
	if(amount>=vomit_damage)
		owner.vomit()

/obj/item/organ/internal/stomach/Process()
	..()

	if(owner)
		if(!owner.get_organ(parent_organ).has_control)
			return
		Handle_Digest()
		if (germ_level > INFECTION_LEVEL_ONE)
			if(prob(1))
				to_chat(owner, "<span class='danger'>Your stomach feels horrible.</span>")
		if (germ_level > INFECTION_LEVEL_TWO)
			if(prob(1))
				spawn owner.vomit()
		if(is_bruised())
			if(prob(10))
				spawn owner.vomit()
		var/blood_volume = owner.get_blood_volume()
		if(is_bruised()||blood_volume < BLOOD_VOLUME_SAFE)
			if(owner.nutrition >= 300)
				owner.nutrition -= 20
			else if(owner.nutrition >= 200)
				owner.nutrition -= 8
		return

/obj/item/organ/internal/stomach/proc/Digest_Reagent(var/datum/reagent/R)
	if(R)
		var/dig_rate=R.metabolism
		if(R.ingest_met)
			dig_rate=R.ingest_met
		dig_rate= owner.get_adjusted_metabolism(dig_rate)
		var/effective = dig_rate
		effective *= (MOB_MEDIUM/owner.mob_size)
		if(R.reagent_state == LIQUID)
			var/obj/item/organ/internal/bladder/B=owner.internal_organs_by_name[BP_BLADDER]
			B.Bladder_Contents.add_reagent(R.type,dig_rate)
		else
			Digested_Contents.add_reagent(R.type,dig_rate)
		R.affect_ingest(owner, null, effective)
		owner.regenerate_blood(0.01 + owner.chem_effects[CE_BLOODRESTORE])
		R.remove_self(dig_rate)

//use owner.ingested , ingested goes to chem doses..
/obj/item/organ/internal/stomach/proc/Handle_Digest()
	if(!owner.get_organ(parent_organ).has_control&&Digested_Contents.total_volume)
		owner.DoPoop()
		return
	if(Digested_Contents.total_volume>=max_units)
		if(owner.poopmessagecooldown<=world.time)
			to_chat(owner,"<span class='warning'>You need to visit the bathroom</span>")
			owner.poopmessagecooldown=world.time+500

	return

/mob/living/carbon/human/var/poopmessagecooldown=0

/mob/living/carbon/human/verb/Poop()
	set category ="IC"
	set name="Poop"
	switch(CanPoop())
		if(0)
			to_chat(src,"<span class='warning'>You don't need too</span>")
		if(1)
			DoPoop()
		if(2)
			to_chat(src,"<span class='warning'>You have clothes on..</span>")
	return

/mob/living/carbon/human/proc/DoPoop()
	//trans_to_holder
	var/obj/item/organ/internal/stomach/S=internal_organs_by_name[BP_STOMACH]
	if(S.Digested_Contents.total_volume)
		var/shitamount=max(1,S.Digested_Contents.total_volume)
		switch(PoopLocation())
			if(0)//Into Toliet
				var/datum/reagents/tempcont=new(S.Digested_Contents.total_volume,src)
				S.Digested_Contents.trans_to_holder(tempcont,shitamount)
				tempcont.Destroy()
				return
		var/obj/item/weapon/reagent_containers/poop/P=new(src.loc)
		S.Digested_Contents.trans_to_holder(P.reagents,shitamount)
		//visible_message("<span class='warning'>[src.name] [pick("shits","poops","deficates")] on the [loc]</span>")

/mob/living/carbon/human/proc/CanPoop()
	if(src.Has_Clothes_That_Prevent_Sex())
		return 2
	var/obj/item/organ/internal/stomach/S=internal_organs_by_name[BP_STOMACH]
	if(S.Digested_Contents.total_volume>=10)
		return 1
	return 0

/mob/living/carbon/human/proc/PoopLocation()
	for(var/obj/structure/toilet/T in src.loc)
		if(T.open)
			visible_message("<span class='warning'>[src.name] [pick("shits","poops","deficates")] into the [T]</span>")
			return 0
		else
			visible_message("<span class='warning'>[src.name] [pick("shits","poops","deficates")] on top of the [T]</span>")
			return 2
	return 1





