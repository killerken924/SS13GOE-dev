/datum/reagent/nutriment/shit
	name = "Human Waste"
	description = "Everything the human body doesn't want"
	taste_mult = 4
	reagent_state = SOLID
	taste_description = "Horrible"
	metabolism = REM
	nutriment_factor = 0.3 // Per unit
	color = "#3d2111"

/datum/reagent/nutriment/shit/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(3 * removed)

/datum/reagent/nutriment/shit/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += nutriment_factor * removed // For hunger and fatness

/datum/reagent/nutriment/protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(6 * removed)

/datum/reagent/toxin/urine
	name = "Human Urine"
	description = "From a human, huh..."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = LIQUID
	color = "#968610"
	metabolism = REM * 0.25 // 0.05 by default. They last a while and slowly kill you.

/datum/reagent/toxin/urine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	//M.heal_organ_damage(0.5 * removed, 0) //what
	M.add_chemical_effect(CE_TOXIN, 0.5)

	//adjust_nutrition(M, alien, removed/4)
	M.add_chemical_effect(CE_BLOODRESTORE, removed)

/datum/reagent/toxin/urine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)//Don't swim in pee. seriously.
	..()
	M.add_chemical_effect(CE_TOXIN, 0.1)
	M.adjustToxLoss(removed/10)

/obj/effect/actual_water/urine
	name = "Yellow Water"
	base_reagent=/datum/reagent/toxin/urine//null


