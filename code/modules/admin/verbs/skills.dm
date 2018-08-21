/client/proc/Toggle_Can_Change_Skills()
	set category = "Special Verbs"
	set name = "Toggle Skill Change"
	set desc = "Allow the players to edit there skills in the lobby"

	Can_Change_Skills=!Can_Change_Skills
	to_chat(world,"<span class ='notice'>[Can_Change_Skills ? "You may now edit your skill in the lobby" :"You may no longer edit your skill in the lobby" ]</span>")
