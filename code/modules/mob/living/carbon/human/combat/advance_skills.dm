/datum/advance_skills
	var/points=0
	var/name="Skills"
	var/desc="Skills"
	var/mob/living/carbon/human/owner=null

/datum/advance_skills/New(var/mob/living/carbon/human/H)
	calculate_base()
	if(H.advance_skills&&H.advance_skills.Find(src.type))
		qdel(src)
		return 0
	if(H.advance_skills)
		H.advance_skills+=src
	owner=H
	calculate_base()

/datum/advance_skills/proc/calculate_base()
	return

/datum/advance_skills/melee_fighting
	name="Unarmed Melee"
	desc="You Unarmed melee fighting ability"
/datum/advance_skills/melee_fighting/calculate_base()
	if(owner&&owner.Skills)
		var/Str=owner.Skills.get_skill(/datum/realskills/strength).points
		var/End=owner.Skills.get_skill(/datum/realskills/endurance).points
		var/Agi=owner.Skills.get_skill(/datum/realskills/agility).points
		var/pnt_total=0
		pnt_total+=Agi/2
		pnt_total+=End/2
		pnt_total+=Str/3
		points=max(0,round(pnt_total,1))

/datum/advance_skills/sword_fighting
	name="Sword Fighting"
	desc="Your Sword Fighting Ability"

/datum/advance_skills/sword_fighting/calculate_base()
	if(owner&&owner.Skills)
		var/Str=owner.Skills.get_skill(/datum/realskills/strength).points
		var/End=owner.Skills.get_skill(/datum/realskills/endurance).points
		var/Agi=owner.Skills.get_skill(/datum/realskills/agility).points
		var/pnt_total=0
		pnt_total+=Agi/2
		pnt_total+=End/2
		pnt_total+=Str/3
		points=max(0,round(pnt_total,1))

/datum/advance_skills/spear_fighting
	name="Spear Fighting"
	desc="Your Spear Fighting Ability"

/datum/advance_skills/sword_fighting/calculate_base()
	if(owner&&owner.Skills)
		var/Str=owner.Skills.get_skill(/datum/realskills/strength).points
		var/End=owner.Skills.get_skill(/datum/realskills/endurance).points
		var/Agi=owner.Skills.get_skill(/datum/realskills/agility).points
		var/pnt_total=0
		pnt_total+=Agi/2
		pnt_total+=End/2
		pnt_total+=Str/3
		points=max(0,round(pnt_total,1))

/datum/advance_skills/shields
	name="Shield Defence"
	desc="Your Shield Defence Ability"

/datum/advance_skills/shields/calculate_base()
	if(owner&&owner.Skills)
		var/Str=owner.Skills.get_skill(/datum/realskills/strength).points
		var/End=owner.Skills.get_skill(/datum/realskills/endurance).points
		var/Agi=owner.Skills.get_skill(/datum/realskills/agility).points
		var/pnt_total=0
		pnt_total+=Agi/2
		pnt_total+=End/2
		pnt_total+=Str/3
		points=max(0,round(pnt_total,1))


proc/show_advance_skills_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return

	if(!M.advance_skills||!M.advance_skills.len)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = list()
	HTML += "<body>"
	HTML += "<b>Skills: [M]</b><br>"
	HTML += "<table>"
	var/list/Skills=M.advance_skills
	for(var/datum/advance_skills/S in Skills)
		HTML += "<b>[S.name]:[S.points]</b>"
		HTML += "<br>"
	HTML += "</table>"

	show_browser(user, null, "window=preferences")
	show_browser(user, jointext(HTML, null), "window=show_adv_skills;size=700x900")

/mob/living/carbon/human/verb/show_advance_skills()
	set category = "IC"
	set name = "Show Skills"

	show_advance_skills_window(src, src)

/mob/living/carbon/human/proc/Create_Advance_Skills()
	var/list/advcskill=list()
	for(var/R in typesof(/datum/advance_skills)-/datum/advance_skills)
		var/datum/advance_skills/T=R
		var/datum/advance_skills/S=new T(src)
		advcskill+=S
	advance_skills=advcskill
	return
/mob/living/carbon/human/proc/Get_Adv_Skill(t)
	for(var/datum/advance_skills/S in advance_skills)
		if(S.type==t)
			return S
			break
	return 0
/datum/job
	//These are the base skills that come with the job.These add on to each individual skills points
	var/Strskill=0
	var/Intskill=0
	var/Endskill=0
	var/Agiskill=0
	//These are the advance skills that come with the job
	var/Job_MeleeSkill=0
	var/Job_Surgical_Skill=0



