
SUBSYSTEM_DEF(procedural)
	name = "procedural"
	init_order = INIT_ORDER_CAVES
	flags = SS_NO_FIRE
	var/startx=1//101
	var/starty=1//128
	var/endx=255//197
	var/endy=255//198
	var/z=3//1

/datum/controller/subsystem/procedural/Initialize()
	//var/turf/start=locate(startx,starty,z)
	//var/turf/end=locate(endx,endy,z)
	start_generate_mines()//generate_mines(start,end)
	..()
/datum/controller/subsystem/procedural/proc/start_generate_mines()
	if(GLOB.using_map.procgeneration_levels.len)
		for(var/Z in GLOB.using_map.procgeneration_levels)
			var/start_xcord=GLOB.using_map.procgeneration_cords["xmin"]
			var/end_xcord=GLOB.using_map.procgeneration_cords["xmax"]
			var/start_ycord=GLOB.using_map.procgeneration_cords["ymin"]
			var/end_ycord=GLOB.using_map.procgeneration_cords["ymax"]
			if(start_xcord&&end_xcord&&start_ycord&&end_ycord)
				new/datum/procgenerator(start_xcord,start_ycord,end_xcord,end_ycord,Z)
			else
				new/datum/procgenerator(startx,starty,endx,endy,Z)
		return

