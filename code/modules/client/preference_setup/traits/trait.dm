/datum/preferences
	var/list/chosen_traits=list()
	var/list/trait_list=list()
	var/max_trait_points=5
	var/trait_points=0
	var/updatebodyneed=0
/datum/category_item/player_setup_item/realtraits
	name = "Traits"
	sort_order = 1

/datum/category_item/player_setup_item/realtraits/New()
	..()
	Initialize_Selectable_Traits()

/datum/category_item/player_setup_item/realtraits/proc/Initialize_Selectable_Traits()
	pref.trait_list=list()
	for(var/R in typesof(/datum/newtraits)-/datum/newtraits)
		var/datum/newtraits/T=R
		var/datum/newtraits/newtrait=new T()
		pref.trait_list+=newtrait
	return

/datum/category_item/player_setup_item/realtraits/proc/get_point_cost()
	var/pointcost=0
	for(var/datum/newtraits/T in pref.chosen_traits)
		pointcost+=T.pointcost

	return pointcost

/datum/category_item/player_setup_item/realtraits/proc/update_points_spent()
	pref.trait_points=get_point_cost()
	pref.update_preview_icon()

/datum/category_item/player_setup_item/realtraits/content(var/mob/user)//get_point_cost()
	. = list()
	pref.update_preview_icon()
	user << browse_rsc(pref.preview_icon, "previewicon.png")
	.+="<b>[pref.trait_points]/[pref.max_trait_points]"
	for(var/datum/newtraits/T in pref.trait_list)
		if(pref.chosen_traits.Find(T)&&pref.trait_points+T.pointcost>pref.max_trait_points)//
			. += "<a href='?src=\ref[src];[T.namecode]=1'><b>[T.name]([T.pointcost]):[pref.chosen_traits.Find(T) ? "Yes" : "No"]</b></a><br>"
		else
			if(T.gender)
				if(pref.gender==T.gender)
					if(pref.trait_points+T.pointcost>pref.max_trait_points)
						. += "<b>[T.name]([T.pointcost])</b><br>"
					else
						. += "<a href='?src=\ref[src];[T.namecode]=1'><b>[T.name]([T.pointcost]):[pref.chosen_traits.Find(T) ? "Yes" : "No"]</b></a><br>"
			else
				if(pref.trait_points+T.pointcost>pref.max_trait_points)
					. += "<b>[T.name]([T.pointcost])</b><br>"
				else
					. += "<a href='?src=\ref[src];[T.namecode]=1'><b>[T.name]([T.pointcost]):[pref.chosen_traits.Find(T) ? "Yes" : "No"]</b></a><br>"
		. = jointext(.,null)

/datum/category_item/player_setup_item/realtraits/OnTopic(var/href,var/list/href_list, var/mob/user)
	update_points_spent()
	for(var/datum/newtraits/T in pref.trait_list)
		if(href_list["[T.namecode]"])
			if(pref.chosen_traits.Find(T))
				pref.chosen_traits-=T
			else
				pref.chosen_traits+=T
//	reset_limbs()
	update_points_spent()
	pref.update_preview_icon()
	return TOPIC_REFRESH_UPDATE_PREVIEW
//	return ..()

/datum/category_item/player_setup_item/realtraits/proc/get_trait_from_name(n)
	for(var/datum/newtraits/T in pref.trait_list)
		if(T.name==n)
			return T

/datum/category_item/player_setup_item/realtraits/load_character(var/savefile/S)
	var/list/L=list()
	pref.chosen_traits=list()
	S["chosen_traits"]>>L//pref.chosen_traits
	if(islist(L))
		for(var/datum/newtraits/T in L)
			var/datum/newtraits/R=get_trait_from_name(T.name)
			if(R)
				pref.chosen_traits+=R
	update_points_spent()

/datum/category_item/player_setup_item/realtraits/save_character(var/savefile/S)
//	var/list/L=list()
	S["chosen_traits"]<<pref.chosen_traits

	update_points_spent()



