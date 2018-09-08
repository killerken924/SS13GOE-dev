/mob/living/carbon/human
	var/list/craftable_items=list()
	var/crafting=0

/mob/living/carbon/human/verb/Craft()
	set name = "Craft Basic"
	set desc = "Basic Items."
	set category = "Crafting"
	Crafting_Menu()

/mob/living/carbon/human/proc/Crafting_Menu()
	if(!istype(src)) return

	var/dat = list()
	dat += "<html><body><hr><b>Craftable Items</b><hr>"
	if(craftable_items&&craftable_items.len)
		for(var/datum/craftable_item/I in craftable_items)
			dat += "<a href='?src=\ref[src];[I.name]=1'>:[I.name]</font></a><br>"
	var/datum/browser/popup = new(src, "turbolift_panel", "Crafting", 230, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return

/mob/living/carbon/human/proc/Generate_Craftable_Items()
	craftable_items=list()
	for(var/craftype in typesof(/datum/craftable_item)-/datum/craftable_item)
		var/datum/craftable_item/I=new craftype()
		craftable_items+=I
/mob/living/carbon/human/proc/Attempt_Craft(var/datum/craftable_item/I)
	if(crafting)
		to_chat(src,"<span class='notice'>You can't do that now</span>")
		return 0
	if(I)
		if(!I.can_craft(src))
			to_chat(src,"<span class='notice'>Failed craft</span>")
			return 0
		var/list/crafting_items=I.can_craft(src)
		I.start_craft(src,crafting_items)




