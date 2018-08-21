var/Can_Change_Skills=0//
/datum/preferences
	var/max_skill_points=15
	var/skill_points_used=0
	var/list/selectable_skills=list()
	var/started_couldnt_edit_skills=0
/datum/category_item/player_setup_item/realskills
	name = "Traits"
	sort_order = 1

/datum/category_item/player_setup_item/realskills/New()
	..()
	if(Can_Change_Skills)
		Initialize_Skills()
	else
		if(pref.selectable_skills&&pref.selectable_skills.len)
			for(var/datum/realskills/T in pref.selectable_skills)
				pref.selectable_skills-=T
		pref.started_couldnt_edit_skills=1
		return




/datum/category_item/player_setup_item/realskills/proc/Initialize_Skills()
	pref.selectable_skills=list()
	for(var/R in typesof(/datum/realskills)-/datum/realskills)
		var/datum/realskills/T=R
		var/datum/realskills/S=new T()
		pref.selectable_skills+=S
	return
/datum/category_item/player_setup_item/realskills/content(var/mob/user)
	. = list()
	if(Can_Change_Skills)
		if(pref.started_couldnt_edit_skills)
			Initialize_Skills()
			pref.started_couldnt_edit_skills=0
		.+="<b>Skill Points:[pref.skill_points_used]/[pref.max_skill_points]</b><br>"
		for(var/datum/realskills/S in pref.selectable_skills)
			. +="<b>[S.name]([S.points]):</b>"
			. += "<a href='?src=\ref[src];[S.name]_down=1'><b><</b></a>"
			. += "<a href='?src=\ref[src];[S.name]_up=1'><b>></b></a><br>"
		. += "<a href='?src=\ref[src];reset_skills=1'><b>Reset</b></a>"
	else
		.+="<b>You are not allowed to change your skills</b><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/realskills/proc/update_skill_points()
	var/total_points_used=0
	for(var/datum/realskills/S in pref.selectable_skills)
		var/skillptvalue=S.points-initial(S.points)
		if(total_points_used+skillptvalue>pref.max_skill_points||S.points>15)//so if this skill makes the points go over max,
			S.points=initial(S.points)//reset the skill.
		else
			total_points_used+=skillptvalue
	pref.skill_points_used=total_points_used

/datum/category_item/player_setup_item/realskills/OnTopic(var/href,var/list/href_list, var/mob/user)
	update_skill_points()
	if(href_list["reset_skills"])//reset_skills
		reset_skills()
	for(var/datum/realskills/S in pref.selectable_skills)
		if(href_list["[S.name]_up"])
			if(pref.skill_points_used<pref.max_skill_points&&S.points+1<=15)
				S.points+=1
		if(href_list["[S.name]_down"])
			if(S.points>initial(S.points))//1)
				S.points-=1
	update_skill_points()
	return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/category_item/player_setup_item/realskills/proc/get_skill_from_name(n)
	for(var/datum/realskills/T in pref.selectable_skills)
		if(T.name==n)
			return T
/datum/category_item/player_setup_item/realskills/proc/reset_skills()
	for(var/datum/realskills/T in pref.selectable_skills)
		T.points=initial(T.points)
	update_skill_points()

/datum/category_item/player_setup_item/realskills/load_character(var/savefile/S)
	reset_skills()
	var/list/L=list()
	S["selectable_skills"]>>L
	if(islist(L))
		for(var/datum/realskills/T in L)
			var/datum/realskills/R=get_skill_from_name(T.name)
			if(R)
				R.points=T.points
	update_skill_points()

/datum/category_item/player_setup_item/realskills/save_character(var/savefile/S)
	S["selectable_skills"]<<pref.selectable_skills
	update_skill_points()

