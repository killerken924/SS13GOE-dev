/proc/generate_credit_text()
	var/list/round_credits = list()
	var/len_before_addition

	// Survivors
	//round_credits += "<center><h2>[mode.name]</h1>"
	round_credits += "<br>"
	round_credits += "<center><h2>The Survivors:</h2>"
	len_before_addition = round_credits.len
	for(var/mob/living/H in GLOB.living_mob_list_)
		if(ishuman(H))
			round_credits += "<center><h3>[H]</h3>"
	if(round_credits.len == len_before_addition)
		round_credits += "<center><h3>There were no survivors!</h3>"
	round_credits += "<br>"
	// Dead
	round_credits += "<center><h2>The Survivors:</h2>"
	len_before_addition = round_credits.len
	for(var/mob/living/H in GLOB.dead_mob_list_)
		if(ishuman(H))
			round_credits += "<center><h3>In memory of [H]</h3>"
	if(round_credits.len == len_before_addition)
		round_credits += "<center><h3>There were no deaths</h3>"

	round_credits += "<br>"

	round_credits += "<br>"
	round_credits += "<br>"
	round_credits += "<center><h1>Thanks for playing</h1>"


	return round_credits
