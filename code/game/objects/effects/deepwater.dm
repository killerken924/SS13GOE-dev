#define WATERLIQUID 1
#define WATERSOLID 2
#define ARMSTRONGLIMIT         6.25 // kPa.
/obj/effect/actual_water/deep //meaning no amount, just deep water
	plane=ABOVE_HUMAN_PLANE
	amount=2
	force=2
/obj/effect/actual_water/deep/do_water()
	HandleTemp()
	update_icons()
	if(amount>1&&state==WATERLIQUID)
		var/list/L=get_cardinal_open_non_flooded_turfs(src,force)
		if(L.len)
			var/i
			for(i=L.len;i>0;i--)
				if(amount>1)
					var/turf/nexturf=pickrandomoutoflistandremove(L)
					if(!Get_Water_By_Turf(nexturf))
						new/obj/effect/actual_water/deep(nexturf,amount,force)
						MoveObjs(nexturf)
					else
						var/obj/effect/actual_water/A=Get_Water_By_Turf(nexturf)
						if(!istype(A,/obj/effect/actual_water/deep))
							A.amount+=rand(15,50)
							A.force=force
							MoveObjs(nexturf)
	if(amount<=0)
		qdel(src)
/obj/effect/actual_water/deep/New(T,am=4,frc=1)
	..(T,am,frc)
	amount=2
	force=2
/obj/effect/actual_water/deep/update_icons()
	switch(state)
		if(WATERSOLID)
			density=1
			icon_state="WaterFrozen"
		if(WATERLIQUID)
			density=0
			icon_state="Water"
			src.alpha=200
