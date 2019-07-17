
/datum/job/proc/equip_skills(var/mob/living/carbon/human/H)
	//Get_Adv_Skill(t)
	equip_basic_skills(H)
	equip_advance_skills(H)

/datum/job/proc/equip_basic_skills(var/mob/living/carbon/human/H)
	if(H.Skills&&H.Skills.skills.len)
		var/datum/realskills/ownerstrength=H.Skills.get_skill(/datum/realskills/strength)
		var/datum/realskills/ownerintelligence=H.Skills.get_skill(/datum/realskills/intelligence)
		var/datum/realskills/ownerendurance=H.Skills.get_skill(/datum/realskills/endurance)
		var/datum/realskills/owneragility=H.Skills.get_skill(/datum/realskills/agility)
		ownerstrength.points+=Strskill
		ownerintelligence.points+=Intskill
		ownerendurance.points+=Endskill
		owneragility.points+=Agiskill

/datum/job/proc/equip_advance_skills(var/mob/living/carbon/human/H)

	var/datum/advance_skills/SurgerySkill=H.Get_Adv_Skill(/datum/advance_skills/surgery_skill)
	SurgerySkill.points+=Job_Surgical_Skill

	var/datum/advance_skills/MeleeSkills=H.Get_Adv_Skill(/datum/advance_skills/melee_fighting)
	MeleeSkills.points+=Job_MeleeSkill
