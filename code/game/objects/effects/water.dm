#define WATERLIQUID 1
#define WATERSOLID 2
#define ARMSTRONGLIMIT         6.25 // kPa.
/obj/effect/actual_water
	name="Water"
	desc="Thats water!"
	icon='icons/obj/water.dmi'
	icon_state="Water"
	var/amount=5
	var/force = 1 //if the water is fast enough to break things
	var/state = WATERLIQUID //1 liquid 2 solid
	var/temp
	var/datum/reagents/liquid_reagent_contents=null
	var/datum/reagent/base_reagent=/datum/reagent/water//null
	var/reagent_volume=0

/obj/effect/actual_water/strong
	force=2

/obj/effect/actual_water/strong/New(T,am=4,frc=1)
	..(T,am,frc)
	amount=2
	force=2

/obj/effect/actual_water/proc/HandleTemp()
	var/turf/heat_turf=get_turf(src)
	if(heat_turf)
		temp = heat_turf.temperature
		var/datum/gas_mixture/environment = heat_turf ? heat_turf.return_air() : null
		var/pressure =  environment ? environment.return_pressure() : 0
		if(water_boil_temp(pressure,temp))
			visible_message("<span class='danger'>The water boils away</span>")
			qdel(src)
			return
		if(temp<=T0C&&!state==WATERSOLID)//Is it freezing or below?
			state=WATERSOLID
			return
		else
			state=WATERLIQUID

/proc/water_boil_temp(pressure,temp)
	if(pressure>=ONE_ATMOSPHERE&&temp>=373.15)//100 kpa and 100 C or greater
		return TRUE
	if(pressure>=ONE_ATMOSPHERE/2&&temp>=348.15)//50 kpa and 75 C or greater
		return TRUE
	if(pressure>=ONE_ATMOSPHERE/3&&temp>=328.15)//30 kpa and 55 C or greater
		return TRUE
	if(pressure>=ONE_ATMOSPHERE/4&&temp>=323.15)//25 kpa and 50 C or greater
		return TRUE
	if(pressure>=ONE_ATMOSPHERE/6&&temp>=318.15)//17 kpa and 45 C or greater
		return TRUE
	if(pressure>=ARMSTRONGLIMIT&&temp>=309.817)//6 kpa and 37 C or greater
		return TRUE
	if(pressure<=ARMSTRONGLIMIT&&temp<=309.817)//6 kpa and 37 C or greater
		return TRUE
	return FALSE

/obj/effect/actual_water/proc/MoveObjs(nextturf)
	for(var/obj/O in get_turf(src))
		if(!O.anchored&&!istype(O,/obj/effect/actual_water))
			O.throw_at(nextturf, O.throw_range, O.throw_speed)
	for(var/mob/M in get_turf(src))
		if(istype(M,/mob/observer/ghost))
			continue
		if(force>1)
			M.throw_at(nextturf,1,1)

/obj/effect/actual_water/New(T,am=4,frc=1)
	amount=am
	force=frc
	if(isturf(T))
		var/turf/TT=T
		if(TT.flooded)
			qdel(src)
		else
			TT.flooded=amount
	liquid_reagent_contents=new/datum/reagents(amount*10,src)
	//liquid_reagent_contents.maximum_volume=amount*10
	liquid_reagent_contents.add_reagent(base_reagent,liquid_reagent_contents.get_free_space())
	GLOB.water_obj+=src
	update_icons()
	..(T)

/obj/effect/actual_water/Del()
	var/turf/T=get_turf(src)
	if(T&&T.flooded)
		T.flooded=0
	GLOB.water_obj-=src
	..()

/obj/effect/actual_water/proc/update_icons()
	src.alpha=30*amount
	if(amount<=1)
		src.plane=OBJ_PLANE
	if(amount>4)
		src.plane=ABOVE_HUMAN_PLANE
	switch(state)
		if(WATERSOLID)
			density=1
			icon_state="WaterFrozen"
		if(WATERLIQUID)
			density=0
			icon_state="Water"

/obj/effect/actual_water/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/Container=I
		var/cont_free_space=Container.reagents.get_free_space()
		if(cont_free_space>=10&&amount>=1)//You can only fill up containers in incriments of 10 currently, 1 amount of liquid is 10 units of reagent. 10:1 ratio
			liquid_reagent_contents.trans_to_holder(Container.reagents,10)
			amount-=1
			visible_message("<span class='notice'>[user] fills [cont_free_space>=10 ? "some of the" : "all of the"] [I] up with the [src]</span>")
			return
	..()





