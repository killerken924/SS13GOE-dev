/datum/craftable_item
	var/list/required_basic_skills=list()
	var/list/required_advanced_skills=list()
	var/stamina_take=0
	var/time_to_take=0
	var/list/required_items=list()
	var/name="Item"
	var/obj/crafted_item

/datum/craftable_item/proc/can_craft(var/mob/living/carbon/human/H)
	var/list/items_on_ground=list()
	var/list/crafting_items=list()
	if(H)
		if(!crafted_item)//||!istype(crafted_item))
			return 0
		if(required_basic_skills&&required_basic_skills.len)
			for(var/A in required_basic_skills)
				var/mobskill=H.Skills.get_skill(A).points
				if(!mobskill||mobskill<required_basic_skills.[A])
					return 0
		if(required_advanced_skills&&required_advanced_skills.len)
			for(var/A in required_advanced_skills)
				var/mobskill=H.Get_Adv_Skill(A).points
				if(!mobskill||mobskill<required_advanced_skills.[A])
					return 0

		for(var/obj/O in get_step(H,H.dir))
			if(O)
				if(!O.anchored)
					items_on_ground+=O

		for(var/Itemsreq in required_items)
			var/amt_needed=required_items[Itemsreq]
			var/total_needed=amt_needed
			var/list/temp_craft_items=list()
			if(amt_needed)
				while(amt_needed>0)
					for(var/obj/item/A in items_on_ground)
						if(istype(A,Itemsreq)&&amt_needed>0)
							temp_craft_items+=A
							amt_needed-=1
						else if(amt_needed<=0)
							break
						else
							continue
					break
			if(!temp_craft_items)
				return 0

			if(temp_craft_items.len==total_needed)
				crafting_items+=temp_craft_items
				continue
			else

				return 0
		return crafting_items


/datum/craftable_item/proc/start_craft(var/mob/living/carbon/human/H,var/list/craftingitems=list())
	if(craftingitems&&craftingitems.len)
		to_chat(H,"<span class='notice'>You start crafting the [name]</span>")
		H.crafting=1
		if(do_after(H, HUMAN_STRIP_DELAY, H.loc, progress = 1))
			//var/obj/NewlyCraftedItem=
			new crafted_item(get_step(H,H.dir))
			for(var/A in craftingitems)
				del A
			to_chat(H,"<span class='notice'>You crafted the [name]</span>")
		else
			to_chat(H,"<span class='warning'>You have failed</span>")
	H.crafting=0

/datum/craftable_item/stone_knife
	required_items=list(/obj/item/crafting_item/stone=1)
	required_basic_skills=list(/datum/realskills/intelligence=2)
	time_to_take=10
	stamina_take=1
	name="Stone Knife"
 	//crafted_item=/obj/item/stone_knife

/datum/craftable_item/wooden_staff//
	required_items=list(/obj/item/crafting_item/wooden_stick=2,/obj/item/crafting_item/lashings=1)
	required_basic_skills=list(/datum/realskills/intelligence=2)
	time_to_take=20
	stamina_take=3
	name="Wooden Staff"
	crafted_item=/obj/item/wooden_staff


