/proc/Get_Water_By_Turf(turf/T)
	if(T)
		if(T.contents)
			for(var/obj/effect/actual_water/A in T.contents)
				if(A)
					return A
				else
					return 0
	return 0

/proc/get_cardinal_turfs(ref)
	var/list/turflist=list()
	if(get_step(ref,NORTH))
		turflist+=get_step(ref,NORTH)
	if(get_step(ref,SOUTH))
		turflist+=get_step(ref,SOUTH)
	if(get_step(ref,EAST))
		turflist+=get_step(ref,EAST)
	if(get_step(ref,WEST))
		turflist+=get_step(ref,WEST)
	if(turflist.len)
		return turflist

/proc/get_cardinal_open_turfs(ref)
	var/list/turflist=list()
	if(get_step(ref,NORTH)&&istype(get_step(ref,NORTH),/turf/simulated/floor))
		turflist+=get_step(ref,NORTH)
	if(get_step(ref,SOUTH)&&istype(get_step(ref,SOUTH),/turf/simulated/floor))
		turflist+=get_step(ref,SOUTH)
	if(get_step(ref,EAST)&&istype(get_step(ref,EAST),/turf/simulated/floor))
		turflist+=get_step(ref,EAST)
	if(get_step(ref,WEST)&&istype(get_step(ref,WEST),/turf/simulated/floor))
		turflist+=get_step(ref,WEST)
	if(turflist.len)
		return turflist

/proc/get_cardinal_open_non_flooded_turfs1(ref)
	var/list/turflist=list()
	if(get_step(ref,NORTH)&&istype(get_step(ref,NORTH),/turf/simulated/floor)&&!get_step(ref,NORTH).flooded)
		turflist+=get_step(ref,NORTH)
	if(get_step(ref,SOUTH)&&istype(get_step(ref,SOUTH),/turf/simulated/floor)&&!get_step(ref,SOUTH).flooded)
		turflist+=get_step(ref,SOUTH)
	if(get_step(ref,EAST)&&istype(get_step(ref,EAST),/turf/simulated/floor)&&!get_step(ref,EAST).flooded)
		turflist+=get_step(ref,EAST)
	if(get_step(ref,WEST)&&istype(get_step(ref,WEST),/turf/simulated/floor)&&!get_step(ref,WEST).flooded)
		turflist+=get_step(ref,WEST)
	if(turflist.len)
		return turflist

/proc/pickrandomoutoflistandremove(var/list/R =list())
	var/T
	if(R.len)
		T=pick(R)
		if(T)
			R-=T
	return T

/proc/get_cardinal_open_non_flooded_turfs(ref,force=1)
	var/list/turflist=list()
	if(get_step(ref,NORTH)&&istype(get_step(ref,NORTH),/turf/simulated/floor))
		turflist+=get_step(ref,NORTH)
	if(get_step(ref,SOUTH)&&istype(get_step(ref,SOUTH),/turf/simulated/floor))
		turflist+=get_step(ref,SOUTH)
	if(get_step(ref,EAST)&&istype(get_step(ref,EAST),/turf/simulated/floor))
		turflist+=get_step(ref,EAST)
	if(get_step(ref,WEST)&&istype(get_step(ref,WEST),/turf/simulated/floor))
		turflist+=get_step(ref,WEST)
	if(turflist.len)
		for(var/turf/T in turflist)
			if(force>1)
				for(var/obj/O in T.contents)
					if(!ismovable(O))
						turflist-=T
			else
				for(var/obj/O in T.contents)
					if(!Water_Can_Pass(O))
						turflist-=T
	return turflist
/proc/Water_Can_Pass(obj/O,obj/effects/actual_water/A)
	if(O)
		if(istype(O,/obj/machinery/door))
			if(!O.density)
				return 1
			else
				return 0
		if(istype(O,/obj/machinery))
			return 1
		if(istype(O,/obj/structure/table))
			return 1
		if(istype(O,/obj/structure/window))
			return 0
		if(istype(O,/obj/structure/bed))
			return 1
		if(istype(O,/obj/structure))
			return 1
		if(!O.density)
			return 1
		return 0

/obj/effect/actual_water/proc/do_water()
	HandleTemp()
	handle_water_reagents()
	update_icons()
	if(amount>1&&state==WATERLIQUID&&liquid_reagent_contents.total_volume>10)
		var/list/L=get_cardinal_open_non_flooded_turfs(src,force)
		if(L.len)
			var/D=round(amount/L.len,1)
			if(!D)
				return
			if(D)
				var/i
				for(i=L.len;i>0;i--)
					if(amount>1&&amount-D>1)
						var/turf/nexturf=pickrandomoutoflistandremove(L)
						if(!Get_Water_By_Turf(nexturf))
							//new/obj/effect/actual_water(nexturf,D)
							new src.type(nexturf,D)
							MoveObjs(nexturf)
							amount-=D
						else
							var/obj/effect/actual_water/W=Get_Water_By_Turf(nexturf)
							W.amount+=D
							amount-=D
							MoveObjs(nexturf)
	if(amount<=0||liquid_reagent_contents.total_volume<=0)
		qdel(src)
/obj/effect/actual_water/proc/handle_water_reagents()
	if(amount>=1)
		liquid_reagent_contents.maximum_volume=amount*10

		var/datum/reagents/tempcont=new(liquid_reagent_contents.total_volume,src)

		if(liquid_reagent_contents.total_volume>liquid_reagent_contents.maximum_volume)
			liquid_reagent_contents.trans_to_holder(tempcont,liquid_reagent_contents.total_volume-liquid_reagent_contents.maximum_volume)
			tempcont.Destroy()
		if(liquid_reagent_contents.get_free_space())
			liquid_reagent_contents.add_reagent(base_reagent,liquid_reagent_contents.get_free_space())
	else
		liquid_reagent_contents.clear_reagents()
	var/icon/I=icon(src.icon,icon_state)
	I.Blend(liquid_reagent_contents.get_color(),ICON_ADD)
	src.icon=I
	for(var/mob/living/carbon/C in loc)// Mobs that are in the liquid, will be affected by the chemcial
		for(var/datum/reagent/R in liquid_reagent_contents.reagent_list)
			R.affect_touch(C,null,R.volume)



