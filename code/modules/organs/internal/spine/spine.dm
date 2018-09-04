/obj/item/organ/internal/spine
	name="Spinal Cord"
	icon_state = "spine"
	w_class=ITEM_SIZE_LARGE
	organ_tag = BP_SPINE_MID
	parent_organ = BP_CHEST
	min_bruised_damage = 15
	min_broken_damage = 45
	max_damage = 70
	relative_size = 20
	var/list/controled_limbs =list()
	var/have_felt_last=0
	can_internal_bleed=0
/obj/item/organ/internal/spine/is_broken()
	if(damage>=min_broken_damage)
		return TRUE
	return FALSE
	//return (damage >= min_broken_damage
/obj/item/organ/internal/spine/take_damage(amount, var/silent=0)
	..(amount,silent)
	if(is_broken())
		if(!have_felt_last)
			var/numbfluff
			switch(organ_tag)
				if("spine")
					numbfluff="your whole lower body"
				if("upper spine")
					numbfluff="everything"
				if("lower spine")
					numbfluff="your lower body"
			to_chat(owner,"<span class='danger'>You feel a numbness instantly creep over [numbfluff]</span>")
			have_felt_last=1
			return
		return
	else
		var/numbfluff
		switch(organ_tag)
			if(BP_SPINE_MID)
				numbfluff="your whole lower body"
			if(BP_SPINE_UPPER)
				numbfluff="your neck"
			if(BP_SPINE_LOWER)
				numbfluff="your lower body"
		switch(amount)
			if(1 to 10)
				to_chat(owner,"<span class='danger'>You feel a small shock from [numbfluff]</span>")
			if(10 to 25)
				to_chat(owner,"<span class='danger'>You feel a painful electric shock from [numbfluff]</span>")
			if(25 to 44)
				to_chat(owner,"<span class='danger'>You feel a horrible electric shock from [numbfluff]</span>")

/obj/item/organ/internal/spine/upper //Neck snappage, basic insta-death. Can't breath can't pump blood, can't digest, can do anything. You are just a brain. Sad.
	name="Upper Spine"
	w_class=ITEM_SIZE_NORMAL
	organ_tag = BP_SPINE_UPPER
	parent_organ = BP_HEAD
	controled_limbs= 	list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM,BP_CHEST,BP_GROIN,BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)
	icon_state="brain_stem"

/obj/item/organ/internal/spine/middle
	name="Spine"
	w_class=ITEM_SIZE_NORMAL
	organ_tag = BP_SPINE_MID
	parent_organ = BP_CHEST
	controled_limbs=	list(BP_L_FOOT, BP_R_FOOT,BP_GROIN, BP_L_LEG, BP_R_LEG)

/obj/item/organ/internal/spine/lower
	name="Lower Spine"
	w_class=ITEM_SIZE_NORMAL
	organ_tag = BP_SPINE_LOWER
	parent_organ = BP_GROIN
	icon_state="lower_spine"
	controled_limbs=	list(BP_L_FOOT, BP_R_FOOT,BP_L_LEG, BP_R_LEG)

/obj/item/organ/internal/spine/Process()
	if(owner)
		if(is_broken()||has_control==NO_SPINAL_CONTROL)
			for(var/bptag in controled_limbs)
				var/obj/item/organ/external/E=owner.get_organ(bptag)
				if(E)
					E.has_control=NO_SPINAL_CONTROL
					for(var/obj/item/organ/internal/I in E.internal_organs)
						I.has_control=NO_SPINAL_CONTROL
		else
			for(var/bptag in controled_limbs)
				var/obj/item/organ/external/E=owner.get_organ(bptag)
				if(E)
					E.has_control=SPINAL_CONTROL
					for(var/obj/item/organ/internal/I in E.internal_organs)
						I.has_control=SPINAL_CONTROL
	..()
/obj/item/organ/internal/spine/upper/Process()
	//owner.stat  |=INCAPACITATION_FORCELYING//Sorry kid, you can't do anything ...
	..()
/obj/item/organ/internal/spine/handle_regeneration()//No regen for spine, sorry kid.
	return 0

