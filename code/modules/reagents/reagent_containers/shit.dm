/obj/item/weapon/reagent_containers/poop
	name = "Poop"
	desc = "Thats poop!"
	icon = 'icons/obj/wastes.dmi'
	icon_state="shit1"
	volume = 60
/obj/item/weapon/reagent_containers/poop/examine(var/mob/user)
	..(user)
/obj/item/weapon/reagent_containers/poop/attack_self()

/obj/item/weapon/reagent_containers/poop/attack(mob/M as mob, mob/user as mob, def_zone)
	..()

/obj/item/weapon/reagent_containers/poop/New()
	..()
	icon_state = pick("shit1","shit2","shit3","shit4")