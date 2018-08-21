/mob/living/carbon/human
	var/datum/realskill_set/Skills=null

/datum/realskill_set
	var/list/skills=list()
	var/mob/living/carbon/owner=null

/datum/realskill_set/New(var/mob/living/carbon/C)
	if(C)
		owner=C

/datum/realskills
	var/name
	var/points=0
	var/desc
	var/effective_points=0
/datum/realskills/New()
	points=0
/datum/realskills/strength
	name="Strength"
	desc="Strength is a measure of your raw physical power"

/datum/realskills/intelligence
	name="Intelligence"
	desc="Intelligence is the measure of your overall mental acuity, and affects the number of experience points earned"

/datum/realskills/endurance
	name="Endurance"
	desc="Endurance is the measure of overall physical fitness. It affects your total health and the action point drain from sprinting"

/datum/realskills/agility
	name="Agility"
	desc="Agility is a measure of your overall finesse and reflexes"

/datum/realskill_set/proc/get_skill(type)
	for(var/datum/realskills/T in skills)
		if(T.type==type)
			return T

/mob/living/carbon/human/proc/get_effective_skills()
	return
/mob/living/carbon/human/proc/Populate_Basic_Skills()//used for people who didn't spawn through lobby
	Skills.skills=list()
	var/list/L=list()
	var/skill_points_used=rand(10,19)
	for(var/R in typesof(/datum/realskills)-/datum/realskills)
		var/datum/realskills/T=R
		var/datum/realskills/S=new T()
		if(skill_points_used)
			S.points+=rand(0,skill_points_used)
			skill_points_used-=S.points
		L+=S
	Skills.skills=L
	return

